import Foundation
import RegexBuilder

struct Day13: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let day = 13
  let puzzleName: String = "--- Day 13 ---"

  init(data: String) {
    self.data = data
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() async throws -> Int {
     /*
      A = (p_x*b_y - prize_y*b_x) / (a_x*b_y - a_y*b_x)
      B = (a_x*p_y - a_y*p_x) / (a_x*b_y - a_y*b_x)
      
      */
     
     let machines = machines(from: data)
     
     
     return machines.count
     
   
  }
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day13 {
   struct Machine {
      let buttonA: Point
      let buttonB: Point
      let prize: Point
   }
   
   
   func machines(from data: String) -> [Machine] {
      let buttonA = Regex {
         "Button A: X+"
         Capture {
            OneOrMore(.digit)
         } transform: {
            Int($0)!
         }
         ", Y+"
         Capture {
            OneOrMore(.digit)
         } transform: {
            Int($0)!
         }
      }
      
      let buttonB = Regex {
         "Button B: X+"
         Capture {
            OneOrMore(.digit)
         } transform: {
            Int($0)!
         }
         ", Y+"
         Capture {
            OneOrMore(.digit)
         } transform: {
            Int($0)!
         }
      }
      
      let prize = Regex {
         "Prize: X="
         Capture {
            OneOrMore(.digit)
         } transform: {
            Int($0)!
         }
         ", Y="
         Capture {
            OneOrMore(.digit)
         } transform: {
            Int($0)!
         }
      }
      
      let regex = Regex {
         buttonA
         ZeroOrMore(.any, .reluctant)
         buttonB
         ZeroOrMore(.any, .reluctant)
         prize
      }
      
      return data
         .matches(of: regex)
         .map{
            Machine(buttonA: .init($0.1, $0.2), buttonB: Point.init($0.3, $0.3), prize: .init($0.4, $0.5))
         }
   }
}

extension Point {
   static func + (lhs: Point, rhs: Point) -> Point {
      Point(
         lhs.x + rhs.x,
         lhs.y + rhs.y
      )
   }
}
