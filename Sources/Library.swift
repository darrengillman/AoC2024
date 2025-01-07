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
      guard let maxY = self.keys.map(\.y).max()else {return}
      for y in 0...maxY {
         let line = self.filter{$0.key.y == y}.sorted{$0.key.x < $1.key.x}.map(\.value.description).joined()
         Swift.print(line)
      }
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
