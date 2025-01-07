//
//  Day15-StdGame.swift
//  AdventOfCode
//
//  Created by Darren Gillman on 04/01/2025.
//

import Foundation
extension Day15 {
   typealias StdGrid = [Point: NodeType]
   
   enum Side {
      case left, right, whoCares
   }
   
   struct StdGame {
      var grid: StdGrid
      
      let moves: [Direction]
      private var movesIndex = 0
      var robot: Point
      
      var score: Int {
         grid
            .filter{$0.value == .box}
            .keys
            .reduce(0){$0 + 100 * $1.y + $1.x}
      }
      
      internal init(grid: [Point : Day15.NodeType], moved: [Direction]) {
         self.grid = grid
         self.moves = moved
         self.robot = grid.first(where: {(_, value) in
            value == .robot
         })!.key
      }
      
      mutating func runPt1() {
         while let direction = nextDirection() {
            move(in: direction)
         }
      }
      
      private mutating func nextDirection() -> Direction? {
         guard movesIndex != moves.endIndex else {return nil}
         let move = moves[movesIndex]
         movesIndex += 1
         return move
      }
      
      private func possibleMove(heading direction: Direction) -> [Point] {
         let maxX = grid.keys.map(\.x).max()!
         let maxY = grid.keys.map(\.y).max()!
         
         return switch direction {
            case .U: (0..<robot.y).map{Point(robot.x, $0)}.reversed()
            case .D: (robot.y+1...maxY).map{Point(robot.x, $0)}
            case .R: ((robot.x+1)...maxX).map{Point($0, robot.y)}
            case .L: (0..<robot.x).map{Point($0, robot.y)}.reversed()
         }
      }
      
      private mutating func move(in direction: Direction) {
         let path1 = possibleMove(heading: direction)
         
         let path = path1.prefix(while: {grid[$0] != .wall})
         guard var spaceIndex = path.firstIndex(where: {grid[$0] == .space}) else {return}
         
         while spaceIndex != 0 {
            grid[path[spaceIndex]] = grid[path[spaceIndex-1]]
            spaceIndex -= 1
         }
         grid[path[0]] = .robot
         grid[robot] = .space
         robot = path[0]
      }
   }
}
