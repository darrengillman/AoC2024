import Testing

@testable import AdventOfCode

@Suite("Day15 Tests")
struct Day15Tests {
   @Suite("Parser Tests")
   struct ParserTests {
      @Test("Test parser implementation")
      func parseInput() {
         let game = Day15.parse(input: testInput2)
         #expect(game.grid.keys.count == 100)
         #expect(game.moves.count == 70)
      }
   }
   
   @Suite("Tests on sample inputs")
   struct SolutionsTests {
      
      @Suite("Tests on Part 1 sample inputs")
      struct Part1SolutionsTests {
         let day1 = Day15(data: testInput1)
         let day2 = Day15(data: testInput2)
         
         @Test("Part1 example A")
         func testPart1A() async throws {
            let result = try await day1.part1()
            #expect(result == 2028)
         }
         
         @Test("Part1 example B")
         func testPart1B() async throws {
            let result = try await day2.part1()
            #expect(result == 10092)
         }
      }
      
      @Suite("Part2 unit tests")
      struct Part2UnitTests {
         
         @Test("Pushing box left")
         func pushingLeft() async throws {
            let input = """
          ##########
          #.OOO.@..#
          ##########
          <<<<<<<<<<
          """
            let dayA = Day15(data: input)
            let x = try await dayA.part2()
            #expect(x == 312)
         }
         
         @Test("Pushing box Right")
         func pushingRight() async throws {
            let input = """
          ##########
          #..@.O.O.#
          ##########
          >>>>>>>>>>
          """
            let dayA = Day15(data: input)
            let x = try await dayA.part2()
            #expect(x == 230)
         }
         
         @Test("Pushing box Up")
         func pushingUp() async throws {
            let input = """
          ###
          #.#
          #.#
          #O#
          #.#
          #.#
          #.#
          #@#
          #.#
          ###
          ^^^^^^^^^^^^^
          """
            let dayA = Day15(data: input)
            let x = try await dayA.part2()
            #expect(x == 102)
         }
         
         
         
         @Test("Pushing box down")
         func pushingDown() async throws {
            let input = """
          ###
          #.#
          #@#
          #.#
          #.#
          #O#
          #.#
          #O#
          #.#
          ###
          vvvvvvvvvvvvvvvvv
          """
            let dayA = Day15(data: input)
            let x = try await dayA.part2()
            #expect(x == 1504)
         }
         
         @Test("Pushing box Up with blocker")
         func pushingUpWithBlock() async throws {
            let input = """
                       ###
                       #.#
                       ###
                       #.#
                       #.#
                       #O#
                       #.#
                       #@#
                       #.#
                       ###
                       ^^^^^^^^^^^^^
                       """
            let dayA = Day15(data: input)
            let x = try await dayA.part2()
            #expect(x == 302)
         }
      }
      
      @Suite("Tests on Part 2 sample inputs")
      struct Part2SolutionsTests {
         let day1 = Day15(data: testInput1)
         let day2 = Day15(data: testInput2)
         
         @Test("Part2 example 1")
         func testPart2A() async throws {
            let result = try await day1.part2()
            #expect(result == 1751)
         }
         
         @Test("Part2 example 2")
         func testPart2B() async throws {
            let result = try await day2.part2()
            #expect(result == 9021)
         }
      }
   }
}


private let testInput1 =
  """
  ########
  #..O.O.#
  ##@.O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########
  
  <^^>>>vv<v>>v<<
  """

private let testInput2 =
  """
  ##########
  #..O..O.O#
  #......O.#
  #.OO..O.O#
  #..O@..O.#
  #O#..O...#
  #O..O..O.#
  #.OO.O.OO#
  #....O...#
  ##########
  
  <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
  vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
  ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
  <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
  ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
  ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
  >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
  <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
  ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
  v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
  """
