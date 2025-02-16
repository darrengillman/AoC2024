import Foundation
import Collections

struct Day21: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let data: String
   let day = 21
   let puzzleName: String = "--- Day 21 ---"
   
   init(data: String) {
      self.data = data
   }
   
   func part1() async throws -> Int {
      run(loops: 3)
   }
   
   func part2() async throws -> Int {
      run(loops: 26)
   }
      
   func run(loops: Int) -> Int {
      let numberPadSequences = data
         .components(separatedBy: .newlines)
         .map{$0.trimmingCharacters(in: .whitespaces)}
         .filter{!$0.isEmpty}
         .map{$0.compactMap{Button(rawValue: $0.asString)}}
      
      var complexity = 0
      for sequence in numberPadSequences {
         var routes: [ButtonSequence] = [sequence]
         
         for i in 0 ..< loops {
            let keyPad =  i == 0 ? Pad(numPad: true) : Pad(numPad: false)
            routes = routes
               .flatMap{keyPad.shortestSequences(for: $0)}
               .shortest()
         }
         complexity += (routes.first?.count ?? 0) * codeValue(for: sequence)
      }
      return complexity
   }
}

extension Day21{
   struct Pad {
      enum Move: String {
         case up = "^"
         case down = "v"
         case right = ">"
         case left = "<"
         case push = "A"
      }
      
      private let numberPadDef = [
         (0,0,"7"),
         (1,0,"8"),
         (2,0,"9"),
         (0,1,"4"),
         (1,1,"5"),
         (2,1,"6"),
         (0,2,"1"),
         (1,2,"2"),
         (2,2,"3"),
         (1,3,"0"),
         (2,3,"A"),
      ]
      
      private let arrowPadDef = [
         (0, 0, " "),
         (1, 0, "^"),
         (2, 0, "A"),
         (0, 1, "<"),
         (1, 1, "v"),
         (2, 1, ">")
      ]
      
      private let grid: [Point: Button]
      
      init(numPad: Bool ) {
         grid = (numPad ? numberPadDef : arrowPadDef)
            .reduce(into: [Point: Button]() ) {
               $0[.init($1.0, $1.1)] = Button(rawValue: $1.2)
            }
      }
      
         // New version required
      
      
      func shortestSequences(for sequence: ButtonSequence) -> [ButtonSequence] {
         let shortRouteComponents = ([Button.keyA] + sequence)
            .adjacentPairs()
            .map{ moves(from: $0.0, to: $0.1) }
         
         let shortestRoutes = combine(shortRouteComponents)
         
         return shortestRoutes
      }
      
      private func moves(from: Button, to: Button) -> [ButtonSequence] {
         let movesToPressButton =
         shortestRoutes(from: from, to: to)
            .map{
               commandSequence(for: $0 ) + [Button.keyA]
            }
         return movesToPressButton
      }
      
      private func point(for key: Button) -> Point {
         grid.first{$0.value == key}!.key
      }
      
      private func shortestRoutes(from: Button, to: Button) -> [Route] {
         let start = point(for: from)
         let end = point(for: to)
         var routes: [Route] = []
         var visited = Set<Point>()
         var q: Deque<(point: Point, path: Route)> = [(start, [])]
         
         while !q.isEmpty {
            let next = q.popFirst()!
            let newPath = next.path + [next.point]
            guard next.point != end else {
               routes.append(newPath)
               continue
            }
            
            let nextSteps = next
               .point
               .neighbours
               .filter{visited.contains($0) == false}
               .filter{grid.keys.contains($0)}
               .map{($0, newPath)}
            
            visited.insert(next.point)
            q.append(contentsOf: nextSteps)
         }
         return routes.shortest()
      }
      
      private func commandSequence(for route: Route) -> ButtonSequence {
         route
            .adjacentPairs()
            .compactMap{ (a,b) in
               switch (a.x - b.x, a.y - b.y) {
                  case (1, 0): Button.leftKey
                  case (-1, 0): Button.rightKey
                  case (0, 1): Button.upKey
                  case (0, -1): Button.downKey
                  default: nil
               }
            }
      }
      
      private func combine(_ arrays: [[ButtonSequence]]) -> [ButtonSequence] {
         guard !arrays.isEmpty else {  return [[]] }
         
         let current = arrays.first!
         let combined = combine(arrays.dropFirst().asArray() )
         
         var result: [ButtonSequence] = []
         
         for array in current {
            for combination in combined {
               result.append(array + combination)
            }
         }
         return result
      }
   }
}

extension Day21 {
   typealias Route = [Point]
   typealias ButtonSequence = [Button]
   
   private func codeValue(for entry: ButtonSequence) -> Int {
      Int(entry.filter{Int($0.rawValue) != nil}.map{$0.rawValue}.joined())!
   }
   
   enum Button: String, CustomStringConvertible {
      case upKey = "^"
      case downKey = "v"
      case rightKey = ">"
      case leftKey = "<"
      case key1 = "1"
      case key2 = "2"
      case key3 = "3"
      case key4 = "4"
      case key5 = "5"
      case key6 = "6"
      case key7 = "7"
      case key8 = "8"
      case key9 = "9"
      case key0 = "0"
      case keyA = "A"
      
      var description: String {
         rawValue
      }
   }
}

extension Sequence where Element == Day21.Route {
   func shortest() -> [Day21.Route]{
      let min = self.map(\.count).min()!
      return self.filter{$0.count == min}
   }
}

extension Sequence where Element == Day21.ButtonSequence {
   func shortest() -> [Day21.ButtonSequence]{
      let min = self.map(\.count).min()!
      return self.filter{$0.count == min}
   }
}
