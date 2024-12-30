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
     machines(from: data)
        .compactMap{grabberMoves(for: $0, offset: 0)}
        .reduce(0,+)
  }
   
   func part2() async throws -> Int {
      machines(from: data)
         .compactMap{grabberMoves(for: $0, offset: 10000000000000)}
         .reduce(0,+)
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
            Machine(buttonA: .init($0.1, $0.2), buttonB: Point.init($0.3, $0.4), prize: .init($0.5, $0.6))
         }
   }
   
   func grabberMoves(for machine: Machine, offset: Int) -> Int?  {
      let prize = machine.prize + Point(offset, offset)
      //Cramer's rule
      let det = machine.buttonA.x * machine.buttonB.y - machine.buttonA.y * machine.buttonB.x
      let a = (prize.x * machine.buttonB.y - prize.y * machine.buttonB.x) / det
      let b = (machine.buttonA.x * prize.y - machine.buttonA.y * prize.x) / det
      
      if (machine.buttonA.x * a + machine.buttonB.x * b, machine.buttonA.y * a + machine.buttonB.y * b) == (prize.x, prize.y) {
         return a * 3 + b
      } else {
         return nil
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
