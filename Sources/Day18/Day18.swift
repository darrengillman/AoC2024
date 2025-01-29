import Collections
import Foundation
import RegexBuilder

struct Day18: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let day = 18
  let puzzleName: String = "--- Day 18: ---"
   
   init(data: String) {
      self.data = data
  }

  func part1() async throws -> String {
     runPt1(bytes: 1024).asString
  }
   
   func part2() async throws -> String {
      runPt2(bytes: 1024).description
   }
   
   func runPt1(bytes: Int) -> Int {
      let input = data.components(separatedBy: .newlines).prefix(bytes).joined(separator: "\n")
      let grid = Grid(input: input)
      return grid.shortest()
   }
   
   func runPt2(bytes: Int) -> Point {
      let points = Day18.Grid.parse(data)
      let base = points.prefix(bytes).asArray()
      var extras = points.dropFirst(bytes)
      var point: Point!
      var grid = Grid(points: base)
      
      while grid.shortest() != -1 {
         point = extras.popFirst()!
         grid.addCorruption(at: point)
      }
      return point
   }
      
}

extension Day18 {
   enum Location: CustomStringConvertible {
      var description: String {
         switch self {
            case .safe: return "."
            case .corrupted: return "#"
         }
      }
      case safe, corrupted
   }
   
   struct Grid {
      static func parse(_ input: String) -> [Point] {
         let intCap = Regex {
            Capture {
               OneOrMore {
                  .digit
               }
            } transform: {
               Int($0)!
            }
         }
         
         let pointCap = Regex {
            intCap
            ","
            intCap
         }
         
         return input
            .matches(of: pointCap)
            .map{Point($0.output.1, $0.output.2)}
      }
      
      var memory: [Point: Location]
      var maxX, maxY: Int
      
      init(input: String) {
         let points = Grid.parse(input)
         self.init(points: points)
      }
      
      init(points: [Point]) {
         memory = points
            .reduce(into: [Point: Location]() ) {dict, point in
               dict[point] = .corrupted
            }
         
         if memory.count > 1000 {
            maxX = 70
            maxY = 70
         } else {
            maxX = 6
            maxY = 6
         }
      }
         
      mutating func addCorruption(at point: Point) {
         memory[point] = .corrupted
      }
      
      enum GridErrro: Error {
         case noRoute
      }
      
      func shortest() -> Int {
         let start = Point(0,0)
         let end = Point(maxX, maxY)
         var queue: Deque<(point: Point, steps: Int)> = [(start, 0)]
         var visited: Set<Point> = []
         
         while let current = queue.popFirst() {
            guard !visited.contains(current.point) else {
               continue
            }
            guard current.point != end else {
               return current.steps
            }
            visited.insert(current.point)
            
            let points = current
               .point
               .neighbours
            
            let options = points
               .filter{ 0...maxX ~= $0.x && 0...maxY ~= $0.y}
               .filter{memory[$0] != .corrupted}
               .map{($0, current.steps + 1)}
            
            queue.append(contentsOf: options)
         }
         return -1
      }
   }
}
