  import Testing

  @testable import AdventOfCode

  @Suite("Day14 Tests")
  struct Day14Tests {
  @Suite("Parser Tests")
  struct ParserTests {
     
     @Test("Regex test")
     func regextest() async throws {
        let robots = Day14.parse(input: "p=0,4 v=3,-3")
        #expect(robots.count == 1)
        let robot = try #require(robots.first, "need a robot!")
        #expect(robot == Day14.Robot(position: .init(0,4), velocity: .init(3,-3)))
     }
     
    @Test("Test parser implementation")
    func parseInput() throws {
       let robots = Day14.parse(input: testInput)
       #expect(robots.count == 12)
       let robot = try #require(robots.first, "need a robot!")
       #expect(robot == Day14.Robot(position: .init(0,4), velocity: .init(3,-3)))
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    @Suite("Tests on sample inputs")
    struct SolutionsTests {
      let day = Day14(data: testInput)

      @Test("Part1 example")
      func testPart1() async throws {
         let result = day.run(testInput, iterations: 100, width: 11, height: 7)
          #expect(result == 12)
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
  p=0,4 v=3,-3
  p=6,3 v=-1,-3
  p=10,3 v=-1,2
  p=2,0 v=2,-1
  p=0,0 v=1,3
  p=3,0 v=-2,-2
  p=7,6 v=-1,-3
  p=3,0 v=-1,-2
  p=9,3 v=2,3
  p=7,3 v=-1,2
  p=2,4 v=2,-3
  p=9,5 v=-3,-3
  """
