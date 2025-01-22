import Testing
import Foundation

@testable import AdventOfCode

@Suite("Day17 Tests")
struct Day17Tests {
   @Suite("Parser Tests")
   struct ParserTests {
      @Test("Test parser implementation")
      func parseInput() {
         let comp = Day17.Computer(data: testInput)
         #expect(comp.regA == 729)
         #expect(comp.regB == 0)
         #expect(comp.regC == 0)
         #expect(comp.program == [0,1,5,4,3,0])
         
      }
   }
   
   @Suite("Unit Tests")
   struct UnitTests {
      var comp = Day17.Computer(data: testInput)
      
      @Test mutating func testADVop2() async throws {
         comp.process(.init(opcode: 0, operand: 2))
         #expect(comp.regA == Int(729/4))
      }
      
      @Test mutating func testADVop5() async throws {
         comp.process(.init(opcode: 0, operand: 5))
         #expect(comp.regA == 729)
      }
      
      @Test mutating func bxlOp3() async throws {
         comp.process(.init(opcode: 1, operand: 3))
         #expect(comp.regB == 3)
         comp.process(.init(opcode: 1, operand: 4))
         #expect(comp.regB == 7)
         comp.process(.init(opcode: 1, operand: 2))
         #expect(comp.regB == 5)
      }
      
      @Test mutating func bst() async throws {
         comp.process(.init(opcode: 2, operand: 4))
         #expect(comp.regB == 1)
         comp.process(.init(opcode: 2, operand: 2))
         #expect(comp.regB == 2)
      }

      @Test mutating func jnz() async throws {
         comp.process(.init(opcode: 3, operand: 0))
         #expect(comp.pointer == -2)
         comp.process(.init(opcode: 3, operand: 7))
         #expect(comp.pointer == 5)
      }


   }
   
   @Suite("Tests on sample inputs")
   struct SolutionsTests {
      @Suite("Tests on sample inputs")
      struct SolutionsTests {
         let day = Day17(data: testInput)
         
         @Test("Part1 example")
         func testPart1() async throws {
            let result = try await day.part1()
            #expect(result == "4,6,3,5,6,3,5,2,1,0")
         }
         
         private let testInputA =
  """
  Register A: 9
  Register B: 0
  Register C: 0
  
  Program: 0,1,5,4,3,0
  """

         
         
         @Test("Part1B example")
         func testPart1A() async throws {
            let day = Day17(data: testInputA)
            let result = try await day.part1()
            #expect(result == "4,6,3,5,6,3,5,2,1,0")
         }
         /*
          0 ->0
          1 -> 0
          2 -> 1,0
          3 -> 1,0
          4 -> 2,1,0
          5 -> 2,1,0
          6 -> 3,1,0
          7 -> 3,1,0
          8 -> 4,2,1,0
          9 -> 4,2,1,0
          */
         
         @Test("Part2 example")
         func testPart2() async throws {
            let day = Day17(data: pt2Input)
            let result = try await day.part2()
            #expect(result == "117440")
         }
      }
   }
}

private let testInput =
  """
  Register A: 729
  Register B: 0
  Register C: 0
  
  Program: 0,1,5,4,3,0
  """

private let testInputA =
  """
  Register A: 7
  Register B: 0
  Register C: 0
  
  Program: 0,1,5,4,3,0
  """

private let pt2Input =
"""
Register A: 117440
Register B: 0
Register C: 0

Program: 0,3,5,4,3,0
"""
