struct Day6: AdventDay {
  var dayIndex = 6

  private let obstacles: Set<Point>
  private let maxCorner: Point
  private let watchGuard: Guard

  init(_ fullInput: String) {
    let lines = fullInput.components(separatedBy: .newlines).filter { $0.count > 0 }
    var obstacles = Set<Point>()
    var watchGuard: Guard?
    for row in 0..<lines.count {
      let chars = [Character](lines[row])
      for col in 0..<chars.count {
        if chars[col] == "#" {
          obstacles.insert(Point(x: col, y: row))
        }
        if chars[col] == "^" {
          watchGuard = Guard(position: Point(x: col, y: row), facing: .north)
        }
      }
    }
    self.obstacles = obstacles
    self.watchGuard = watchGuard!
    maxCorner = Point(x: lines[0].count - 1, y: lines.count - 1)
  }

  func partOne() {
    let coveredByShift = guardShift(obstacles, maxPoint: maxCorner)
    print("Part 1: \(coveredByShift.count)")
  }

  func partTwo() {
    // TODO: implement
  }

  private func guardShift(_ obstacles: Set<Point>, maxPoint: Point) -> Set<
    Point
  > {
    var visited: Set<Point> = []
    var guardOnDuty = watchGuard
    while guardOnDuty.position.inBounds(maxPoint: maxPoint) {
      visited.insert(guardOnDuty.position)
      let stepped = guardOnDuty.step()
      guardOnDuty = obstacles.contains(stepped.position) ? guardOnDuty.turn() : stepped
    }
    return visited
  }

}

private enum Direction {
  case north, east, south, west
}

private struct Point: Hashable {
  let x, y: Int

  func next(going direction: Direction) -> Point {
    switch direction {
    case .north: return Point(x: x, y: y - 1)
    case .east: return Point(x: x + 1, y: y)
    case .south: return Point(x: x, y: y + 1)
    case .west: return Point(x: x - 1, y: y)
    }
  }

  func inBounds(maxPoint: Point) -> Bool {
    x >= 0 && y >= 0 && x <= maxPoint.x && y <= maxPoint.y
  }
}

private struct Guard {
  let position: Point
  let facing: Direction

  func turn() -> Guard {
    switch facing {
    case .north: return Guard(position: position, facing: .east)
    case .east: return Guard(position: position, facing: .south)
    case .south: return Guard(position: position, facing: .west)
    case .west: return Guard(position: position, facing: .north)
    }
  }

  func step() -> Guard {
    Guard(position: position.next(going: facing), facing: facing)
  }
}
