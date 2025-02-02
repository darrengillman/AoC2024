import Foundation
struct Day19: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let day = 19
   let puzzleName: String = "--- Day 19 ---"
   
   var puzzle: Puzzle
   
   init(data: String) {
      puzzle = Puzzle(data: data)
   }
   
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      let start = Date.timeIntervalSinceReferenceDate
       let answer = puzzle.part1()
      print("Part 1: \((Date.timeIntervalSinceReferenceDate - start).formatted())")
      return answer
   }
   
   func part2() async throws -> Int {
      puzzle.part2()
   }
}

   // Add any extra code and types in here to separate it from the required behaviour
extension Day19 {
   
   class Cache {
      private var cache = [String: Int]()
      
      func add(_ design: String, _ count: Int) {
         cache[design] = count
      }
      
      func check(_ design: String) -> Int? {
         cache[design]
      }
   }
   
   struct Puzzle : Sendable{
      let towels: Set<String>
      let designs: [String]

      init(data: String) {
         let lines = data.components(separatedBy: .newlines)
         towels = Set(
            lines
               .first!
               .components(separatedBy: ",")
               .map{$0.trimmingCharacters(in: .whitespaces)}
               .filter{ !$0.isEmpty }
         )
         designs = lines[2...]
            .filter{ !$0.isEmpty }
            .map{ $0.trimmingCharacters(in: .whitespaces) }
      }
      
      func part1() -> Int {
         let cache = Cache()
         return designs.map{ test(design: $0, with: cache) }
            .filter{ $0 > 0}
            .count
      }
      
      func part2() -> Int {
         let cache = Cache()
         return designs.map{ test(design: $0, with: cache) }.reduce(0, +)
      }
      
      
      
      func test(design: String, with cache: Cache) -> Int {
         if let cached = cache.check(design) {
            return cached
         } else {
            guard !design.isEmpty else {return 1}
            let result = towels
               .filter{ design.starts(with: $0) }
               .map{ test(design: String(design.dropFirst($0.count)), with: cache) }
               .reduce(0, +)
            
            cache.add(design, result)
            return result
         }
      }
   }
}

