import Foundation
typealias Stone = Int
//Part2:  747,984 is too low


struct Day11: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let day = 11
   let puzzleName: String = "--- Day 11 ---"
   let  stones: [Stone]


  init(data: String) {
     stones = data
        .components(separatedBy: .newlines)
        .filter{!$0.isEmpty}
        .first!
        .components(separatedBy: .whitespaces)
        .compactMap(Int.init)
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() async throws -> Int {
     var line = Line(stones: stones, loops: 25)
     return line.run()
  }
   
   func part2() async throws -> Int {
      var line = Line(stones: stones, loops: 75)
      return line.run()
  }
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day11 {
   
   
   struct Line {
      var memos: [Stone: [Stone]] = [:]
      var stones: [Stone]
      let loops: Int
      
      init(stones: [Stone], loops: Int) {
         self.stones = stones
         self.loops = loops
      }
      
      mutating func run() -> Int {
         for _ in 0..<loops {
            stones = blink(on: stones)
            print(stones)
         }
         
         return stones.count
      }
      
      mutating func blink(on stones: [Stone]) -> [Stone] {
         stones
            .flatMap {
               process($0)
            }
      }
      
      mutating func process(_ stone: Stone) -> [Stone] {
         if let memo = memos[stone] {
               //            print(">",memo)
            return memo
         } else {
            let processed = switch stone {
               case 0: [1]
               case let i where String(i).count.isMultiple(of: 2):
                  [String(i).prefix(String(i).count/2).asString, String(i).suffix(String(i).count/2).asString].compactMap(Int.init)
               default: [ stone * 2024]
            }
            memos[stone] = processed
               //            print(processed)
            return processed
         }
      }
   }
}
   


fileprivate extension Sequence where Element == Stone {
   var asArray: [Element] {
      Array(self)
   }
}
