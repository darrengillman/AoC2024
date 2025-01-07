import Foundation
import AoCTools

struct Day04: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let day = 4
   let puzzleName: String = "--- Day 4 ---"
   let grid: [Point: Character]
   
   init(data: String) {
      let lines = data.components(separatedBy: .newlines)
      var grid: [Point: Character] = [:]
      for y in lines.indices {
         let line = lines[y].map{$0}
         for x in line.indices {
            grid[.init(x,y)] = line[x]
         }
      }
      self.grid = grid
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      grid
         .filter{$0.value == "X"}
         .map{Move.init(point: $0.key, step: 1, heading: nil, history: [], word: "XMAS")}
         .flatMap{$0.nextMoves(in: grid)}
         .flatMap{$0.nextMoves(in: grid)}
         .flatMap{$0.nextMoves(in: grid)}
         .count

   }
   
   func part2() async throws -> Int {
      grid
         .filter{$0.value == "M"}
         .map{Move.init(point: $0.key, step: 1, heading: nil, history: [], word: "MAS")}
         .flatMap{$0.nextMoves(in: grid)}
         .flatMap{$0.nextMoves(in: grid)}
         .filter{[Heading.SW, .SE, .NE, .NW].contains($0.directions.first!)}
         .reduce(into: [Point: [Move]]()) {dict, move in
            dict[move.history[1], default: []].append(move)
            
         }
         .count{$0.value.count == 2}
   }
}


// Add any extra code and types in here to separate it from the required behaviour
extension Day04 {}

struct Point: Equatable, Hashable {
   let x: Int
   let y: Int
   
   public init(_ x: Int, _ y: Int) {
      self.x = x
      self.y = y
   }
}

enum Heading: CaseIterable, Hashable {
   case N, S, E, W, NE, SE, SW, NW
   
   static func headings(diagonal: Bool) -> [Heading] {
      switch diagonal {
         case false: [.N, .S, .E, .W]
         case true: Heading.allCases
      }
   }
   
   func moving(step: Int = 1 ) -> (heading: Heading, x: Int, y: Int) {
      switch self {
         case .N: (.N, 0, -step)
         case .S: (.S, 0, step)
         case .E: (.E, step, 0)
         case .W: (.W, -step ,0)
         case .NE: (.NE, step, -step)
         case .SE: (.SE, step, step)
         case .SW: (.SW, -step, step)
         case .NW: (.NW, -step, -step)
      }
   }
}


struct Move {
   internal init(point: Point, step: Int, heading: Heading?, history: [Point], word: String) {
      self.point = point
      self.step = step
      self.heading = heading
      self.history = history
      self.targetWord = word
   }
   
   let point: Point
   let step: Int
   let targetWord: String
   private var heading: Heading?
   var history: [Point] = []
   
   var target: Character {
      targetWord.map{$0}[history.count + 1]
   }
   
   var directions: [Heading] {
      if let heading {
         [heading]
      } else {
         Heading.headings(diagonal: true)
      }
   }
   
   func nextMoves(in grid: [Point: Character]) -> [Move] {
      directions
         .map {$0.moving(step: step)}
         .map{
            Move(
               point: .init(point.x + $0.x, point.y + $0.y),
               step: step,
               heading: $0.heading,
               history: history + [point],
               word: targetWord
            )
         }
         .filter{grid[$0.point] == target}
   }
}



