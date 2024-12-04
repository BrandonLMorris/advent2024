struct Day4: AdventDay {
  var dayIndex = 4
  let wordsearch: [[Character]]

  init(_ fullInput: String) {
    wordsearch = fullInput.components(separatedBy: .newlines).filter { $0.count > 0 }.map {
      Array($0)
    }
  }

  func partOne() {
    var foundCount = 0
    for row in 0..<wordsearch.count {
      for col in 0..<wordsearch[row].count {
        foundCount += wordsearch.search(for: "XMAS", from: (row, col))
      }
    }
    print("Part 1: \(foundCount)")
  }

  func partTwo() {
    // TODO: implement part 2
  }
}

extension Array where Element == [Character] {
  /// For a given word (e.g. XMAS), return the number of ocurracnes in any
  /// direction from the given starting point.
  func search(for word: String, from origin: (row: Int, col: Int)) -> Int {
    var found = 0
    let maxOffset = word.count - 1
    let rowBoundary = self.count
    let colBoundary = self[0].count
    let chars = [Character](word)

    // Left to right
    if origin.col + maxOffset < colBoundary {
      var match = true
      for offset in 0...maxOffset {
        if chars[offset] != self[origin.row][origin.col + offset] {
          match = false
          break
        }
      }
      found += match ? 1 : 0
    }

    // Backwards (right to left)
    if origin.col - maxOffset >= 0 {
      var match = true
      for offset in 0...maxOffset {
        if chars[offset] != self[origin.row][origin.col - offset] {
          match = false
          break
        }
      }
      found += match ? 1 : 0
    }

    // Down
    if origin.row + maxOffset < rowBoundary {
      var match = true
      for offset in 0...maxOffset {
        if chars[offset] != self[origin.row + offset][origin.col] {
          match = false
          break
        }
      }
      found += match ? 1 : 0
    }

    // Up
    if origin.row - maxOffset >= 0 {
      var match = true
      for offset in 0...maxOffset {
        if chars[offset] != self[origin.row - offset][origin.col] {
          match = false
          break
        }
      }
      found += match ? 1 : 0
    }

    // Diag: NE (right and up)
    if (origin.col + maxOffset < colBoundary) && (origin.row - maxOffset >= 0) {
      var match = true
      for offset in 0...maxOffset {
        if chars[offset] != self[origin.row - offset][origin.col + offset] {
          match = false
          break
        }
      }
      found += match ? 1 : 0
    }

    // Diag: SE (right and down)
    if (origin.col + maxOffset < colBoundary) && (origin.row + maxOffset < rowBoundary) {
      var match = true
      for offset in 0...maxOffset {
        if chars[offset] != self[origin.row + offset][origin.col + offset] {
          match = false
          break
        }
      }
      found += match ? 1 : 0
    }

    // Diag: SW (left and down)
    if (origin.col - maxOffset >= 0) && (origin.row + maxOffset < rowBoundary) {
      var match = true
      for offset in 0...maxOffset {
        if chars[offset] != self[origin.row + offset][origin.col - offset] {
          match = false
          break
        }
      }
      found += match ? 1 : 0
    }

    // Diag: NW (left and up)
    if (origin.col - maxOffset >= 0) && (origin.row - maxOffset >= 0) {
      var match = true
      for offset in 0...maxOffset {
        if chars[offset] != self[origin.row - offset][origin.col - offset] {
          match = false
          break
        }
      }
      found += match ? 1 : 0
    }

    return found
  }
}
