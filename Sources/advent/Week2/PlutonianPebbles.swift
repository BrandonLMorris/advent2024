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
    // TODO: Implement part 2 solution
  }
}

private extension Array where Element == Int {
  func blink() -> [Int] {
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
}
