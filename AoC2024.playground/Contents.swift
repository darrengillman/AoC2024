import Foundation

extension ArraySlice {
   func asArray() -> Array<Self> { Array(arrayLiteral: self) }
}


let data =
"""
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
"""

let lines = data
   .components(separatedBy: .newlines)
   .map{$0.map{$0}}

let points = (0..<lines.count)
   .flatMap{ y in
      (0..<lines.first!.count).map { x in
         (x, y, lines[y][x])
      }
   }
   .filter{$0.2 != "."}

let grid = Dictionary(grouping: points, by: \.2).mapValues(Point(\.0, \.1) )

grid

print(grid)

