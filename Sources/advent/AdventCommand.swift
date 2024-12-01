import ArgumentParser
import Foundation

struct AdventCommand: ParsableCommand {
  @Argument
  private var day: Int

  private enum Part: String, CaseIterable, ExpressibleByArgument {
    case one, two, both
  }
  @Option
  private var part: Part = .both

  public func run() throws {
    print("Running solution for day \(day), part(s) \(part.rawValue)...")
    let input = try loadInput(forDay: day)
    let solver = DayProvider.forIndex(day, withInput: input)

    if part != .two {
      // Either part 1 or both specified
      solver.partOne()
    }
    if part != .one {
      // Either part 2 or both specified
      solver.partTwo()
    }
  }
}

protocol AdventDay {
  var dayIndex: Int { get }

  init(_ fullInput: String)

  func partOne()
  func partTwo()
}

private func loadInput(forDay dayIndex: Int) throws -> String {
  let url = Bundle.module.url(forResource: "\(dayIndex)", withExtension: "txt")!
  return try String(contentsOf: url, encoding: .utf8)
}

private struct DayProvider {
  static func forIndex(_ index: Int, withInput input: String) -> AdventDay {
    [
      nil,
      Day1.self,
    ][index]!.init(input)
  }
}