import Foundation
import Collections

struct Day12: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let day = 0
  let puzzleName: String = "--- Day 0: Placeholder! ---"
   var grid: [Point: Character] = [:]
   let xRange: ClosedRange<Int>
   let yRange: ClosedRange<Int>

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
      var regions: Set<Region> = []
      var toExplore: Set<Point> = [Point(0,0)]
      var explored: Set<Point> = []
      while let current = toExplore.popFirst() {
         let region = region(for: current, target: grid[current]!)
         regions.insert(Region(char: grid[current]!, points: region.inside))
         explored.formUnion(region.inside)
         toExplore.formUnion(region.outside.subtracting(explored))
      }
      let cost = regions.reduce(0){$0 + $1.cost}
      return cost
  }
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day12 {
   
   struct Region: Hashable {
      let char: Character
      let points: Set<Point>
      
      var cost: Int {
         area * perimeter
      }
      
      private var area: Int {points.count}
      
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
   
   func region(for point: Point, target: Character, visited: Set<Point> = []) -> (inside: Set<Point>, outside: Set<Point>) {
      guard grid[point] == target else {return ([], [point])}
      var excluded = Set<Point>()
      let unvisitedNeighbours = point
         .neighbours(inX: xRange, y: yRange)
         .filter{!(visited.union([point])).contains($0)}
      let updatedVisited = visited.union([point])
      let results = unvisitedNeighbours
         .reduce( (inside: Set([point]), outside: Set<Point>()) ) { sets, point in
            let processed = region(for: point, target: target, visited: updatedVisited)
            let inside = processed.inside.subtracting(excluded)
            excluded.formUnion(processed.outside)
            
            return (
               sets.inside.union(inside),
               sets.outside.union(processed.outside)
            )
         }
      return results
   }
}

extension Point: CustomStringConvertible {
   struct Edge: Hashable {
      var start, end: Point
   }
   
   var description: String {"(\(x), \(y))"}
   func neighbours(inX xRange: ClosedRange<Int>, y yRange: ClosedRange<Int>) -> [Point] {
      [
         .init(self.x - 1, self.y),
         .init(self.x + 1, self.y),
         .init(self.x, self.y+1),
         .init(self.x, self.y-1)
      ]
         .filter{xRange ~= $0.x && yRange ~= $0.y}
   }
   
   var edges: [Edge] {
      [
         .init(start: self, end: Point(self.x+1, self.y)),
         .init(start: self, end: Point(self.x, self.y+1)),
         .init(start: Point(self.x+1, self.y), end: Point(self.x+1, self.y+1)),
         .init(start: Point(self.x, self.y+1), end: Point(self.x+1, self.y+1)),
      ]
   }
}
