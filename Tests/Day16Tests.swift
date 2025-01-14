import Testing

@testable import AdventOfCode

@Suite("Day16 Tests")
struct Day16Tests {
   @Suite("Parser Tests")
   struct ParserTests {
      @Test("Test parser implementation")
      func parseInput() {
         let maze = Maze(input: testInput1)
         #expect(maze.grid.keys.count == 15*15)
         #expect(maze.grid.values.count(where: {$0 == Maze.Node.space}) == 102)
         #expect(maze.grid.values.count(where: {$0 == Maze.Node.wall}) == 121)
      }
   }
   
   @Suite("Unit Tests")
   struct UnitTests {
      @Test("N tests")
      func northTests() {
         let n = Maze.Direction.N
         #expect(n.cost(to: Maze.Direction.S) == 2000)
         #expect(n.cost(to: .N) == 0)
         #expect(n.cost(to: .E) == 1000 )
         #expect(n.cost(to: .W) == 1000)
      }
      
      @Test("S tests")
      func southTests() {
         let s = Maze.Direction.S
         #expect(s.cost(to: Maze.Direction.S) == 0)
         #expect(s.cost(to: .N) == 2000)
         #expect(s.cost(to: .E) == 1000 )
         #expect(s.cost(to: .W) == 1000)
      }
      
      @Test("E tests")
      func eastTests() {
         let e = Maze.Direction.E
         #expect(e.cost(to: Maze.Direction.S) == 1000)
         #expect(e.cost(to: .N) == 1000)
         #expect(e.cost(to: .E) == 0000 )
         #expect(e.cost(to: .W) == 2000)
      }
      
      @Test("W tests")
      func westTests() {
         let w = Maze.Direction.W
         #expect(w.cost(to: Maze.Direction.S) == 1000)
         #expect(w.cost(to: .N) == 1000)
         #expect(w.cost(to: .E) == 2000 )
         #expect(w.cost(to: .W) == 0000)
      }
      
      @Test("Directions")
      func testDirections() {
         let p = Point(1,1)
         #expect (p.direction(to: .init(1,0)) == .N)
         #expect (p.direction(to: .init(1,2)) == .S)
         #expect (p.direction(to: .init(0,1)) == .W)
         #expect (p.direction(to: .init(2,1)) == .E)
      }
      
   }
   
   @Suite("Tests on sample inputs")
   struct SolutionsTests {
      @Suite("Tests on sample inputs")
      struct SolutionsTests {
         let day = Day16(data: testInput1)
         
         @Test("4x4 maze")
         func Maze4x4() async throws {
            let day = Day16(data: testInputA)
            #expect(try await day.part1() == 1002)
         }
         
         @Test("Pt2 4x4 maze")
         func Pt2Maze4x4() async throws {
            let day = Day16(data: testInputA)
            #expect(try await day.part2() == 3)
         }
         
         @Test("Part1 example")
         func testPart1() async throws {
            let result = try await day.part1()
            #expect(result == 7036)
         }
         
         @Test("Part1 example2")
         func testPart1_2() async throws {
            let day = Day16(data: testInput2)
            let result = try await day.part1()
            #expect(result == 11048)
         }
         
         @Test("Part2 example2")
         func testPart2_2() async throws {
            let day = Day16(data: testInput2)
            let result = try await day.part2()
            #expect(result == 64)
         }
         
         @Test("Part2 example3")
         func testPart2_3() async throws {
            let day = Day16(data: testInput3)
            let result = try await day.part2()
            #expect(result == 64)
         }
         
         @Test("Part2 example")
         func testPart2() async throws {
            let result = try await day.part2()
            #expect(result == 45)
         }
      }
   }
}

private let testInputA =
"""
####
#.E#
#S.#
####
"""

private let testInput1 =
  """
  ###############
  #.......#....E#
  #.#.###.#.###.#
  #.....#.#...#.#
  #.###.#####.#.#
  #.#.#.......#.#
  #.#.#####.###.#
  #...........#.#
  ###.#.#####.#.#
  #...#.....#.#.#
  #.#.#.###.#.#.#
  #.....#...#.#.#
  #.###.#.#.#.#.#
  #S..#.....#...#
  ###############
  """

private let testInput2 = """
#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################
"""

private let testInput3 =
   """
   ###############
   #...........#.#
   ###.#.#####E#.#
   #...#.....###.#
   #.#.#.###.#.#.#
   #.....#...#.#.#
   #S###.#.#.#.#.#
   ###############  
   """
