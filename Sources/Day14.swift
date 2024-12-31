import Foundation
import RegexBuilder

struct Day14: AdventDay, Sendable {
   let data: String
   let day = 14
   let puzzleName: String = "--- Day 14! ---"
   
   init(data: String) {
      self.data = data
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      run(data, iterations: 100, width: 101, height: 103)
   }
   
   func part2() async throws -> Int { //1751 too low
      runPt2(data, iterations: 100, width: 101, height: 103)
   }
}

   // Add any extra code and types in here to separate it from the required behaviour
extension Day14 {
   struct Robot: Equatable, Hashable {
      var position: Point
      let velocity: Point
      
      mutating func move(times: Int, width: Int, height: Int) {
         for _ in 0 ..< times {
            position = .init(
               (position.x + velocity.x + width) % width,
               (position.y + velocity.y + height ) % height
            )
         }
      }
   }
   
   func run(_ data: String, iterations: Int, width: Int, height: Int) -> Int {
      var robots = Day14.parse(input: data)
      for i in 0 ..< robots.count {
         robots[i].move(times: iterations, width: width, height: height)
      }
      let midX = width/2
      let midY = height/2
      
      let upperLeft = robots.filter {
         $0.position.x < midX && $0.position.y < midY
      }
      
      let upperRight = robots.filter {
         $0.position.x > midX && $0.position.y < midY
      }
      
      let lowerLeft = robots.filter {
         $0.position.x < midX && $0.position.y > midY
      }
      
      let lowerRight = robots.filter {
         $0.position.x > midX && $0.position.y > midY
      }
      
      return upperLeft.count * upperRight.count * lowerLeft.count * lowerRight.count
   }
   
   func runPt2(_ data: String, iterations: Int, width: Int, height: Int) -> Int {
      var robots = Day14.parse(input: data)
      var seconds = 0
      while !tree(robots, width: width, height: height) {
         seconds += 1
         for i in 0 ..< robots.count {
            robots[i].move(times: 1, width: width, height: height)
         }
      }
      return seconds
   }
   
   func tree(_ robots: [Robot], width: Int, height: Int) -> Bool {
      robots
         .reduce(into: Set<Point>()){$0.insert($1.position)}
         .count
      == robots.count
   }
   
   static func parse(input: String) -> [Robot] {
      let numberCapture = Regex {
         Capture {
            Optionally("-")
            OneOrMore (.digit)
         } transform: { capture in
            Int(capture)!
         }
      }
      
      let regex = Regex {
         "p="
         numberCapture
         ","
         numberCapture
         " v="
         numberCapture
         ","
         numberCapture
      }
      
      return input.matches(of: regex)
         .map{
            Robot(position: Point($0.output.1, $0.output.2),
                  velocity: Point($0.output.3, $0.output.4)
            )
         }
   }
}
