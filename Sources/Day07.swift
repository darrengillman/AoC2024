import Foundation

struct Day07: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let day = 7
   let puzzleName: String = "--- Day 7 ---"
   
   let equations: [Equation]
   
   
   init(data: String) {
      equations = data
         .components(separatedBy: .newlines)
         .filter{!$0.isEmpty}
         .map{Equation(str: $0.trimmingCharacters(in: .whitespaces))}
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      equations
         .filter{ $0.validate() }
         .map{$0.total}
         .reduce(0, +)
   }
}

extension Day07 {
   struct Equation {
      let total: Int
      let values: [Int]
      
      init(str: String) {
         let bits = str.components(separatedBy: ":")
         total = Int(bits.first!)!
         values = bits.last!.components(separatedBy: " ")
            .map{$0.trimmingCharacters(in: .whitespaces) }
            .filter{!$0.isEmpty}
            .map{Int($0)!}
      }
      
      func validate() -> Bool {
         calculate(values).contains(total)
      }
      
      func calculate(_ values: [Int], operators: [Operator] = Operator.allCases) -> [Int] {
         guard values.count > 1 else {return [values[0]]}
         
         return operators.flatMap{ op in
            let children = calculate(Array(values.dropLast()))
            return children.map{ child in
               op.calculate(child, values.last!)
            }
         }
      }
      
      enum Operator: CaseIterable {
         case multiply, add
         
         func calculate(_ lhs: Int, _ rhs: Int) -> Int {
            switch self {
               case .add: lhs + rhs
               case .multiply: lhs * rhs
            }
         }
      }
   }
}
