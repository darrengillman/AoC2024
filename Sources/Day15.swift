import Foundation
import RegexBuilder

struct Day15: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let day = 0
  let puzzleName: String = "--- Day 0: Placeholder! ---"

  init(data: String) {
    self.data = data
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() async throws -> Int {
    0
  }
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day15 {
   enum Node: String {
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
         .first!
         .output.1
      
      print(grid.count)
      print(moves.count)
      
   
      return Game(grid: grid, moved: moves)
   }
   
   struct Game {
      var grid: [Point: Node]
      let moves: [Direction]
      var mi = 0
      let robot: Point

      internal init(grid: [Point : Day15.Node], moved: [Direction]) {
         self.grid = grid
         self.moves = moved
         self.robot = grid.first(where: {(_, value) in
            value == .robot
         })!.key
      }
      
      mutating func nextMove() -> Direction {
         let move = moves[mi]
         mi += 1
         return move
      }
      
      




   }
   
   
}
