  import Testing
import RegexBuilder

  @testable import AdventOfCode

  @Suite("Day03 Tests")
  struct Day03Tests {
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
      let dayp1 = Day03(data: testInput1)
      let dayp2 = Day03(data: testInput2)

      @Test("Part1")
      func testPart1() async throws {
          let result = try await dayp1.part1()
          #expect(result == 161)
      }
       
       @Test("Builder Part 1")
       func testRegexBuilder() {
          
          let regex2 = Regex{
             "mul("
             Capture {
                Repeat(1...3) {.digit}
             }
             ","
             Capture {
                Repeat(1...3) {.digit}
             }
             ")"
          }

          let matches = testInput1.matches(of: regex2)
          matches.forEach {
             print($0.output.0, $0.output.1, $0.output.2)
          }
          
          let sum = matches
             .map{ Int($0.output.1)! * Int($0.output.2)! }
             .reduce(0, +)
          
          #expect(sum == 161)
       }
       
   
       @Test("Builder Pt2", .disabled())
       func applyBuilder2() {
          
          let input = "do()mul(2,3)mul(4,567)don't()"
          
          let mulPattern =  Regex{
             "mul("
             Capture {
                Repeat(1...3) {
                   One(.digit)
                }
             }
             ","
             Capture {
                Repeat(1...3) {
                   One (.digit)
                }
             }
             ")"
          }
          
          let pattern = Regex {
             "do()"
             OneOrMore {
                ZeroOrMore(.reluctant){.any}
                mulPattern
                ZeroOrMore(.reluctant){.any}
             }
             "don't()"
          }.repetitionBehavior(.reluctant)
          
          let matches = input.matches(of: pattern)
          
          #expect(matches.count == 1)
          
          for match in matches {
             print(match.output.0,  match.output.1, match.output.2)
          }
       }
       

      @Test("Part2 example")
      func testPart2() async throws {
        await withKnownIssue {
          let result = try await dayp2.part2()
          #expect(result == 10)
        }
      }
    }
  }
}

private let testInput1 =
  """
  xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
  """

private let testInput2 =
"""
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
"""
