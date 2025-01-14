import Testing
import AoCTools

@testable import AdventOfCode

@Suite("Day00 Tests")
struct Day00Tests {
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
         let day = Day01(data: testInput)
         
         @Test("Part1 example")
         func testPart1() async throws {
            let result = try await day.part1()
            #expect(result == 11)
         }
         
         @Test("Part2 example")
         func testPart2() async throws {
            let result = try await day.part2()
            #expect(result == 31)
         }
      }
   }
}

private let testInput =
  """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """
