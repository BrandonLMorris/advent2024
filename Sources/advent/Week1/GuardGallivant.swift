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
    var coveredByShift = Set<Point>()
    guardShift(watchGuard, obstacles) {
      coveredByShift.insert($0.position)
      return true
    }
    print("Part 1: \(coveredByShift.count)")
  }

  func partTwo() {
    var potentialObstacles = Set<Point>()
    var guards = Set<Guard>()
    guardShift(watchGuard, obstacles) { currentGuard in
      guards.insert(currentGuard)
      let newObstaclePos = currentGuard.step().position
      // We can't add an obstacle off the map or on top of another
      if !newObstaclePos.inBounds(maxPoint: maxCorner) || obstacles.contains(newObstaclePos) {
        return true  // Continue with this shift
      }

      // Simulate a shift with the new obstacle and see if it causes a cycle
      var simulatedGuards = Set<Guard>()
      let simObstacles = obstacles.union([newObstaclePos])
      guardShift(watchGuard, simObstacles) { simGuard in
        if simulatedGuards.contains(simGuard) {
          // Cycle detected!
          potentialObstacles.insert(newObstaclePos)
          return false
        }
        simulatedGuards.insert(simGuard)
        return true  // Continue with the simulated shift
      }
      return true  // Continue with this shift (outer loop)
    }
    print("Part 2: \(potentialObstacles.count)")
  }

  private func guardShift(
    _ startGuard: Guard, _ obstacles: Set<Point>, atEachPoint: (Guard) -> Bool
  ) {
    var guardOnDuty = startGuard
    while guardOnDuty.position.inBounds(maxPoint: maxCorner) {
      if !atEachPoint(guardOnDuty) { break }
      let stepped = guardOnDuty.step()
      guardOnDuty = obstacles.contains(stepped.position) ? guardOnDuty.turn() : stepped
    }
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

private struct Guard: Hashable {
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
