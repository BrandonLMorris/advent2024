import Foundation
import ArgumentParser

struct AdventCommand: ParsableCommand {
  public func run() {
    print("Hello, world")
  }
}

protocol AdventDay {
  init(_ fullInput: String)
  func partOne()
  func partTwo()
}
