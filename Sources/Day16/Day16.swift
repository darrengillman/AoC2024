import Foundation
import Collections

struct Day16: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let data: String
   let day = 0
   let puzzleName: String = "--- Day 16 ---"
   
   init(data: String) {
      self.data = data
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      var maze = Maze(input: data)
      let routes = maze.route()
      return routes.map(\.costToHere).min()!
   }
   
   func part2() async throws -> Int {
      var maze = Maze(input: data)
      let routes = maze.route()
      let minCost = routes.map(\.costToHere).min()!
      
      return routes
         .filter{$0.costToHere == minCost}
         .reduce(into: Set<Point>()){$0.formUnion($1.pathToHere + [$1.location])}.count
   }
}
   
struct Maze {
   typealias Grid = [Point: Node]
   typealias Cost = Int
   
   enum Node: Hashable {
      case space, wall, start, end
   }
   
   struct Step: CustomStringConvertible{
      var description: String {
         """
         at: \(location)
         heading: \(direction)
         costs \(costToHere) \n
         """
         + [self].render()
      }
      
      let location: Point
      let direction: Direction
      let costToHere: Int
      let pathToHere: [Point]
      
      func render() -> String {
         description + "\n"
      }
   }
   
   enum Direction: Int {
      case N = 0
      case E = 1000
      case S = 2000
      case W = 3000
      
      func cost(to: Self) -> Int {
         let diff = (abs(self.rawValue-to.rawValue))
         return diff > 2000 ? 1000 : diff
      }
   }
   
   var grid: Grid
   var start: Point
   var end: Point
   var queue: Deque<Step> = []
   var ends: [Step] = []
   var visited:[Point: Cost] = [:]
   
   
   init(input: String)  {
      let array = input
         .trimmingCharacters(in: .whitespaces)
         .components(separatedBy: .newlines)
         .filter{!$0.isEmpty}
         .map{ line in
            line.map{
               return switch $0 {
                  case "#": Node.wall
                  case ".": Node.space
                  case "S": Node.start
                  case "E": Node.end
                  default: fatalError()
               }
            }
         }
      
      grid = array
         .indices
         .reduce(into: Grid() ){grid, y in
            array[y]
               .indices
               .forEach{ x in
                  grid[.init(x,y)] = array[y][x]
               }
         }
      
      start = grid.first{$0.value == .start}!.key
      end = grid.first{$0.value == .end}!.key
   }
   
   
   func calcRoutes(for point: Point, facing: Direction, prev: [Point]) -> [(point:Point, direction: Direction, cost: Cost)] {
      point
         .neighbours
         .filter{
            grid[$0] != .wall
         }
         .map{
            ($0, point.direction( to: $0 ))
         }
         .map{
            ($0.0, $0.1, facing.cost(to: $0.1))
         }
   }
   
   mutating func route() -> [Step] {
      queue = [Step(location: start, direction: .E, costToHere: 0, pathToHere: [])]
      
      while !queue.isEmpty {
         let current = queue.popFirst()!
         visited[current.location] = current.costToHere
         if current.location == end {
            ends.append(current)
         } else {
            let routes = calcRoutes(for: current.location, facing: current.direction, prev: current.pathToHere)
               .map{
                  Step(
                     location: $0.point,
                     direction: $0.direction,
                     costToHere: current.costToHere + 1 + $0.cost,
                     pathToHere: current.pathToHere + [ current.location]
                  )
               }
               .filter{ route in
                  route.costToHere + current.direction.cost(to: route.direction) <= visited[route.location, default: Int.max]
               }
            queue.append(contentsOf: routes)
         }
      }
      return ends
   }
}


extension Array where Element == Maze.Step {
   func print(filter: ((Maze.Step) -> Bool)?) {
      Swift.print(
         self.render(filter: filter)
      )
   }
   
   func render(filter: ((Maze.Step) -> Bool)? = nil) -> String {
      self
         .filter{filter == nil ? true : filter!($0)}
         .flatMap{$0.pathToHere + [$0.location]}
         .reduce(into: [Point: String]()) {dict, point in
            dict[point] = "O"
         }
         .render()
   }
}

extension Point {
   func direction(to other: Point) -> Maze.Direction{
      switch (self.x - other.x, self.y - other.y) {   //2,3 -> 3,3
         case (1, 0): .W
         case(-1, 0): .E
         case(0, 1): .N
         case(0,-1): .S
         default: fatalError()
            
      }
   }
}
