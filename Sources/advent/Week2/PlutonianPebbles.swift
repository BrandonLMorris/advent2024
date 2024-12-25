import Foundation

struct Day11: AdventDay {
  var dayIndex = 11
  private let initialStones: [Int]

  init(_ fullInput: String) {
    let lines = fullInput.components(separatedBy: "\n").filter { $0.count > 0 }
    var initialStones = [Int]()
    for stoneStr in lines[0].split(separator: " ") {
      initialStones.append(Int(stoneStr)!)
    }
    self.initialStones = initialStones
  }

  func partOne() {
    var stones = initialStones
    for _ in 0..<25 {
      stones = stones.blink()
    }
    print("Part 1: \(stones.count)")
  }

  func partTwo() {
    let frequencies = fastBlink(stones: initialStones)
    var total = 0
    for (_, count) in frequencies {
      total += count
    }
    print("Part 2: \(total)")
  }
}

private func fastBlink(stones: [Int]) -> [Int: Int] {
  var frequencies = stones.frequencies()
  // Cache splits of even-digit numbers
  var cache = [Int: (Int, Int)]()
  for cnt in 1...75 {
    var newFreqs = [Int: Int]()
    for (num, count) in frequencies {
      // All the zeros change to 1
      if num == 0 {
        newFreqs[1, default: 0] += count
      } else if num.digitCount % 2 == 0 {
        // Split, caching our results
        let (n1, n2) = cache[num] ?? split(num)
        cache[num] = (n1, n2)
        newFreqs[n1, default: 0] += count
        newFreqs[n2, default: 0] += count
      } else {
        // Otherwise mul by 2024
        newFreqs[(num * 2024), default: 0] += count
      }
    }
    frequencies = newFreqs
  }
  return frequencies
}

private func split(_ n: Int) -> (Int, Int) {
  let str = String(n)
  let mid = str.index(str.startIndex, offsetBy: str.count / 2)
  return (Int(str[..<mid])!, Int(str[mid...])!)
}

extension Array where Element == Int {
  fileprivate func blink() -> [Int] {
    var newStones = [Int]()
    newStones.reserveCapacity(count * 2)
    for stone in self {
      if stone == 0 {
        newStones.append(1)
        continue
      }
      let str = String(stone)
      if str.count % 2 == 0 {
        let mid = str.index(str.startIndex, offsetBy: str.count / 2)
        newStones.append(Int(str[..<mid])!)
        newStones.append(Int(str[mid...])!)
      } else {
        newStones.append(stone * 2024)
      }
    }
    return newStones
  }

  fileprivate func frequencies() -> [Int: Int] {
    var counts = [Int: Int]()
    for stone in self {
      counts[stone, default: 0] += 1
    }
    return counts
  }
}

extension Int {
  fileprivate var digitCount: Int {
    Int(log10(Double(self))) + 1
  }
}
