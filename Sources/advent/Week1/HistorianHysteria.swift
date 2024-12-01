import Foundation

/// Advent of Code 2024 Day 1: Historian Hysteria
struct Day1: AdventDay {
  let dayIndex = 1
  let input: String

  init(_ fullInput: String) {
    input = fullInput
  }

  func partOne() {
    let (firstList, secondList) = readLists()
    var counter = 0
    for (a, b) in zip(firstList.sorted(), secondList.sorted()) {
      counter += abs(b - a)
    }
    print("Part one: \(counter)")
  }

  func partTwo() {
    // TODO: Complete after part one
  }

  // Transform the input into two (unordered) lists.
  private func readLists() -> ([Int], [Int]) {
    let lines = input.components(separatedBy: "\n").filter { $0.count > 0 }
    var result = ([Int](), [Int]())
    for line in lines {
      let numbers = line.components(separatedBy: .whitespaces)
      result.0.append(Int(numbers.first!)!)
      result.1.append(Int(numbers.last!)!)
    }
    return result
  }
}
