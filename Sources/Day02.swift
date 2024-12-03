//
//  Day00 2.swift
//  AdventOfCode
//
//  Created by Darren Gillman on 02/12/2024.
//

import AoCTools
import Foundation

struct Day02: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let data: String
   let day = 2
   let puzzleName: String = "--- Day 2: Placeholder! ---"
   
   init(data: String) {
      self.data = data
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      parse(data)
         .map{Line(original: $0.map{Int($0)!})}
         .filter{$0.safe(damping: false)}
      .count   }
   
   func part2() async throws -> Int {
      parse(data)
         .map{Line(original: $0.map{Int($0)!})}
         .filter{$0.safe(damping: true)}
         .count
   }
   
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day02 {
   struct Line {
      let original: [Int]
      
      func safe(damping: Bool = false) -> Bool {
         guard !validate(original) else {return true}
         guard damping else {return false}
         for index in original.indices {
            let new = Array(original[0..<index] + original[(index+1)...])
            if validate(new) {
               return true
            }
         }
         return false
      }
      
      private func validate(_ values: [Int]) -> Bool {
         ordered(values) && ranged(values)
      }
      
      private func ordered (_ values: [Int]) -> Bool {
         let sorted = values.sorted()
         return ( values == sorted || values == sorted.reversed())
      }
      
      private func ranged(_ values: [Int]) -> Bool {
         let diffs = values
            .adjacentPairs()
            .map{$0.0 - $0.1}
         return diffs.allSatisfy{ (1...3).contains($0)} || diffs.allSatisfy{ (-3 ... -1).contains($0)}
      }
   }
}
