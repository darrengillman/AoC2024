import Foundation
import Collections
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
   
   func part2() async throws -> String {
      var computer = Computer(data: data)
      let result = computer.runPt2()
      return result.asString
   }
}

   // Add any extra code and types in here to separate it from the required behaviour
typealias Operand = Int

extension Day17 {
   enum Op: Int, CustomStringConvertible {
      case adv = 0
      case bxl, bst, jnz, bxc, out, bdv, cdv
      
      var description: String {
         switch self {
            case .adv: return "adv"
            case .bxl: return "bxl"
            case .bst: return "bst"
            case .jnz: return "jnz"
            case .bxc: return "bxc"
            case .out: return "out"
            case .bdv: return "bdv"
            case .cdv: return "cdv"
         }
      }
   }
   
   struct Instruction: Equatable, CustomStringConvertible {
      var description: String {
         "\(op) \(operand)"
      }
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
            let instruction = Instruction(opcode: program[pointer], operand: program[pointer+1])
            process(instruction)
            pointer += 2
         }
         return output.map{$0.asString}.joined(separator: ",")
      }
      
      
      mutating func runPt2() -> Int {
         var queue: Deque<(regA: Int, octet: Int)> = [(0,1)]
         
         while let item = queue.popFirst() {
            for i in 0...7 {
               let newA = (item.regA << 3) + i
               output = []
               regA = newA
               regB = 0
               regC = 0
               pointer = 0
               while pointer < program.endIndex {
                  let instruction = Instruction(opcode: program[pointer], operand: program[pointer+1])
                  process( instruction)
                  pointer+=2
               }
               if output == program.suffix(item.octet).asArray() {
                  if output.count == program.count {
                     return newA
                  }
                  queue.append((newA, item.octet + 1))
               }
            }
         }
         fatalError()
      }
   }
}
