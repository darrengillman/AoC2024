import Testing

@testable import AdventOfCode

@Suite("Day18 Tests")
struct Day18Tests {
   @Suite("Parser Tests")
   struct ParserTests {
      @Test("Test parser implementation")
      func parseInput() {
         let grid = Day18.Grid(input: testInput)
         #expect(grid.memory.count == 25)
      }
   }
   
   @Suite("Tests on sample inputs")
   struct SolutionsTests {
      @Suite("Tests on sample inputs")
      struct SolutionsTests {
         var day = Day18(data: testInput)
         
         @Test("Part1 example")
         mutating func testPart1() async throws {
            let result = day.runPt1(bytes: 12)
            #expect(result == 22)
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
  5,4
  4,2
  4,5
  3,0
  2,1
  6,3
  2,4
  1,5
  0,6
  3,3
  2,6
  5,1
  1,2
  5,5
  2,5
  6,5
  1,4
  0,4
  6,4
  1,1
  6,1
  1,0
  0,5
  1,6
  2,0
  """
