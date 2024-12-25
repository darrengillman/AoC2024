  import Testing

  @testable import AdventOfCode

  @Suite("Day11 Tests")
  struct Day11Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      //
    }
  }
     
@Suite("Other tests")
     struct OtherTests {
        let day = Day11(data: "1")
        let day2 = Day11(data: "125 17")
        @Test("Just 1")
        func testJust1() async throws {
           let result = try await day.part1()
           #expect(result == 22)
        }
        
//        @Test("Just 2")
//        func testJust2() async throws {
//           let result = try await day2.part1B(times: 25)
//           #expect(result == 55312)
//        }

     }
     
     

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    @Suite("Tests on sample inputs")
    struct SolutionsTests {
      let day = Day11(data: testInput)

      @Test("Part1 example")
      func testPart1() async throws {
          let result = try await day.part1()
          #expect(result == 55312)
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
  125 17
  """
