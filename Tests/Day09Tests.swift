import Testing

@testable import AdventOfCode

@Suite("Day09 Tests")
struct Day09Tests {
   @Suite("Parser Tests")
   struct ParserTests {
      @Test("Test parser implementation")
      func parseInput() {
         let shortDay = Day09(data: shortInput)
         #expect(shortDay.diskMap.count == 5)
         let day = Day09()
         #expect(day.diskMap.count == 19_999)
      }
   }
   
   @Suite("TDDish Tests")
   struct TDDtests {
      var disk = Day09.Disk(diskMap: Day09.parse(shortInput))
      
      @Test("parsing")
      func parseBasicInput() {
         let expected = [
            Day09.Block.file(id: 0),
            .free,
            .free,
            .file(id: 1),
            .file(id: 1),
            .file(id: 1),
            .free,
            .free,
            .free,
            .free,
            .file(id: 2),
            .file(id: 2),
            .file(id: 2),
            .file(id: 2),
            .file(id: 2),
         ]
         #expect(disk.blockFilesystem == expected)
      }
      
      @Test("Single Step")
      mutating func testSingleStep() {
         disk.step()
         let expected = "02.111....2222."
         #expect(disk.blockFilesystem.description == expected)
      }
      
      @Test("Full run")
      mutating func testFullSimpleRun() {
         disk.run()
         #expect(disk.blockFilesystem.description == "022111222......")
      }
      
      var disk2 = Day09.Disk(diskMap: Day09.parse(testInput))
      
      @Test("Full run 2")
      mutating func testFullSimpleRun2() {
         disk2.run()
         #expect(disk2.blockFilesystem.description == "0099811188827773336446555566..............")
      }
   }
   
   
   
   @Suite("Tests on sample inputs")
   struct SolutionsTests {
      @Suite("Tests on sample inputs")
      struct SolutionsTests {
         let day = Day09(data: testInput)
         
         @Test("Part1 example")
         func testPart1() async throws {
            
               let result = try await day.part1()
               #expect(result == 1928)
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
  2333133121414131402
  """

private let shortInput =
"""
12345
"""

