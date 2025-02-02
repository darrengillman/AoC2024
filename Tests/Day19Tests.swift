import Testing
import Algorithms

@testable import AdventOfCode

@Suite("Day19 Tests")
struct Day19Tests {
   
//   @Suite("Random tests")
//   struct RandomTests {
//      let permutations = ["r", "wr", "b", "g", "bwu", "rb", "gb", "br"]
//         .uniquePermutations()
//         .map { $0.joined() }
//      
//      let designs = [
//         "brwrr",
//         "bggr",
//         "gbbr",
//         "rrbgbr",
//         "ubwu",
//         "bwurrg",
//         "brgr",
//         "bbrgwb",
//      ]
//      @Test("Test random")
//      func testRandom() {
//         let matches = designs.filter { design in
//            permutations
//               .map{$0.prefix(design.count).asString}
//               .contains(design)
//         }
//            .map { print($0); return $0 }
//            .count
//         
//         "sfsdfsfd".st
//         #expect( matches == 6)
//         
//      }
//   }
   
   
   
   @Suite("Parser Tests")
   struct ParserTests {
      @Test("Test parser implementation")
      func parseInput() {
            //
      }
   }
   
   @Suite("Tests on sample inputs")
   struct SolutionsTests {
      @Suite("Tests on sample inputs")
      struct SolutionsTests {
         let day = Day19(data: testInput)
         
         @Test("Part1 example")
         func testPart1() async throws {
               let result = try await day.part1()
               #expect(result == 6)
            }
         
         @Test("Part2 example")
         func testPart2() async throws {
               let result = try await day.part2()
               #expect(result == 10)
         }
      }
   }
}

private let testInput =
  """
  r, wr, b, g, bwu, rb, gb, br
  
  brwrr
  bggr
  gbbr
  rrbgbr
  ubwu
  bwurrg
  brgr
  bbrgwb
  """
