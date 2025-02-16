  import Testing

  @testable import AdventOfCode
/*
+---+---+---+
| 7 | 8 | 9 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
| 0 | A |
+---+---+
*/

@Suite("Numeric Keypad Proving")
struct NumericKeypadTests {
}



  @Suite("Day21 Tests")
  struct Day21Tests {
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
      let day = Day21(data: testInput)
       
       
       
       @Test("Test short inputs", .tags(.current),  arguments: ["029A"] )//, "980A", "179A", "456A", "379A" ])
       func testShortNumpad(_ code: String) async throws{
          let day = Day21(data: code)
          let out = try await day.part1()
          #expect(out == 68 * 29)
       }
       

       

      @Test("Part1 example")
      func testPart1() async throws {
          let result = try await day.part1()
          #expect(result == 126384)
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
  029A
  980A
  179A
  456A
  379A
  """
