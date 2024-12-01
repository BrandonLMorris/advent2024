# Advent of Code 2024

Example implementations of [Advent of Code 2024](https://adventofcode.com/2024)
in **Swift**.

## Installation and usage

1. Clone the repository

    ```sh
    git clone https://github.com/BrandonLMorris/advent2024.git
    ```

1. Provide the input (see the [section below](#providing-input))

1. Run the solution for a day.

    ```sh
    swift run advent <day-int> [--part={one,two,both}]
    ```

For example, to run part 2 of day 3:

    ```sh
    swift run advent 3 --part two
    ```

By default, both parts one and two will be run.

## Providing input

This package uses [bundled
resources](https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package)
to provide the AoC input for each day. To work properly, download the input as a
text file to the `Sources/advent/Resources` directory. The name of the file
should be the numeric day followed by the `.txt` extension. For example, the
full path for the first day's input should be `Sources/advent/Resources/1.txt`.

