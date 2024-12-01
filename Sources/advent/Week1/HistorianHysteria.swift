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
    let (firstList, secondList) = readLists()
    let counts = countOccurrances(from: secondList)
    var result = 0
    for num in firstList {
      result += counts[num, default: 0] * num
    }
    print("Part two: \(result)")
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

  // Transform the input into a dictionary of occurrance counts.
  private func countOccurrances(from lst: [Int]) -> [Int: Int] {
    var counts: [Int: Int] = [:]
    for num in lst {
      let newCount = counts[num, default: 0] + 1
      counts[num] = newCount
    }
    return counts
  }
}
