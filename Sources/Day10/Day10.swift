import Foundation

struct Day10: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
   let day = 10
   let puzzleName: String = "--- Day 10 ---"

   var trailMap: [Point: Int] = [:]
   var xRange, yRange: ClosedRange<Int>

  init(data: String) {
     let inputs = data
        .components(separatedBy: .newlines)
        .filter{!$0.isEmpty }
        .map{$0.trimmingCharacters(in: .whitespaces)}
        .map{$0.map{Int($0.asString)!}}
     
     for y in 0 ..< inputs.count {
        for x in 0 ..< inputs[0].count {
           trailMap[Point(x,y)] = inputs[y][x]
        }
     }
     xRange = 0...trailMap.keys.map(\.x).max()!
     yRange = 0...trailMap.keys.map(\.y).max()!
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() async throws -> Int {
     let trailheads = trailMap.filter{$0.value == 0}.map{$0.key}
     let ends = trailheads.reduce(0){$0 + processScores($1, target: 1).count}
     return ends
  }
   
  func part2() async throws -> Int {
     let trailheads = trailMap.filter{$0.value == 0}.map{$0.key}
     let ends = trailheads.reduce(0){$0 + calculateRatings(for: $1, target: 1)}
     return ends
  }
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day10 {
   func processScores(_ point: Point, target: Int) -> Set<Point> {
      if trailMap[point] == 9 { return [point] }
      
      return point
         .steps
         .filter { xRange ~= $0.x && yRange ~= $0.y}
         .filter {trailMap[$0] == target}
         .reduce(Set<Point>()) {$0.union( processScores($1 , target: target + 1) )}
   }
   
   func calculateRatings(for point: Point, target: Int) -> Int {
      if trailMap[point] == 9 { return 1 }
      
      return point
         .steps
         .filter {trailMap[$0] == target}
         .reduce(0) { $0 + calculateRatings(for: $1, target: target + 1)}
   }
}

extension Point {
   var steps: [Self] {
      [
         .init(x-1, y),
         .init(x+1, y),
         .init(x, y+1),
         .init(x, y-1),
         
      ]
   }
}
