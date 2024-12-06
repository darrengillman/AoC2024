import Foundation
import AoCTools

struct Day05: AdventDay, Sendable {
   typealias Page = Int
   let day = 0
   let puzzleName: String = "--- Day 5 ---"
   var rules: [Page: Set<Page>] = [:]
   var books: [[Page]] = []
   
   init(data: String) {
      data
         .components(separatedBy: .newlines)
         .forEach { line in
            if line.contains("|") {
               let components = line.components(separatedBy: "|")
               rules[Int(components[0])!, default: Set<Int>()].insert(Int(components[1])!)
            } else if line.contains(",") {
               books.append(line.components(separatedBy: ",").map{Int($0)!})
            }
         }
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      books
         .filter{isOrdered($0)}
         .map{ $0[$0.count/2] }
         .reduce(0, +)
   }
   
   func part2() async throws -> Int {
      books
         .filter{!isOrdered($0)}
         .map{ book in
            book.sorted { first, second in
               guard let onlyAfterSecond = rules[second] else {return true}
               return !onlyAfterSecond.contains(first)
            }
         }
         .map{ $0[$0.count/2] }
         .reduce(0, +)
   }
   
   func isOrdered(_ pages: [Int]) -> Bool {
      var prior = Set<Page>()
      
      for current in pages {
         if let aheadOnly = rules[current], prior.intersection(aheadOnly).isEmpty == false {
            return false
         }
         prior.insert(current)
      }
      return true
   }
                           
                           
                           
}

   // Add any extra code and types in here to separate it from the required behaviour
extension Day05 {}
