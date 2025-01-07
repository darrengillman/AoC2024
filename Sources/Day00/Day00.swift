import Foundation

struct Day00: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let day = 0
  let puzzleName: String = "--- Day \(day) ---"

  init(data: String) {
    self.data = data
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() async throws -> Int {
     data
        .components(separatedBy: .newlines)
        .compactMap{(Int($0))}
        .reduce(0, +)
  }
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day00 {}
