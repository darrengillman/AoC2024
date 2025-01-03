import Foundation
import RegexBuilder

struct Day15: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let day = 15
  let puzzleName: String = "--- Day 15 ---"

  init(data: String) {
    self.data = data
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() async throws -> Int {
     var game = Self.parse(input: data)
     game.runPt1()
     return game.score
  }
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day15 {
   enum Node: String, CustomStringConvertible {
      var description: String {self.rawValue}
      
      case robot = "@"
      case wall = "#"
      case box = "O"
      case space = "."
   }

   static func parse(input: String) -> Game {
      let nodeRegex = Regex {
         One(.anyOf("#.O@"))
      }
      
      let mapLineCapture = Regex {
         Anchor.startOfLine
         Capture {
            OneOrMore(nodeRegex)
         } transform: {
            $0.map{$0}
         }
         Anchor.endOfLine
      }
      
      let mapRegex = Regex {
         OneOrMore(mapLineCapture)
      }
      
      let directionRegex = Regex {
         One(.anyOf("^v<>"))
      }
      
      let movesCapture = Regex{
         Anchor.startOfLine
         Capture {
            OneOrMore(directionRegex)
         } transform: { string in
            string.map{ char in
               switch char {
                  case "^": Direction.U
                  case "v": Direction.D
                  case ">": Direction.R
                  case "<": Direction.L
                  default: fatalError("Ooops!")
               }
            }
         }
         Anchor.endOfLine
      }
      
      let nodeArray = input
         .matches(of: mapRegex)
         .map{ output in
            output.1.map {
               Node(rawValue: $0.asString)!
            }
         }
      
      let grid =
      (0..<nodeArray.count).reduce(into: [Point: Node]()) { dict, y in
         (0..<nodeArray[y].count).forEach { x in
            dict[.init(x, y)] = nodeArray[y][x]
         }
      }
      
      
      let moves = input
         .matches(of: movesCapture)
         .flatMap{
            $0.output.1
         }
      
      print("nodes: \(grid.count)")
      print("moves: \(moves.count)")
      
   
      return Game(grid: grid, moved: moves)
   }
   
   struct Game {
      var grid: [Point: Node]
      let moves: [Direction]
      var mi = 0
      var robot: Point
      
      var score: Int {
         grid
            .filter{$0.value == .box}
            .keys
            .reduce(0){$0 + 100 * $1.y + $1.x}
      }

      internal init(grid: [Point : Day15.Node], moved: [Direction]) {
         self.grid = grid
         self.moves = moved
         self.robot = grid.first(where: {(_, value) in
            value == .robot
         })!.key
      }
      
      mutating func nextDirection() -> Direction? {
         guard mi != moves.endIndex else {return nil}
         let move = moves[mi]
         mi += 1
         return move
      }
      
      func possibleMove(direction: Direction) -> [Point] {
         let maxX = grid.keys.map(\.x).max()!
         let maxY = grid.keys.map(\.y).max()!
         
         return switch direction {
            case .U: (0..<robot.y).map{Point(robot.x, $0)}.reversed()
            case .D: (robot.y+1...maxY).map{Point(robot.x, $0)}
            case .R: ((robot.x+1)...maxX).map{Point($0, robot.y)}
            case .L: (0..<robot.x).map{Point($0, robot.y)}.reversed()
         }
      }

      mutating func runPt1() {
         grid.print()
         while let direction = nextDirection() {
//            print("At \(robot) moving: \(direction) to", terminator: "")
            move(in: direction)
//            print(robot)
//            grid.print()
//            print("----------------------------")
         }
//         grid.print()
      }
      
      mutating func move(in direction: Direction) {
         let path1 = possibleMove(direction: direction)
        
         let path = path1.prefix(while: {grid[$0] != .wall})
//         print(path1, " --> ", path)
         guard var spaceIndex = path.firstIndex(where: {grid[$0] == .space}) else {return}

         while spaceIndex != 0 {
            grid[path[spaceIndex]] = grid[path[spaceIndex-1]]
            spaceIndex -= 1
         }
         grid[path[0]] = .robot
         grid[robot] = .space
         robot = path[0]
      }
   }
}

extension Dictionary where Key == Point, Value: CustomStringConvertible {
   func print() {
      guard let maxY = self.keys.map(\.y).max()else {return}
      for y in 0...maxY {
         let line = self.filter{$0.key.y == y}.sorted{$0.key.x < $1.key.x}.map(\.value.description).joined()
         Swift.print(line)
      }
   }
}
