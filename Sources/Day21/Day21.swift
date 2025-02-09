import Foundation
import Collections

struct Day21: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let day = 21
  let puzzleName: String = "--- Day 21 ---"

  init(data: String) {
    self.data = data
  }
   
   func part1() async throws -> Int {
      run(loops: 3)
   }

  // Replace this with your solution for the first part of the day's challenge.
   func run(loops: Int) -> Int {
      var complexity = 0
      let codes = data
         .components(separatedBy: .newlines)
         .map{$0.trimmingCharacters(in: .whitespaces)}
         .filter{!$0.isEmpty}
      
      for code in codes {
         let codeValue = Int(code.compactMap{Int($0.asString)}.map{$0.asString}.joined() )!
         var robot1 = NumPad()
         var allButtonSequences: [ButtonSequence] = robot1.moves(for: code).shortest()
         
         for _ in 0..<loops {
            var generatedInstructionSets: [ButtonSequence] = []
            var robot = ArrowPad()
            
            for instructionSet in allButtonSequences {
               let newInstructionSets = robot.moves(for: instructionSet).shortest()
              // newInstructionSets.forEach{ print($0) }
               generatedInstructionSets.append(contentsOf: newInstructionSets)
            }
            
            allButtonSequences = generatedInstructionSets
         }
         
         let len = allButtonSequences.shortest().first!.count
         print(codeValue, len)
         complexity += codeValue * len
      }
      return complexity
   }
}


extension Sequence where Element == String {
   func shortest() -> [String]{
      let min = self.map(\.count).min()!
      return self.filter{$0.count == min}
   }
   
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day21 {
   typealias Route = [Point]
   typealias ButtonSequence = String
   enum Move: String {
      case up = "^"
      case down = "v"
      case right = ">"
      case left = "<"
      case push = "A"
   }
   
   struct NumPad {
      enum Key: String {
         case key1 = "1"
         case key2 = "2"
         case key3 = "3"
         case key4 = "4"
         case key5 = "5"
         case key6 = "6"
         case key7 = "7"
         case key8 = "8"
         case key9 = "9"
         case key0 = "0"
         case keyA = "A"
         case gap
      }
      
      let grid = [
         (0,0,"7"),
         (1,0,"8"),
         (2,0,"9"),
         (0,1,"4"),
         (1,1,"5"),
         (2,1,"6"),
         (0,2,"1"),
         (1,2,"2"),
         (2,2,"3"),
         (1,3,"0"),
         (2,3,"A"),
      ]
         .reduce(into: [Point(3,1): Key.gap]) {
            $0[.init($1.0, $1.1)] = Key(rawValue: $1.2)
         }

      var current = Key.keyA
      var currentPosition: Point { point(for: current) }
      
      
      mutating func moves(for input: ButtonSequence) -> [ButtonSequence] {
         var routes: [Route] = []
         for target in input {
            let key = Key(rawValue: target.asString)!
            let targetRoutes = allRoutes(to: key)
            if routes.isEmpty {
               routes = targetRoutes
            } else {
               var newRoutes: [Route] = []
               for i in routes.indices {
                  for j in targetRoutes.indices {
                     newRoutes.append (routes[i] + targetRoutes[j])
                  }
               }
               routes = newRoutes
            }
         }
         let moveSequences = routes
            .map{moves(for: $0) + [.push]}
            .map{$0.map{$0.rawValue}}
            .map{$0.joined()}
         
         return moveSequences
      }
     
      private func point(for key: Key) -> Point {
         grid.first{$0.value == key}!.key
      }
      
      func allRoutes(to: Key) -> [Route] {
         let end = point(for: to)
         var routes: [Route] = []
         var q: Deque<(point: Point, path: Route)> = [(currentPosition, [])]
         var visited = Set<Point>()
         
         while !q.isEmpty {
            let next = q.popFirst()!
            let newPath = next.path + [next.point]
            guard next.point != end else {
               routes.append(newPath)
               continue
            }
            
            let x = next
               .point
               .neighbours
               .filter{grid.keys.contains($0)}
               .filter{grid[$0] != .gap}
               .filter{!visited.contains($0)}
               .map{($0, newPath)}
            
            visited.insert(next.point)
            q.append(contentsOf: x)
         }
         return routes
      }
      
      private func moves(for route: Route) -> [Move] {
         route
            .adjacentPairs()
            .compactMap{ (a,b) in
               switch (a.x - b.x, a.y - b.y) {
                  case (1, 0): Move.left
                  case (-1, 0): Move.right
                  case (0, 1): Move.up
                  case (0, -1): Move.down
                  default: nil
               }
            }
      }
   }
   
   struct  ArrowPad {
      enum Key: String {
         case upKey = "^"
         case downKey = "v"
         case leftKey = "<"
         case rightKey = ">"
         case AKey = "A"
         case gap = " "
      }
      
      let grid = [
         (0, 0, " "),
         (1, 0, "^"),
         (2, 0, "A"),
         (0, 1, "<"),
         (1, 1, "v"),
         (2, 1, ">")
      ]
         .reduce(into: [Point: Key]()) {
            $0[.init($1.0, $1.1)] = Key(rawValue: $1.2)
         }
      
      var current = Key.AKey
      var currentPosition: Point { point(for: current) }

      mutating func moves(for input: ButtonSequence) -> [ButtonSequence] {
         var routes: [Route] = []
         for target in input {
            let key = Key(rawValue: target.asString)!
            let targetRoutes = allRoutes(to: key)
            if routes.isEmpty {
               routes = targetRoutes
            } else {
               var newRoutes: [Route] = []
               for i in routes.indices {
                  for j in targetRoutes.indices {
                     newRoutes.append (routes[i] + targetRoutes[j])
                  }
               }
               routes = newRoutes
            }
         }
         let moveSequences = routes
            .map{moves(for: $0) + [.push]}
            .map{$0.map{$0.rawValue}}
            .map{$0.joined()}
         
         return moveSequences
      }
      
      func allRoutes(to: Key) -> [Route] {
         let end = point(for: to)
         var routes: [Route] = []
         var q: Deque<(point: Point, path: Route)> = [(currentPosition, [])]
         var visited = Set<Point>()

         while !q.isEmpty {
            let next = q.popFirst()!
            let newPath = next.path + [next.point]
            guard next.point != end else {
               routes.append(newPath)
               continue
            }

            let x = next
               .point
               .neighbours
               .filter{grid.keys.contains($0)}
               .filter{grid[$0] != .gap}
               .filter{!visited.contains($0)}
               .map{($0, newPath)}

            visited.insert(next.point)
            q.append(contentsOf: x)
         }
         return routes
      }
      
      private func moves(for route: [Point]) -> [Move] {
         route
            .adjacentPairs()
            .compactMap{ (a,b) in
               switch (a.x - b.x, a.y - b.y) {
                  case (1, 0): Move.left
                  case (-1, 0): Move.right
                  case (0, 1): Move.up
                  case (0, -1): Move.down
                  default: nil
               }
            }
      }
      
      private func point(for key: Key) -> Point {
         grid.first{$0.value == key}!.key
      }
   }
}
