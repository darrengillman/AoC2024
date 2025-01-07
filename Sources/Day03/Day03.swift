import Foundation
import RegexBuilder

struct Day03: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let data: String
   let day = 3
   let puzzleName: String = "--- Day 3 ---"
   
   init(data: String) {
      self.data = data
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      let regex = Regex {
         "mul("
         Capture {
            Repeat(1...3) {
               One(.digit)
            }
         }
         ","
         Capture {
            Repeat(1...3) {
               One(.digit)
            }
         }
         ")"
      }

      return data
         .matches(of: regex)
         .map{ ( Int($0.output.1)!, Int($0.output.2)!)}
         .reduce(0){ $0 + $1.0 * $1.1}
   }
   
   
   func part2() async throws -> Int {
      let regex = /mul\((\d{1,3}),(\d{1,3})\)/
   
      return ("do()" + data)
         .split(separator: "don't()")
         .compactMap{ line in
            if let doRange = line.firstRange(of: "do()") {
                line[doRange.upperBound...]
            } else {
               nil
            }
         }
         .joined()
         .matches(of: regex)
         .map{ ( Int($0.output.1)!, Int($0.output.2)!) }
         .reduce(0){ $0 + $1.0 * $1.1}
   }
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day03 {}
