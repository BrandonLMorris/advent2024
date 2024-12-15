struct Day9: AdventDay {
  var dayIndex = 9
  let diskMap: [Int]

  init(_ fullInput: String) {
    diskMap = fullInput.compactMap { Int("\($0)") }
  }

  func partOne() {
    let decompressed = decompress(diskMap)
    let defragged = defrag(decompressed)
    var checksum = 0
    for idx in 0..<defragged.count {
      if defragged[idx] == -1 { break }
      checksum += idx * defragged[idx]
    }
    print("Part 1: \(checksum)")
  }

  func partTwo() {
    // TODO: Implement part two solution
  }
}

private func decompress(_ diskMap: [Int]) -> [Int] {
  var fragged = [Int]()
  var fileId = 0
  var idFileBlock = true
  for len in diskMap {
    for _ in 0..<len {
      fragged.append(idFileBlock ? fileId : -1)
    }
    fileId += idFileBlock ? 1 : 0
    idFileBlock = !idFileBlock
  }
  return fragged
}

private func defrag(_ disk: [Int]) -> [Int] {
  var defragged = disk
  var left = 0
  var right = disk.count - 1
  while left < right {
    while defragged[left] != -1 { left += 1 }
    while defragged[right] == -1 { right -= 1 }
    if left < right {
      defragged[left] = defragged[right]
      defragged[right] = -1
      left += 1
      right -= 1
    }
  }
  return defragged
}
