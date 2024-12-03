  import Testing

  @testable import AdventOfCode

  @Suite("Day03 Tests")
  struct Day03Tests {
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
      let dayp1 = Day03(data: testInput1)
      let dayp2 = Day03(data: testInput2)

      @Test("Part1")
      func testPart1() async throws {
          let result = try await dayp1.part1()
          #expect(result == 161)
      }

      @Test("Part2 example")
      func testPart2() async throws {
        await withKnownIssue {
          let result = try await dayp2.part2()
          #expect(result == 10)
        }
      }
    }
  }
}

private let testInput1 =
  """
  xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
  """

private let testInput2 =
"""
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
"""
