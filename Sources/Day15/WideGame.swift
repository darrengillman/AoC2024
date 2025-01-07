//
//  Day15-WideGame.swift
//  AdventOfCode
//
//  Created by Darren Gillman on 04/01/2025.
//
import Foundation
import Collections

extension Day15 {
   typealias WideGrid = [Point: Node]
   
   struct Node: CustomStringConvertible {
      let id = UUID()
      let type: NodeType
      let side: Side
      
      var description: String {
         switch type {
            case .box:
               if side == .left {
                  "["
               } else if side == .right {
                  "]"
               } else {
                  fatalError("created an extra dimension")
               }
            default: type.description
         }
      }
   }
   
   private struct Movement: Hashable {
      let robotStart: Point
      var shifts: Int
      let direction: Direction
   }
   
   struct WideGame {
      var grid: WideGrid
      let moves: [Direction]
      var movesIndex = 0
      var robot: Point
      
      var score: Int {
         grid
            .filter{$0.value.side == .left}
            .keys
            .reduce(0){ sum, point in
               sum + 100 * point.y + point.x
            }
      }
      
      internal init(stdGrid: StdGrid, moves: [Direction]) {
         self.moves = moves
         
         grid = stdGrid
            .reduce(into: WideGrid()) { wideGrid, item in
               switch item.value {
                  case .robot:
                     wideGrid[.init(item.key.x * 2, item.key.y)] = Node(type: .robot, side: .whoCares)
                     wideGrid[.init(item.key.x * 2 + 1, item.key.y)] = Node(type: .space, side: .whoCares)
                  case .wall:
                     wideGrid[.init(item.key.x * 2, item.key.y)] = Node(type: .wall, side: .whoCares)
                     wideGrid[.init(item.key.x * 2 + 1, item.key.y)] = Node(type: .wall, side: .whoCares)
                  case .box:
                     wideGrid[.init(item.key.x * 2, item.key.y)] = Node(type: .box, side: .left)
                     wideGrid[.init(item.key.x * 2 + 1, item.key.y)] = Node(type: .box, side: .right)
                  case .space:
                     wideGrid[.init(item.key.x * 2, item.key.y)] = Node(type: .space, side: .whoCares)
                     wideGrid[.init(item.key.x * 2 + 1, item.key.y)] = Node(type: .space, side: .whoCares)
               }
            }
         
         robot = grid.first(where: {(_, value) in
            value.type == .robot
         })!.key
      }
      
      mutating func move(_ point: Point, direction: Direction) {
         var queue: OrderedSet<Point> = [point]
         var pointer = queue.startIndex
         
         while (pointer != queue.endIndex) && !queue.isEmpty {
            let next = queue[pointer].moving(direction)
            guard let destination = grid[next] else {fatalError("We've escaped the walls!!!")}
            switch destination.type {
               case .space:
                  pointer += 1
               case .wall:
                  queue.removeAll()
               case .robot:
                  fatalError("Found a clone!")
               case .box where direction == .U || direction == .D:
                  queue.append(next)
                  if destination.side == .left {
                     queue.append(Point(next.x+1, next.y))
                  } else {
                     queue.append(Point(next.x-1, next.y))
                  }
                  pointer += 1
               case .box:
                  queue.append(next)
                  pointer += 1
            }
         }
         
         guard !queue.isEmpty else {return}
         
         for point in queue.reversed() {
            grid[point.moving(direction)] = grid[point]
            grid[point] = .init(type: .space, side: .whoCares)
         }
      }
      
      private mutating func nextDirection() -> Direction? {
         guard movesIndex != moves.endIndex else {return nil}
         let move = moves[movesIndex]
         movesIndex += 1
         return move
      }
      
      mutating func runPt2() {
         while let direction = nextDirection() {
            move(robot, direction: direction)
            robot = grid.first(where: { $0.value.type == .robot })!.key
         }
      }
   }
}
