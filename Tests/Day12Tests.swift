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
//      let day1 = Day12(data: testInput1)

      @Test("Part1 example")
      func testPart1() async throws {
          let result = try await day.part1()
          #expect(result == 1930)
      }
       
       //Part 2
       
       @Test("Inner regions")
       func testInnerRegions() async {
          let dayD = Day12(data: testInputD)
          let result = try! await dayD.part2()
          print(result)
          #expect(result == 368)
       }
       
       @Test("Single Inner regions")
       func testSingleInnerRegions() async {
          let testDay = Day12(data: testInputE)
          let result = try! await testDay.part2()
          print(result)

          #expect(result == 68)
       }

        
       @Test("Input A")
       func testA() async {
          let testDay = Day12(data: testInputA)
          let result = try! await testDay.part2()
          print(result)

          #expect(result == 80)
       }

        
       @Test("Input B")
       func testB() async {
          let testDay = Day12(data: testInputB)
          let result = try! await testDay.part2()
          print(result)

          #expect(result == 436)
       }

         
       @Test("Input C")
       func testC() async {
          let testDay = Day12(data: testInputC)
          let result = try! await testDay.part2()
          print(result)

          #expect(result == 236)
       }

   
       
       @Test("Part2 example")
      func testPart2() async throws {
          let result = try await day.part2()
         print(result)

          #expect(result == 1206)
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

private let testInputA =
"""
AAAA
BBCD
BBCC
EEEC
"""
//80

private let testInputB =
"""
OOOOO
OXOXO
OOOOO
OXOXO
OOOOO
"""
//436
private let testInputC =
"""
EEEEE
EXXXX
EEEEE
EXXXX
EEEEE
"""
//E shaped = 17a 12s -> 204
//incl Xs 236

private let testInputD =
"""
AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA
"""
//368 - A's have inner boundaries around the Bs

private let testInputE =
"""
AAA
AUA
AAA
"""
