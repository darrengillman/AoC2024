//
//  Library.swift
//  AdventOfCode
//
//  Created by Darren Gillman on 03/01/2025.
//
enum Direction: CaseIterable {
   case U, R, D, L
}

extension Dictionary where Key == Point, Value: CustomStringConvertible {
   
   func print() {
      Swift.print(self.render())
   }
   
   func render() -> String {
      var lines: [String] = []
      guard let maxY = self.keys.map(\.y).max()else {return ""}
      for y in 0...maxY {
         guard let maxX = self.keys.filter({$0.y == y}).map(\.x).max() else {continue}
         var line = ""
         for x in 0...maxX {
            line += (self[.init(x,y)]?.description ?? " ")
         }
         lines.append(line)
      }
      return lines.joined(separator: "\n")
   }
}

struct Point: Equatable, Hashable {
   let x: Int
   let y: Int
   
   public init(_ x: Int, _ y: Int) {
      self.x = x
      self.y = y
   }
}


extension Point {
   static func + (lhs: Point, rhs: Point) -> Point {
      Point(
         lhs.x + rhs.x,
         lhs.y + rhs.y
      )
   }
   
   var neighbours: [Point] {
      [
         .init(self.x-1, self.y),
         .init(self.x+1, self.y),
         .init(self.x, self.y+1),
         .init(self.x, self.y-1)
      ]
   }
   
   func moving(_ direction: Direction) -> Point {
      switch direction {
            
         case .U: Point(self.x, self.y-1)
         case .R: Point(self.x+1, self.y)
         case .D: Point(self.x, self.y+1)
         case .L: Point(self.x-1, self.y)
      }
   }
}

extension Point: CustomStringConvertible {
   var description: String {"(\(x), \(y))"}
}


enum Heading: CaseIterable, Hashable {
   case N, S, E, W, NE, SE, SW, NW
   
   static func headings(diagonal: Bool) -> [Heading] {
      switch diagonal {
         case false: [.N, .S, .E, .W]
         case true: Heading.allCases
      }
   }
   
   func moving(step: Int = 1 ) -> (heading: Heading, x: Int, y: Int) {
      switch self {
         case .N: (.N, 0, -step)
         case .S: (.S, 0, step)
         case .E: (.E, step, 0)
         case .W: (.W, -step ,0)
         case .NE: (.NE, step, -step)
         case .SE: (.SE, step, step)
         case .SW: (.SW, -step, step)
         case .NW: (.NW, -step, -step)
      }
   }
}

extension Int {
   var asString: String {
      String(self)
   }
}
