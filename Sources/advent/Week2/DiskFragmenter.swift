struct Day9: AdventDay {
  var dayIndex = 9
  let diskMap: [Int]

  init(_ fullInput: String) {
    diskMap = fullInput.compactMap { Int("\($0)") }
  }

  func partOne() {
    let decompressed = decompress(diskMap)
    let fragged = frag(decompressed)
    var checksum = 0
    for idx in 0..<fragged.count {
      if fragged[idx] == -1 { break }
      checksum += idx * fragged[idx]
    }
    print("Part 1: \(checksum)")
  }

  func partTwo() {
    let files = decompressFiles(diskMap)
    let compacted = compact(files)
    print("Part 2: \(compacted.checksum)")
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

private func decompressFiles(_ diskMap: [Int]) -> [DiskFile] {
  var files = [DiskFile]()
  var pos = 0
  var fileId = 0
  var idFileBlock = true
  for len in diskMap {
    if idFileBlock {
      files.append(DiskFile(startPos: pos, length: len, fileId: fileId))
      fileId += 1
    } else {
      files.append(DiskFile(startPos: pos, length: len, fileId: -1))
    }
    idFileBlock = !idFileBlock
    pos += len
  }
  return files
}

private func frag(_ disk: [Int]) -> [Int] {
  var fragged = disk
  var left = 0
  var right = disk.count - 1
  while left < right {
    while fragged[left] != -1 { left += 1 }
    while fragged[right] == -1 { right -= 1 }
    if left < right {
      fragged[left] = fragged[right]
      fragged[right] = -1
      left += 1
      right -= 1
    }
  }
  return fragged
}

private func compact(_ files: [DiskFile]) -> [DiskFile] {
  var compacted = files
  // "Attempt to move each file exactly once..."
  for toRelocate in files.filter({ $0.fileId != -1 }).reversed() {
    var idx = 0
    while idx < compacted.count
      // We don't want to overwrite non-empty files
      && (compacted[idx].fileId != -1
        // Can't write into a space not big enough
        || compacted[idx].length < toRelocate.length)
    {
      idx += 1
    }
    if idx >= compacted.count || compacted[idx].startPos > toRelocate.startPos {
      // No space or we'd be moving to the right
      continue
    }
    let (newFile, trailer) = compacted[idx].overwrite(withFile: toRelocate)
    compacted[idx] = newFile
    if let trailer = trailer {
      compacted.insert(trailer, at: idx + 1)
    }
    // Clear original file to prevent messing up our checksum
    compacted = compacted.clearLast(fileWithId: toRelocate.fileId)
  }
  return compacted
}

private struct DiskFile {
  let startPos, length, fileId: Int
}

extension DiskFile {
  fileprivate func overwrite(withFile file: DiskFile) -> (DiskFile, DiskFile?) {
    guard length >= file.length else {
      // Can't overwrite a larger file
      return (self, nil)
    }
    let newFile = DiskFile(startPos: startPos, length: file.length, fileId: file.fileId)
    if length == file.length {
      // Easy replacement; no need to account for trailing space
      return (newFile, nil)
    }
    let trailer = DiskFile(
      startPos: startPos + file.length, length: length - file.length, fileId: fileId)
    return (newFile, trailer)
  }
}

extension Array where Element == DiskFile {
  func clearLast(fileWithId idToClear: Int) -> [DiskFile] {
    var cleared = self
    for (idx, file) in self.enumerated().reversed() {
      if file.fileId == idToClear {
        cleared[idx] = DiskFile(startPos: file.startPos, length: file.length, fileId: -1)
        break
      }
    }
    return cleared
  }

  var checksum: Int {
    var count = 0
    for file in self {
      // Skip empty spaces
      if file.fileId == -1 { continue }
      for offset in 0..<file.length {
        count += (file.startPos + offset) * file.fileId
      }
    }
    return count
  }
}
