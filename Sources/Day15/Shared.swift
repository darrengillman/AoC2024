//
//  Shared.swift
//  AdventOfCode
//
//  Created by Darren Gillman on 05/01/2025.
//

import RegexBuilder
import Foundation

extension Day15 {  //Shared
   enum NodeType: String, CustomStringConvertible {
      var description: String {self.rawValue}
      
      case robot = "@"
      case wall = "#"
      case box = "O"
      case space = "."
   }
   
   static func parse(input: String) -> StdGame {
      let nodeRegex = Regex {
         One(.anyOf("#.O@"))
      }
      
      let mapLineCapture = Regex {
         Anchor.startOfLine
         Capture {
            OneOrMore(nodeRegex)
         } transform: {
            $0.map{$0}
         }
         Anchor.endOfLine
      }
      
      let mapRegex = Regex {
         OneOrMore(mapLineCapture)
      }
      
      let directionRegex = Regex {
         One(.anyOf("^v<>"))
      }
      
      let movesCapture = Regex{
         Anchor.startOfLine
         Capture {
            OneOrMore(directionRegex)
         } transform: { string in
            string.map{ char in
               switch char {
                  case "^": Direction.U
                  case "v": Direction.D
                  case ">": Direction.R
                  case "<": Direction.L
                  default: fatalError("Ooops!")
               }
            }
         }
         Anchor.endOfLine
      }
      
      let nodeArray = input
         .matches(of: mapRegex)
         .map{ output in
            output.1.map {
               NodeType(rawValue: $0.asString)!
            }
         }
      
      let grid =
      (0..<nodeArray.count).reduce(into: [Point: NodeType]()) { dict, y in
         (0..<nodeArray[y].count).forEach { x in
            dict[.init(x, y)] = nodeArray[y][x]
         }
      }
      
      let moves = input
         .matches(of: movesCapture)
         .flatMap{
            $0.output.1
         }

      return StdGame(grid: grid, moved: moves)
   }
}


