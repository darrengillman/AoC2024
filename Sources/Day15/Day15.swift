import Foundation
import RegexBuilder
import Collections

struct Day15: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let data: String
   let day = 15
   let puzzleName: String = "--- Day 15 ---"
   
   init(data: String) {
      self.data = data
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      var game = Self.parse(input: data)
      game.runPt1()
      return game.score
   }
   
   func part2() async throws -> Int {
      let stdGame = Self.parse(input: data)
      var game = WideGame(stdGrid: stdGame.grid, moves: stdGame.moves)
      game.runPt2()
      return game.score
   }
}
