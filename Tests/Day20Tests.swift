  import Testing

  @testable import AdventOfCode

  @Suite("Day20 Tests")
  struct Day20Tests {
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
      let day = Day20(data: testInput)
       
       @Test("Route finding")
       func findRoute() {
          let track = Day20.Racetrack(input: testInput)
          let route = track.route(from: track.start, to: track.end)
          #expect(route.count-1 == 84)
       }
       
       @Test("Check in problem input no shortcut has multiple possible exits")
       func checkShortcuts() {
          let track = Day20.Racetrack(input: day.data)
          let shortcuts = track.findShortCuts()
          let multiExits = shortcuts
             .map{ shortcut in
                shortcut
                   .neighbours
                   .filter{$0.x > 0 && $0.x < track.maxX && $0.y > 0 && $0.y < track.maxY}
                   .map{ neighbour in
                      track.grid[neighbour]!
                   }
                   .count{$0 != .wall}
             }
             .count{$0 > 3}
          #expect(multiExits == 0)
       }
       

      @Test("Part1 example")
      func testPart1() async throws {
          let result = try await day.part1()
          #expect(result == 0)
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
  ###############
  #...#...#.....#
  #.#.#.#.#.###.#
  #S#...#.#.#...#
  #######.#.#.###
  #######.#.#...#
  #######.#.###.#
  ###..E#...#...#
  ###.#######.###
  #...###...#...#
  #.#####.#.###.#
  #.#...#.#.#...#
  #.#.#.#.#.#.###
  #...#...#...###
  ###############
  """
