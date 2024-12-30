import Testing
import RegexBuilder

@testable import AdventOfCode


@Suite("Day13 Tests")
struct Day13Tests {
   @Suite("Parser Tests")
   struct ParserTests {
      @Test("Test single machine input")
      func parseInput() async {
         let input = """
         Button A: X+94, Y+34
         Button B: X+22, Y+67
         Prize: X=8400, Y=5400
         """
         let testDay = Day13(data: input)
         #expect(testDay.machines(from: input).count == 1)
      }
      
      @Test("Regex 1 line")
      func regexBuild1Line() async throws {
         let input = """
         Button A: X+94, Y+34
         """
         
         let regexA = Regex {
            "Button A: X+"
            Capture {
               OneOrMore(.digit)
            } transform: {
               Int($0)!
            }
            ", Y+"
            Capture {
               OneOrMore(.digit)
            } transform: {
               Int($0)!
            }
         }
         
         let regex = Regex {
            regexA
         }
         
         let matches = input.matches(of: regex)
         print(matches[0].output)
         #expect(matches.count == 1)
      }
      
      @Test("Regex 2 line")
      func regexBuild2Line() async throws {
         let input = """
         Button A: X+94, Y+34
         Button B: X+22, Y+67
         """

         let regexA = Regex {
            "Button A: X+"
            Capture {
               OneOrMore(.digit)
            } transform: {
               Int($0)!
            }
            ", Y+"
            Capture {
               OneOrMore(.digit)
            } transform: {
               Int($0)!
            }
         }
         let regexB = Regex {
            "Button B: X+"
            Capture {
               OneOrMore(.digit)
            } transform: {
               Int($0)!
            }
            ", Y+"
            Capture {
               OneOrMore(.digit)
            } transform: {
               Int($0)!
            }
         }
         
         let regex = Regex {
            regexA
            ZeroOrMore(.any, .reluctant)
            regexB
         }
         
         let matches = input.matches(of: regex)
         print(matches[0].output)
         #expect(matches.count == 1)
      }
      
      @Test("Parse example input")
      func parseExampleInput() async throws {
         let testDay = Day13(data: testInput)
         #expect(testDay.machines(from: testInput).count == 4)
      }
      
      
   }
   
   @Suite("Tests on sample inputs")
   struct SolutionsTests {
      @Suite("Tests on sample inputs")
      struct SolutionsTests {
         let day = Day13(data: testInput)
         
         @Test("Part1 example")
         func testPart1() async throws {
               let result = try await day.part1()
               #expect(result == 480)
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
  Button A: X+94, Y+34
  Button B: X+22, Y+67
  Prize: X=8400, Y=5400
  
  Button A: X+26, Y+66
  Button B: X+67, Y+21
  Prize: X=12748, Y=12176
  
  Button A: X+17, Y+86
  Button B: X+84, Y+37
  Prize: X=7870, Y=6450
  
  Button A: X+69, Y+23
  Button B: X+27, Y+71
  Prize: X=18641, Y=10279
  """
