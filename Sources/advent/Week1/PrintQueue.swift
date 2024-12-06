struct Day5: AdventDay {
  var dayIndex = 5
  private let updates: [Update]
  private let ruleSet: RuleSet

  init(_ fullInput: String) {
    let lines = fullInput.components(separatedBy: .newlines).filter { $0.count > 0 }
    updates = lines.filter { $0.contains(",") }.map(Update.init)
    let rules = lines.filter { $0.contains("|") }.map(Rule.init)
    ruleSet = RuleSet(rules)
  }

  func partOne() {
    var resultCounter = 0
    for update in updates {
      var validUpdate = true
      for idx in 1..<update.pages.count {
        let curPage = update.pages[idx]
        for preceedingIdx in 0..<idx {
          if ruleSet.rules[curPage, default: []].contains(update.pages[preceedingIdx]) {
            validUpdate = false
          }
        }
      }
      if validUpdate {
        resultCounter += update.middle
      }
    }
    print("Part 1: \(resultCounter)")
  }

  func partTwo() {
    // TODO:
  }
}

private struct Rule {
  // According to this rule, the antecedent page number must come before the
  // subsequent page number in the update.
  let antecedent, subsequent: Int

  init(_ str: String) {
    let split = str.components(separatedBy: "|")
    antecedent = Int(split[0])!
    subsequent = Int(split[1])!
  }
}

private struct RuleSet {
  // Map each page to the pages that must appear after it
  let rules: [Int: Set<Int>]

  init(_ rules: [Rule]) {
    var res: [Int: Set<Int>] = [:]
    rules.forEach { (rule: Rule) in
      res[rule.antecedent, default: []].insert(rule.subsequent)
    }
    self.rules = res
  }
}

private struct Update {
  let pages: [Int]

  init(_ str: String) {
    pages = str.components(separatedBy: ",").map { Int($0)! }
  }

  var middle: Int {
    // Assuming we have an odd number of pages
    pages[pages.count / 2]
  }
}
