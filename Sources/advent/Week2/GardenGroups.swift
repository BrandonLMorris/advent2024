struct Day12: AdventDay {
  var dayIndex = 12
  let grid: [[Character]]

  init(_ fullInput: String) {
    let lines = fullInput.components(separatedBy: "\n").filter { $0.count > 0 }
    grid = lines.map({ [Character]($0) })
  }

  func partOne() {
    let cost = survey(grid) { price($0, grid) }
    print("Part 1: \(cost)")
  }

  func partTwo() {
    let cost = survey(grid) { bulkPrice($0, grid) }
    print("Part 2: \(cost)")
  }
}

private func survey(_ input: [[Character]], pricing: (Set<Point>) -> Int) -> Int {
  var sections: Set<Set<Point>> = []
  var allVisited: Set<Point> = []
  for row in 0..<input.count {
    for col in 0..<input[row].count {
      let point = Point(row: col, col: row)
      guard !allVisited.contains(point) else { continue }
      // Flood from this location
      let section = flood(from: point, input)
      sections.insert(section)
      allVisited.formUnion(section)
    }
  }
  // Price each section and return the sum
  return sections.map(pricing).reduce(0, +)
}

private func price(_ section: Set<Point>, _ grid: [[Character]]) -> Int {
  let per = perimiter(section, grid)
  let cost = section.count * per
  return cost
}

private func bulkPrice(_ section: Set<Point>, _ grid: [[Character]]) -> Int {
  let sides = sides(section, grid)
  let cost = section.count * sides
  return cost
}

private func perimiter(_ section: Set<Point>, _ grid: [[Character]]) -> Int {
  var count = 0
  for point in section {
    // Handle edge of the grid special, since neighbors() only returns valid points
    if point.row == 0 || point.row == grid.count - 1 { count += 1 }
    if point.col == 0 || point.col == (grid[point.row].count - 1) { count += 1 }
    count +=
      neighbors(of: point, grid).filter { grid[$0.row][$0.col] != grid[point.row][point.col] }.count
  }
  return count
}

private func sides(_ section: Set<Point>, _ grid: [[Character]]) -> Int {
  // Determine all the boundaries, which include a point and direction (e.g. north)
  let boundaries = boundaries(section, grid)
  // A 'side' is a group aligned boundaries that share their direction
  var sides = [Side]()
  for boundary in boundaries.sorted(by: {
    $0.point.row < $1.point.row || ($0.point.row == $1.point.row && $0.point.col < $1.point.col)
  }) {
    switch boundary.direction {
    case .north, .south:
      // Check if the left and right spaces exist in a side
      if let side = sides.horizontalAdjacent(to: boundary) {
        side.add(boundary)
      } else {
        sides.append(Side(boundary))
      }
    case .east, .west:
      // Check above and below
      if let side = sides.verticalAdjacent(to: boundary) {
        side.add(boundary)
      } else {
        sides.append(Side(boundary))
      }
    }
  }
  return sides.count
}

private func boundaries(_ section: Set<Point>, _ grid: [[Character]]) -> Set<Boundary> {
  let sectionId = grid[section.first!.row][section.first!.col]
  var boundaries: Set<Boundary> = []
  for point in section {
    if point.row == 0 || grid[point.row - 1][point.col] != sectionId {
      boundaries.insert(Boundary(point: point, direction: .north))
    }
    if point.row == grid.count - 1 || grid[point.row + 1][point.col] != sectionId {
      boundaries.insert(Boundary(point: point, direction: .south))
    }
    if point.col == grid[point.row].count - 1 || grid[point.row][point.col + 1] != sectionId {
      boundaries.insert(Boundary(point: point, direction: .east))
    }
    if point.col == 0 || grid[point.row][point.col - 1] != sectionId {
      boundaries.insert(Boundary(point: point, direction: .west))
    }
  }
  return boundaries
}

private func flood(from start: Point, _ grid: [[Character]]) -> Set<Point> {
  var visited = Set<Point>()
  var toVisit: [Point] = [start]
  while !toVisit.isEmpty {
    let current = toVisit.removeFirst()
    guard !visited.contains(current) else { continue }

    let matching = neighbors(of: current, grid).filter { p in
      grid[p.row][p.col] == grid[start.row][start.col]
    }

    visited.insert(current)
    toVisit.append(contentsOf: matching)
  }
  return visited
}

private func neighbors(of pt: Point, _ grid: [[Character]]) -> Set<Point> {
  var result = Set<Point>()
  result.insert(Point(row: pt.row - 1, col: pt.col))
  result.insert(Point(row: pt.row + 1, col: pt.col))
  result.insert(Point(row: pt.row, col: pt.col - 1))
  result.insert(Point(row: pt.row, col: pt.col + 1))
  return result.filter { p in
    p.row >= 0 && p.col >= 0 && p.row < grid.count && p.col < grid[p.row].count
  }
}

private struct Point: Hashable {
  let row, col: Int
}

private struct Boundary: Hashable {
  let point: Point
  let direction: Direction

  enum Direction {
    case north, east, south, west
  }

  var left: Boundary {
    Boundary(point: Point(row: point.row, col: point.col - 1), direction: direction)
  }
  var right: Boundary {
    Boundary(point: Point(row: point.row, col: point.col + 1), direction: direction)
  }
  var above: Boundary {
    Boundary(point: Point(row: point.row - 1, col: point.col), direction: direction)
  }
  var below: Boundary {
    Boundary(point: Point(row: point.row + 1, col: point.col), direction: direction)
  }
}

private class Side: Equatable {
  static func == (lhs: Side, rhs: Side) -> Bool {
    lhs.boundaries == rhs.boundaries
  }

  // A "side" is a set of colinear boundaries on the same direction
  private(set) var boundaries: Set<Boundary>

  init() {
    boundaries = []
  }

  init(_ boundary: Boundary) {
    boundaries = [boundary]
  }

  func add(_ boundary: Boundary) {
    boundaries.insert(boundary)
  }

  func includes(_ boundary: Boundary) -> Bool { boundaries.contains(boundary) }
}

extension Array where Element == Side {
  fileprivate func horizontalAdjacent(to boundary: Boundary) -> Side? {
    first(where: { $0.includes(boundary.left) || $0.includes(boundary.right) })
  }

  fileprivate func verticalAdjacent(to boundary: Boundary) -> Side? {
    first(where: { $0.includes(boundary.above) || $0.includes(boundary.below) })
  }
}
