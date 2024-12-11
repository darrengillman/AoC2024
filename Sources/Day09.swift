import Foundation
import AoCTools

struct Day09: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let day = 9
   let puzzleName: String = "--- Day 9! ---"
   let diskMap: [Int]
   
   static func parse(_ input: String) -> [Int] {
      input
         .trimmingCharacters(in: .whitespacesAndNewlines)
         .map{Int($0.asString)!}
   }
   
   init(data: String) {
      diskMap = Self.parse(data)
   }
   
   
   func part1() async throws -> Int {
      var disk = Disk(diskMap: diskMap)
      disk.run()
      return disk.checksum
   }
}

   // Add any extra code and types in here to separate it from the required behaviour
extension Day09 {
   
   enum Block: Equatable {
      case file(id: Int)
      case free
   }
   
   enum Entry: Equatable {
      case file(id: Int, size: Int)
      case free(size: Int)
      
      var size: Int {
         switch self {
            case let .file(_, size): size
            case let .free(size): size
         }
      }
   }
   
   struct Disk {
      var blockLevel: Bool
      var blockFilesystem: [Block]
      var documentFileSystem: [Entry]
      
      var checksum: Int {
         blockLevel ? blockChecksum : fileChecksum
      }
      private var blockChecksum: Int {
         blockFilesystem
            .indices
            .reduce(0){ sum, index in
               if case let .file(id) = blockFilesystem[index] {
                  sum + id * index
               } else {
                  sum
               }
            }
      }
      
      private var fileChecksum: Int {0}
      
      
      init(diskMap: [Int], blockLevel: Bool = true) {
         self.blockLevel = blockLevel
         if blockLevel {
            documentFileSystem = []
            blockFilesystem = diskMap
               .enumerated()
               .flatMap{(offset, value) in
                  if offset.isMultiple(of: 2) {
                     return Array(repeating: Block.file(id: offset/2), count: value)
                  } else {
                     return Array(repeating: .free, count: value)
                  }
               }
         } else {
            blockFilesystem = []
            documentFileSystem = diskMap
               .enumerated()
               .map{(offset, value) in
                  if offset.isMultiple(of: 2) {
                     return Entry.file(id: offset/2, size: value)
                  } else {
                     return .free(size: value)
                  }
               }
         }
      }
      
      mutating func run() {
         if blockLevel {
            blockRun()
         } else {
            fileRun()
         }
      }
      
      mutating func fileRun() {
         var lastFileProcessed: Int?
         
         var lastFileIndex: Int {
            documentFileSystem.lastIndex { entry in
               if case let .file(id, _) = entry {
                  lastFileProcessed == nil ? true : id < lastFileProcessed!
               } else {
                  false
               }
            }
            ?? documentFileSystem.startIndex
         }
         
         while lastFileIndex != documentFileSystem.startIndex {
            let file = documentFileSystem[lastFileIndex]
         }
         
         
      }
      
      
      
      
      
      
      
      
      
      mutating func blockRun() {
         var lastFileIndex: Int { blockFilesystem.lastIndex(where: { block in
            if case .file = block { true } else { false }
         } ) ?? blockFilesystem.startIndex
         }
         
         var nextFreeIndex: Int { blockFilesystem.firstIndex(where: {
            if case .free = $0 {true} else {false}
         }) ?? blockFilesystem.endIndex
         }
         
         while nextFreeIndex < lastFileIndex {
            blockStep(nextFreeIndex: nextFreeIndex, lastFileIndex: lastFileIndex)
         }
      }
      
      mutating func blockStep(nextFreeIndex: Int, lastFileIndex: Int) {
         blockFilesystem[nextFreeIndex] = blockFilesystem[lastFileIndex]
         blockFilesystem[lastFileIndex] = .free
      }
   }
}

extension Array where Element == Day09.Block {
   var description: String {
      self
         .map{
            if case let Day09.Block.file(id) = $0 {
               "\(id)"
            } else {
               "."
            }
         }.joined()
   }
}

