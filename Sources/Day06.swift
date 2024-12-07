import Foundation
import AoCTools

struct Day06: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   var map: Set<Point> = []
   var grid: [[String]]
   
   let moveSet = Set(arrayLiteral: "v", ">", "<", "^")
   
   let day = 6
   let puzzleName: String = "--- Day 6 ---"
   let rangeX, rangeY: Range<Int>
   
   init(data: String) {
      grid = data
         .components(separatedBy: .newlines)
         .map{$0.map{$0}}
         .map{$0.map{$0.asString()}}
      rangeX = 0 ..< grid.first!.count
      rangeY = 0 ..< grid.count
      
      for y in 0..<grid.count {
         for x in 0..<grid[y].count {
            if grid[y][x] == "#" {
               map.insert(.init(x, y))
            }
         }
      }
   }
   
   func part1() async throws -> Int {
      let (start, direction) = findStart()!
      var guardess = Guardess(location: start, direction: direction, xRange: rangeX, yRange: rangeY)
      while guardess.inBounds {
         guardess.move(in: map)
      }
      return guardess.steps
   }
}

   // Add any extra code and types in here to separate it from the required behaviour
extension Day06 {
   
   func findStart() -> (Point, Heading)? {
      for y in 0..<grid.count {
         for x in 0..<grid[y].count {
            let square = grid[y][x]
            if moveSet.contains(square) {
               return (Point(x,y), Heading.heading(from: DirectionIndicator(rawValue: square)!))
            }
         }
      }
      return nil
   }
   
   struct Guardess: Sendable {
      var location: Point
      var direction: Heading
      var visited: Set<Point>
      let xRange, yRange: Range<Int>
      var steps: Int {visited.count - 1}  //final out of bounds is added to set - CBA to fix it :)
      
      init(location: Point, direction: Heading, xRange: Range<Int>, yRange: Range<Int>) {
         self.location = location
         self.direction = direction
         self.xRange = xRange
         self.yRange = yRange
         self.visited = [location]
      }

      var inBounds: Bool {
         xRange ~= location.x && yRange ~= location.y
      }
      
      mutating func move(in map: Set<Point>) {
         let (_, dX, dY) = direction.moving()
         let forward = Point(location.x + dX, location.y + dY)
         if map.contains(forward) {
            direction = direction.turn()
         } else {
            location = forward
            visited.insert(forward)
         }
      }
   }
   
   enum DirectionIndicator: String {
      case D = "v"
      case R = ">"
      case L = "<"
      case U = "^"
   }
}


fileprivate extension Heading {
   func turn() -> Heading {
      switch self {
         case .N: .E
         case .E: .S
         case .S: .W
         case .W: .N
         default: fatalError()
      }
   }
   
   static func heading(from char: Day06.DirectionIndicator) -> Self {
      switch char {
         case .D: .S
         case .R: .E
         case .L: .W
         case .U: .N
      }
   }
}

extension Character {
   func asString() -> String {
      String(self)
   }
}
