import Foundation
import Collections

struct Day12: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let day = 12
   let puzzleName: String = "--- Day 12 ---"
   let grid: [Point: Character]
   let xRange: ClosedRange<Int>
   let yRange: ClosedRange<Int>
   
   let visited = Visited()
   
   init(data: String) {
      grid = data
         .trimmingCharacters(in: .whitespaces)
         .components(separatedBy: .newlines)
         .filter{!$0.isEmpty}
         .map{$0.map{$0}}
         .enumerated()
         .reduce(into: [Point:Character]()){dict, enumerated in
            enumerated.element
               .enumerated()
               .forEach{ x, char in
                  dict[Point(x,enumerated.offset)] = char
               }
         }
      xRange = 0...grid.keys.map(\.x).max()!
      yRange = 0...grid.keys.map(\.y).max()!
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      var part1Grid = grid
      var regions: Set<Region> = []
      while let current = part1Grid.popFirst() {
         let matched = await region(for: current.key, target: current.value)
         regions.insert(Region(char: current.value, points: matched))
         matched.forEach{part1Grid[$0] = nil}
      }
      let cost = regions.reduce(0){$0 + $1.cost}
      return cost
   }
   
   func part2() async throws -> Int {
      await visited.reset()
      var part2Grid = grid
      var part2Regions: Set<Region> = []
      while let current = part2Grid.popFirst() {
         let matched = await region(for: current.key, target: current.value)
         part2Regions.insert(Region(char: current.value, points: matched))
         matched.forEach{part2Grid[$0] = nil}
      }
      let results = part2Regions.map{$0.sides}
      
      let costs = results.map { result in
         if let outer = part2Regions.first(where: {region in  result.boundary.isSubset(of: region.points)}) {
            return result.area! * result.sides + outer.area * result.sides
         } else {
            return result.area! * result.sides
         }
      }
      
      let bulkCost = costs.reduce(0,+)
            
      return bulkCost
   }
}

   // Add any extra code and types in here to separate it from the required behaviour
extension Day12 {
   struct SidesResult {
      let area: Int?
      let sides: Int
      let boundary: Set<Point>
   }
   
   @MainActor
   func region(for point: Point, target: Character) ->  Set<Point> {
      guard grid[point] == target else {return ([])}
      visited.add(point)
      let unvisitedNeighbours = point
         .neighbours
         .filter{grid[$0] != nil}
         .filter{!visited.points.contains($0)}
      let results = unvisitedNeighbours
         .reduce( Set([point]) ) { set, point in
            set.union( region(for: point, target: target))
         }
      return results
   }
}

enum Direction: CaseIterable {
   case U, R, D, L
}

struct Plotter: Hashable {
   var turns = 0
   let start: Point
   var current: Point
   var heading: Direction = .R
   var looking: Direction {
      switch heading {
         case .U: .R
         case .R: .D
         case .D: .L
         case .L: .U
      }
   }
   let points: Set<Point>
   
   init(points: Set<Point>) {
      self.points = points
      let top = points.map(\.y).min()!
      let left = points.filter{$0.y == top}.map(\.x).min()!
      start = Point(left, top-1)
      current = start
   }
   
   mutating func countRuns() -> Day12.SidesResult {
      var boundary: Set<Point> = []
      while current != start || turns == 0 {
         if let next = try? forwardOne(from: current) {
               // space ahead to move into
            current = next
            if !edge(looking: looking, from: current) {
                  //nothing there, i.e. the wall has turned R
               heading = turn(.R, from: heading)
               turns += 1
            } else {
               boundary.insert(current)
            }
         } else {
               //can't move forward as point in the way, so turn L & try again
            heading = turn(.L, from: heading)
            turns += 1
         }
      }
      return Day12.SidesResult(area: nil, sides: turns, boundary: boundary)
   }
   
   private func turn(_ turning: Direction, from heading: Direction) -> Direction {
      switch (heading, turning) {
         case (.U, .L): .L
         case (.R, .L): .U
         case (.D, .L): .R
         case (.L, .L): .D
            
         case (.U, .R): .R
         case (.R, .R): .D
         case (.D, .R): .L
         case (.L, .R): .U
            
         default: fatalError("Can't turn \(turning)")
      }
   }
   
   private func forwardOne(from point: Point) throws -> Point {
      let next = point.next(heading: heading)
      guard !points.contains(next) else {throw PlotterError.wayForwardBlocked}
      return next
   }
   
   private func edge(looking direction: Direction, from point: Point) -> Bool {
      let lookingAt = point.next(heading: direction)
      return points.contains(lookingAt)
   }
   
   enum PlotterError: Error {
      case wayForwardBlocked
   }
}

fileprivate struct Region: Hashable {
   internal init(char: Character, points: Set<Point>) {
      self.char = char
      self.points = points
   }
   
   func hash(into hasher: inout Hasher) {
      hasher.combine(char)
      hasher.combine(points)
   }
   
   let char: Character
   let points: Set<Point>
   var cost: Int { area * perimeter }
   var area: Int {points.count}
   
   var sides: Day12.SidesResult {
      var plotter = Plotter(points: points)
      let runs = plotter.countRuns()
      return .init(area: area, sides: runs.sides, boundary: runs.boundary)
   }
   
   private var edges: NSCountedSet {
      points.reduce(into: NSCountedSet()) { cSet, point in
         point.edges.forEach{cSet.add($0)}
      }
   }
   
   private var perimeter: Int {
      edges
         .map{(($0, edges.count(for: $0)))}
         .filter{$0.1 == 1}
         .map{$0.0}
         .count
   }
}

@MainActor
class Visited: Sendable {
   var points: Set<Point> = []
   
   func add(_ point: Point) {
      points.insert(point)
   }
   
   func reset() {
      points = []
   }
}


extension Point: CustomStringConvertible {
   struct Edge: Hashable {
      var start, end: Point
   }
   
   var description: String {"(\(x), \(y))"}
   var neighbours: [Point] {
      [
         .init(self.x-1, self.y),
         .init(self.x+1, self.y),
         .init(self.x, self.y+1),
         .init(self.x, self.y-1)
      ]
   }
   
   var edges: [Edge] {
      [
         .init(start: self, end: Point(self.x+1, self.y)),
         .init(start: self, end: Point(self.x, self.y+1)),
         .init(start: Point(self.x+1, self.y), end: Point(self.x+1, self.y+1)),
         .init(start: Point(self.x, self.y+1), end: Point(self.x+1, self.y+1)),
      ]
   }
   
   fileprivate func next(heading direction: Direction, step: Int = 1) -> Point {
      switch direction {
         case .U: .init(x, y-step)
         case .R: .init(x+step, y)
         case .D: .init(x, y+step)
         case .L: .init(x-step, y)
      }
   }
}
