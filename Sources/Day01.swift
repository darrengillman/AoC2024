import Foundation

struct Day01: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let data: String
   let day = 1
   let puzzleName: String = "--- Day \(day): Placeholder! ---"
   
   init(data: String) {
      self.data = data
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      zip(parse(data).0, parse(data).1)
         .reduce(0){ $0 + abs($1.0 - $1.1)}
   }
   
   
   func part2() -> Int {
      let input = parse(data)
      let counted = NSCountedSet(array: input.1)
      
      return input.0
         .reduce(0){
            $0 +  $1 * counted.count(for: $1)
         }
   }

}

   // Add any extra code and types in here to separate it from the required behaviour
extension Day01 {
   func parse(_ data: String) -> ([Int], [Int]) {
      let input = data
         .components(separatedBy: .newlines)
         .filter{!$0.isEmpty}
         .map{$0.components(separatedBy: .whitespaces)}
         .map{$0.filter{!$0.isEmpty}}
         .map{$0.map{Int($0)!}}
      
      let seq1 = input.map{$0.first!}.sorted(by: <)
      let seq2 = input.map{$0.last!}.sorted(by: <)
      
      return (seq1, seq2)
   }
}