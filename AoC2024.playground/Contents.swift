import Foundation

extension ArraySlice {
   func asArray() -> Array<Self> { Array(arrayLiteral: self) }
}

enum Operator: CaseIterable {
   case multiply, add
   
   func calculate(_ lhs: Int, _ rhs: Int) -> Int {
      switch self {
         case .add:
            return lhs + rhs
         case .multiply:
            return lhs * rhs
      }
   }
}

func process(_ values: [Int], operators: [Operator] = Operator.allCases) -> [Int] {
   guard values.count > 1 else {return [values[0]]}
   
   return operators.flatMap{ op in
      let children = process(Array(values.dropLast()))
      return children.map{ child in
         op.calculate(child, values.last!)
      }
   }
}

process([1,2,3,1]).forEach{print($0)}








/*
 [123]
 1+2+3 = 6
 1+2*3 = 9
 1*2+3 = 5
 1*2*3 = 6
 */
