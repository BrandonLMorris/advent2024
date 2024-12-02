struct Day2: AdventDay {
  var dayIndex = 2
  private let reports: [Report]

  init(_ fullInput: String) {
    let lines = fullInput.components(separatedBy: "\n").filter { $0.count > 0 }
    reports = lines.map(Report.init)
  }

  func partOne() {
    print("Part 1: \(reports.filter { $0.safe() }.count) reports")
  }

  func partTwo() {
    print("Part 2: \(reports.filter { $0.safeExcludingOne() }.count) reports")
  }
}

private struct Report {
  let levels: [Int]

  init(_ inputLine: String) {
    levels = inputLine.components(separatedBy: .whitespaces).map { Int($0)! }
  }

  init(_ levels: [Int]) {
    self.levels = levels
  }

  /// Determine if a level is "safe."
  ///
  /// Safe is defined as:
  ///   1. The levels are all increasing or all decreasing
  ///   2. Two adjacent levels differ by at least 1 and at most 3.
  func safe() -> Bool {
    let diffs = levels.diffs()
    return diffsSafe(diffs)
  }

  func safeExcludingOne() -> Bool {
    let originalDiffs = levels.diffs()
    return diffsSafe(originalDiffs) || subreports().contains(where: { $0.safe() })
  }

  private func diffsSafe(_ diffs: [Int]) -> Bool {
    let increasing = diffs.allSatisfy { $0 < 0 }
    let decreasing = diffs.allSatisfy { $0 > 0 }
    let adjacentCriteria = diffs.allSatisfy { abs($0) >= 1 && abs($0) <= 3 }
    return (increasing || decreasing) && adjacentCriteria
  }

  /// Construct all the reports that can be made by excluding a single reading
  /// from this report.
  private func subreports() -> [Report] {
    (0..<levels.count).map { idxToExclude in
      let newLevels = (0..<levels.count - 1).map { i in
        i < idxToExclude ? levels[i] : levels[i + 1]
      }
      return Report(newLevels)
    }
  }
}

extension Array where Element == Int {
  func diffs() -> [Int] {
    (0..<self.count - 1).map { self[$0] - self[$0 + 1] }
  }
}
