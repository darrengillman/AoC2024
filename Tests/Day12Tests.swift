  import Testing

  @testable import AdventOfCode

  @Suite("Day12 Tests")
  struct Day12Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
       let day = Day12(data: testInput)
       #expect(day.grid.count == 16)
       let p1 = day.grid[.init(3,3)]
       let p2 = day.grid[.init(2,3)]
       let p3 = day.grid[.init(2,4)]
       
       #expect(p1 == "C")
       #expect(p2 == "E")
       #expect(p3 ==  nil)
    }
  }
          

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    @Suite("Tests on sample inputs")
    struct SolutionsTests {
      let day = Day12(data: testInput)

      @Test("Part1 example")
      func testPart1() async throws {
          let result = try await day.part1()
          #expect(result == 1930)
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
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
"""
