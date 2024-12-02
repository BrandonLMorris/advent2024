
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
    // TODO:
  }
}

private struct Report {
  let levels: [Int]

  init(_ inputLine: String) {
    levels = inputLine.components(separatedBy: .whitespaces).map { Int($0)! }
  }

  /// Determine if a level is "safe."
  ///
  /// Safe is defined as:
  ///   1. The levels are all increasing or all decreasing
  ///   2. Two adjacent levels differ by at least 1 and at most 3.
  func safe() -> Bool {
    var increasing = true, decreasing = true
    for idx in 0..<(levels.count - 1) {
      let diff = levels[idx] - levels[idx + 1]

      // If any diff is bad, the whole report is unsafe
      if abs(diff) < 1 || abs(diff) > 3 {
        return false
      }

      // Now check directionality
      if diff < 0 {
        increasing = false
      } else if diff > 0 {
        decreasing = false
      }
    }
    return increasing || decreasing
  }
}
