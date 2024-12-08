struct Day8: AdventDay {
  var dayIndex = 8
  private let antennas: [Character: [Point]]
  private let gridDimensions: Point

  init(_ fullInput: String) {
    let lines = fullInput.components(separatedBy: "\n").filter { $0.count > 0 }
    var antennas = [Character: [Point]]()
    for row in 0..<lines.count {
      let chars = [Character](lines[row])
      for col in 0..<chars.count {
        if chars[col] != "." {
          antennas[chars[col], default: []].append(Point(row: row, col: col))
        }
      }
    }
    self.antennas = antennas
    gridDimensions = Point(row: lines.count, col: lines[0].count)
  }

  func partOne() {
    var antinodes = Set<Point>()
    for (_, positions) in antennas {
      for (a1, a2) in positions.pairs() {
        let diff = a2 - a1
        for anti in [a1 - diff, a2 + diff] {
          if anti.inBounds(forDimensions: gridDimensions) {
            antinodes.insert(anti)
          }
        }
      }
    }
    print("Part 1: \(antinodes.count)")
  }

  func partTwo() {
    // TODO:
  }
}

private struct Point: Equatable, Hashable {
  let row, col: Int

  func inBounds(forDimensions dims: Point) -> Bool {
    row >= 0 && row < dims.row && col >= 0 && col < dims.col
  }

  static func + (left: Point, right: Point) -> Point {
    Point(row: left.row + right.row, col: left.col + right.col)
  }

  static func - (left: Point, right: Point) -> Point {
    left + (-right)
  }

  static prefix func - (point: Point) -> Point {
    Point(row: -point.row, col: -point.col)
  }
}

extension Array where Element == Point {
  func pairs() -> [(Point, Point)] {
    var res = [(Point, Point)]()
    for i1 in 0..<(count - 1) {
      for i2 in i1 + 1..<count {
        let pair = (self[i1], self[i2])
        res.append(pair)
      }
    }
    return res
  }
}
