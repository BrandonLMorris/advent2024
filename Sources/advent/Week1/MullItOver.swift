import Foundation

struct Day3: AdventDay {
  var dayIndex = 3
  let input: String
  private let mulRegex = /mul\((\d{1,3}),(\d{1,3})\)/

  init(_ fullInput: String) {
    input = fullInput
  }

  func partOne() {
    let result = input.matches(of: mulRegex).map { match in
      Int(match.1)! * Int(match.2)!
    }.reduce(0, +)
    print("Final result: \(result)")
  }

  func partTwo() {
    let muls = input.matches(of: mulRegex)
    let enables = input.matches(of: /do\(\)/)
    let disables = input.matches(of: /don\'t\(\)/)
    var resultCounter = 0
    for match in muls {
      let mulIdx = match.range.lowerBound
      let previousEnable = lastMatch(in: enables, before: mulIdx)
      let previousDisable = lastMatch(in: disables, before: mulIdx)
      guard let disable = previousDisable else {
        // System has yet to leave the "enabled" state
        resultCounter += Int(match.1)! * Int(match.2)!
        continue
      }
      guard let enable = previousEnable else {
        // System was disabled and has yet to be re-enabled
        continue
      }
      if enable.range.lowerBound > disable.range.lowerBound {
        // The system has been enabled more recently than it's been disabled
        resultCounter += Int(match.1)! * Int(match.2)!
      }
    }
    print("Final result: \(resultCounter)")
  }

  func lastMatch(in matches: [Regex<Substring>.Match], before upperLimit: String.Index) -> Regex<
    Substring
  >.Match? {
    var matchBeforeLimit: Regex<Substring>.Match? = nil
    for match in matches {
      if match.range.lowerBound > upperLimit {
        // If we've past the boundary, return the prev match (even if nil)
        return matchBeforeLimit
      }
      matchBeforeLimit = match
    }
    // There aren't any matches past the upperLimit
    return matchBeforeLimit
  }
}
