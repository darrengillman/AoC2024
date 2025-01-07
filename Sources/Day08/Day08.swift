import Foundation
import AoCTools

struct Day08: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let day = 0
  let puzzleName: String = "--- Day 0: Placeholder! ---"
   let xRange: Range<Int>
   let yRange: Range<Int>
   var frequencyMap: [Character: [Point]] = [:]

  init(data: String) {
     let lines = data
        .components(separatedBy: .newlines)
        .filter{!$0.isEmpty}
        .map{$0.map{$0}}
     
     xRange = 0 ..< lines[0].count
     yRange = 0 ..< lines.count
     
     frequencyMap = yRange
        .flatMap{ y in
           xRange.map { x in
              (Point(x, y), lines[y][x])
           }
        }
        .filter{$0.1 != "."}
        .reduce(into: [Character: [Point]]()){$0[$1.1, default: [] ].append($1.0) }
  }

  // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      frequencyMap
         .values
         .reduce(Set<Point>()) {$0.union(antiNodes(for: $1))}
         .filter{ xRange ~= $0.x && yRange ~= $0.y }
         .count
   }
   
   func part2() async throws -> Int {
      frequencyMap
         .values
         .reduce(Set<Point>()) {$0.union( resonantAntinodes(for: $1))}
         .count
   }
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day08 {
   
   func antiNodes(for nodes: [Point]) -> Set<Point> {
      nodes
         .combinations(ofCount: 2)
         .reduce(Set<Point>()) {set, arrayPairOfPoint in
            set.union(calculateAntinodes(arrayPairOfPoint))
         }
   }
   
   private func calculateAntinodes(_ a: [Point]) -> [Point] {
      let p1 = a[0]
      let p2 = a[1]
      let dx = abs(p1.x - p2.x)
      let dy = abs(p1.y - p2.y)
      
      let n1 = Point (
         p1.x > p2.x ? p1.x + dx : p1.x - dx,
         p1.y > p2.y ? p1.y + dy : p1.y - dy
      )
      
      let n2 = Point (
         p2.x > p1.x ? p2.x + dx : p2.x - dx,
         p2.y > p1.y ? p2.y + dy : p2.y - dy
      )
      
      return [n1, n2]
   }
   
   
   
   func resonantAntinodes(for nodes: [Point]) -> Set<Point> {
      nodes
         .combinations(ofCount: 2)
         .reduce(Set<Point>()) { set, arrayOfPoint in
            set.union(calculateResonantAntinodesForPair(arrayOfPoint))
         }
   }
   
   func calculateResonantAntinodesForPair(_ pair: [Point]) -> Set<Point> {
      let p1 = pair[0]
      let p2 = pair[1]
      let dx = p2.x - p1.x
      let dy = p2.y - p1.y
      var antis = Set<Point>()
     
      var x = p1.x
      var y = p1.y
      while xRange ~= x && yRange ~= y {
         antis.insert(.init(x,y))
         x += dx
         y += dy
      }
      
      x = p1.x
      y = p1.y
      while xRange ~= x && yRange ~= y {
         antis.insert(.init(x,y))
         x -= dx
         y -= dy
      }

      return antis
   }
}

fileprivate extension Sequence {
   func asArray() -> [Self.Element]  {
      Array(self)
   }
}
