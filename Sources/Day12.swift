import Foundation
import Collections

struct Day12: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
   let day = 12
   let puzzleName: String = "--- Day 12 ---"
   var grid: [Point: Character] = [:]
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
      var grid = grid
      var regions: Set<Region> = []
      while let current = grid.popFirst() {
         let matched = await region(for: current.key, target: current.value)
         regions.insert(Region(char: current.value, points: matched))
         matched.forEach{grid[$0] = nil}
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

@MainActor
class Visited: Sendable {
   var points: Set<Point> = []
   
   func add(_ point: Point) {
      points.insert(point)
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
}
