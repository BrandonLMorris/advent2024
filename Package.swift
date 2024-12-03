// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "advent",
  platforms: [
    .macOS(.v13)
  ],
  products: [
    .executable(
      name: "advent",
      targets: ["advent"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0")
  ],
  targets: [
    .executableTarget(
      name: "advent",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ],
      resources: [.copy("Resources")]
    ),
    .testTarget(
      name: "adventTests",
      dependencies: ["advent"]
    ),
  ]
)
