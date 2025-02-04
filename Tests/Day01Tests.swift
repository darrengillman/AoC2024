import AoCTools
import Testing

@testable import AdventOfCode

@Suite("Day01")
struct Day01Tests {
   @Suite("Parser Tests")
   struct ParserTests {
      @Test("Test parser implementation")
      func parseInput() {
         let input = parse(testInput)
         #expect(input.count == 6 )
         #expect(input.allSatisfy{$0.count == 2 })
      }
   }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    @Suite("Tests on sample inputs")
    struct SolutionsTests {
      let day = Day01(data: testInput)

      @Test("Part1 example")
      func testPart1() async throws {
         await withKnownIssue(isIntermittent: true) {
          let result = try await day.part1()
          #expect(result == 11)
        }
      }

      @Test("Part2 example")
      func testPart2() async throws {
        await withKnownIssue {
          let result = try await day.part2()
          #expect(result == 10)
        }
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
