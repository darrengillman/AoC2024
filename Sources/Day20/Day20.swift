import Collections
import Algorithms
import Foundation

struct Day20: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let data: String
   let day = 0
   let puzzleName: String = "--- Day 0: Placeholder! ---"
   let track: Racetrack
   init(data: String) {
      self.data = data
      track = Racetrack(input: data)
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      track.findSingleCheats()
   }
   
   func part2() async throws -> Int {
      track.findMultiCheats()
   }
}

extension Day20 {
   enum Location {
      case path, wall
   }
   
   struct Racetrack{
      var grid: [Point: Location] = [:]
      var maxX, maxY: Int
      var start, end: Point!
      
      var route: [Point] = []
      var shortcuts: [Point] = []
      
      init(input: String) {
         let lines = input
            .components(separatedBy: .newlines)
            .map{$0.map{$0}}
         for y in 0..<lines.count {
            for x in 0..<lines[y].count {
               let cell = lines[y][x]
               grid[.init(x,y)] = cell == "#" ? .wall : .path
               if cell.asString == "S" {
                  start = .init(x,y)
               } else if cell.asString == "E"{
                  end = .init(x,y)
               }
            }
         }
         maxX = grid.keys.map(\.x).max()!
         maxY = grid.keys.map(\.y).max()!
         route = { route(from: start, to: end) }()
         shortcuts = { findShortCuts() }()
      }
      
      func findSingleCheats() -> Int {
         let savings = shortcuts.reduce(into: [Int]() ) {savings, shortcut in
            savings.append(contentsOf:  shortcut
               .neighbours
               .filter{grid[$0] != .wall}
               .map{route.firstIndex(of: $0)!}  //-> [Int (indexes) for positions into the path for each shortcut
               .combinations(ofCount: 2)        // -> [ pairs of index into path]
               .map{ abs($0.first! - $0.last!) - 2 }
            )
         }
         
//         savings.reduce(into: [Int: Int]() ) {$0[$1,default: 0 ] += 1}
//            .sorted{$0.value < $1.value}
//            .forEach{print("\($0.key): \($0.value)")}
         
         return savings.count{$0 >= 100}
      }
         
      func hops(from a : Point, to b: Point) -> Int {
         abs(route.firstIndex(of: a)! - route.firstIndex(of: b)!)
      }
      
      func manhattan(from a : Point, to b: Point) -> Int {
         abs(a.x - b.x) + abs(a.y - b.y)
      }
         
      func findMultiCheats() -> Int {
         let posInRoute: [Point: Int] = route.enumerated().reduce(into: [Point: Int]() ){ $0[$1.element] = $1.offset}
         
         return route
            .combinations(ofCount: 2)
            .filter{ manhattan(from: $0.first!, to: $0.last!) <= 20}
            .map { abs(posInRoute[$0.first!]! - posInRoute[$0.last!]!) - manhattan(from: $0.first!, to: $0.last!) }
            .count{$0 >= 100}
         
         
      }
      
      func findShortCuts() -> [Point] {
         grid
            .filter{ $0.value == .wall }
            .filter{$0.key.x > 0 && $0.key.x < maxX && $0.key.y > 0 && $0.key.y < maxY}
            .filter{ $0
               .key
               .neighbours
               .count(where: { neighbour in grid[neighbour] != .wall}) > 1 }
            .map(\.key)
      }
      
      func route(from start: Point, to end: Point, path: [Point] = []) -> [Point]{
         var q: Deque<(point: Point, path: [Point])> = [ (start, []) ]
         
         while let next = q.popFirst() {
            let newPath = next.path + [next.point]
            guard next.point != end else {return newPath}
            let moves = next
               .point
               .neighbours
               .filter{$0.x > 0 && $0.x < maxX && $0.y > 0 && $0.y < maxY}
               .filter{!newPath.contains($0)}
               .filter{grid[$0] != .wall}
               .map{($0, newPath)}
            
            q.append(contentsOf: moves)
         }
         fatalError()
      }
   }
}
