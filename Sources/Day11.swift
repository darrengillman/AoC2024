import Foundation

struct Day11: AdventDay, Sendable {
   typealias Stone = Int
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
      var memos: [[Stone: [Stone]] = [:]
      var stones: [Stone]
      let loops: Int
      
      init(stones: [Stone], loops: Int) {
         self.stones = stones
         self.loops = loops
      }
      
      mutating func run() -> Int {
         for _ in 0..<loops {
            stones = blink(on: stones)
         }
         
         return stones.count
      }
      
      mutating func blink(on stones: [Stone]) -> [Stone] {
         stones
            .chunks(ofCount: 20)
            .flatMap { chunk in
               let input = chunk.map{$0}
               if let prev = memos[input]  {
                  return prev
               }
               else
               {
                  let blinked = chunk
                     .flatMap{process($0)}
                  memos[input] = blinked
                  return blinked
               }
            }
      }
      
      func process(_ stone: Stone) -> [Stone] {
         switch stone {
            case 0: return [1]
            case let i where String(i).count.isMultiple(of: 2):
               let s = String(i)
               return [s.prefix(s.count/2).asString, s.suffix(s.count/2).asString].compactMap(Int.init)
            default: return[ stone * 2024]
         }
      }
   }
}
