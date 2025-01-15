import Foundation
import RegexBuilder

struct Day17: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let data: String
   let day = 17
   let puzzleName: String = "--- Day 17 ---"
   
   init(data: String) {
      self.data = data
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> String {
      var computer = Computer(data: data)
      return computer.runPt1()
   }
}

   // Add any extra code and types in here to separate it from the required behaviour
typealias Operand = Int

extension Day17 {
   
   
   enum Op: Int {
      case adv = 0
      case bxl, bst, jnz, bxc, out, bdv, cdv
   }
   
   struct Instruction: Equatable {
      let op: Op
      let operand: Int
      
      init(opcode: Int, operand: Int) {
         self.op = Op(rawValue: opcode)!
         self.operand = operand
      }
   }
   
   struct Computer {
      var regA: Int
      var regB: Int
      var regC: Int
      
      let program: [Int]
      
      var pointer = 0
      
      var output: [Int] = []
      
      init(data: String) {
         let intRegex = Regex {
            Capture {
               OneOrMore (
                  .digit, .possessive
               )
            } transform: {
               Int($0)!
            }
         }
         
         let registers = Regex {
            "Register A: "
            intRegex
            One(.newlineSequence)
            "Register B: "
            intRegex
            One(.newlineSequence)
            "Register C: "
            intRegex
            OneOrMore(.newlineSequence)
            "Program: "
            Capture {
               OneOrMore(.anyOf("01234567,"))
            } transform: {
               $0.compactMap{Int($0.asString)}
//                  .chunks(ofCount: 2)
//                  .map{Instruction(opcode: $0.first!, operand: $0.last!)}
            }
         }
         
         let match = data.firstMatch(of: registers)
         (_, regA, regB, regC, program) = match!.output
      }
      
      func comboValue(for operand: Int) -> Int {
         switch operand {
            case ...3: operand
            case 4: regA
            case 5: regB
            case 6: regC
            default: fatalError()
         }
      }
      
      mutating func process(_ instruction: Instruction) {
         switch instruction.op {
               
            case .adv: regA = Int( Double(regA) / pow(2,Double(comboValue(for: instruction.operand))))
               
            case .bxl: regB = regB ^ instruction.operand
               
            case .bst: regB = comboValue(for: instruction.operand) % 8
               
            case .jnz: pointer = regA == 0 ? pointer : instruction.operand - 2
               
            case .bxc: regB = regB ^ regC
               
            case .out: output.append(comboValue(for: instruction.operand) % 8)
               
            case .bdv: regB = Int( Double(regA) / pow(2,Double(comboValue(for: instruction.operand))))
               
            case .cdv: regC = Int( Double(regA) / pow(2,Double(comboValue(for: instruction.operand))))
         }
      }
      
      mutating func runPt1() -> String {
         while pointer < program.endIndex {
//            print("A: \(regA)   B: \(regB)  C: \(regC)")
//            print("\(pointer) -> \(instructions[pointer])")
            let instruction = Instruction(opcode: program[pointer], operand: program[pointer+1])
            process(instruction)
            pointer += 2
         }
         return output.map{$0.asString}.joined(separator: ",")
      }
      
      
   }
}
