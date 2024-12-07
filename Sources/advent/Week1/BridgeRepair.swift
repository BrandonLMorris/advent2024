struct Day7: AdventDay {
  var dayIndex = 7
  private let equations: [CalibrationEquation]

  init(_ fullInput: String) {
    var equations = [CalibrationEquation]()
    let lines = fullInput.components(separatedBy: "\n").filter { $0.count > 0 }
    for line in lines {
      let split = line.components(separatedBy: ": ")
      let (testValue, operandsStr) = (split[0], split[1])
      let operands = operandsStr.components(separatedBy: .whitespaces)
      let eq = CalibrationEquation(testValue: Int(testValue)!, operands: operands.map { Int($0)! })
      equations.append(eq)
    }
    self.equations = equations
  }

  func partOne() {
    let result = equations.filter { $0.valid() }.map { $0.testValue }.reduce(0, +)
    print("Part 1: \(result)")
  }

  func partTwo() {
    // TODO: implement
  }
}

struct CalibrationEquation {
  let testValue: Int
  let operands: [Int]

  func valid() -> Bool {
    let operatorPositions = operands.count - 1
    for bitPattern in 0..<(1 << operatorPositions) {
      var eqResult = operands[0]
      for idx in 0..<operatorPositions {
        let operand = operands[idx + 1]
        let plusOperator = (bitPattern >> idx) & 1 > 0
        eqResult = plusOperator ? eqResult + operand : eqResult * operand
      }
      if eqResult == testValue {
        return true
      }
    }
    return false
  }
}
