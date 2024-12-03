struct Day3: AdventDay {
  var dayIndex = 3
  let input: String

  init(_ fullInput: String) {
    input = fullInput
  }

  func partOne() {
    let mulRegex = /mul\((\d{1,3}),(\d{1,3})\)/
    let result = input.matches(of: mulRegex).map { match in
      Int(match.1)! * Int(match.2)!
    }.reduce(0, +)
    print("Final result: \(result)")
  }

  func partTwo() {
    // TODO:
  }
}
