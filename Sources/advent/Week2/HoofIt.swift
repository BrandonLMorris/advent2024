// A topological map, where each position corresponds to its elevation
private typealias TopMap = [[Int]]

struct Day10: AdventDay {
  var dayIndex = 10
  private let topMap: TopMap

  init(_ fullInput: String) {
    topMap = TopMap.fromLines(fullInput.components(separatedBy: "\n").filter { $0.count > 0 })
  }

  func partOne() {
    var count = 0
    for pos in topMap.positions {
      count += topMap.hike(from: pos).filter({ topMap[$0] == 9 }).count
    }
    print("Part 1: \(count)")
  }

  func partTwo() {
    var count = 0
    for start in topMap.positions {
      _ = topMap.hike(from: start) { pos in
        count += topMap[pos] == 9 ? 1 : 0
      }
    }
    print("Part 2: \(count)")
  }
}

extension TopMap {
  fileprivate static func fromLines(_ lines: [String]) -> TopMap {
    var map = TopMap()
    for line in lines {
      map.append(line.map({ Int("\($0)")! }))
    }
    return map
  }

  fileprivate var dimensions: Position {
    Position(self.count, self[0].count)
  }

  fileprivate var positions: [Position] {
    get {
      var positions: [Position] = []
      for row in 0..<self.count {
        for col in 0..<self[row].count {
          positions.append(Position(row, col))
        }
      }
      return positions
    }
  }

  fileprivate subscript(_ p: Position) -> Int {
    get {
      self[p.row][p.col]
    }
  }

  fileprivate func hike(
    from startingPoint: Position, doAtEachPosition: (Position) -> Void = { _ in }
  ) -> Set<Position> {
    guard self[startingPoint] == 0 else { return Set() }
    var visited = Set<Position>()
    var toVisit = [startingPoint]
    while toVisit.count > 0 {
      let pt = toVisit.removeFirst()
      doAtEachPosition(pt)
      visited.insert(pt)
      let height = self[pt]
      let neighbors = pt.neighbors(dimensions).filter { potential in
        !visited.contains(potential) && self[potential] == height + 1
      }
      toVisit.append(contentsOf: neighbors)
    }
    return visited
  }
}

private struct Position: Hashable {
  let row, col: Int

  init(_ row: Int, _ col: Int) {
    self.row = row
    self.col = col
  }

  func neighbors(_ dims: Position) -> [Position] {
    let potential =
      [
        Position(row - 1, col), Position(row + 1, col), Position(row, col - 1),
        Position(row, col + 1),
      ]
    return potential.filter { $0.row >= 0 && $0.col >= 0 && $0.row < dims.row && $0.col < dims.col }
  }
}
