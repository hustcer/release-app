#!/usr/bin/env nu
# Author: hustcer
# Created: 2025/10/22 15:20:00
# Description: Common utilities for Nu
# Ref:
#   1. https://www.nushell.sh/book/
#   2. https://github.com/casey/just

# Get the prefix of the given list of strings, strings may or may not contains the same prefix
# Example:
#   get-prefix ['a.b.c', 'a.b.d', 'a.b.e']  => 'a.b.'
#   get-prefix ['abc', 'abd', 'abe']  => 'ab'
#   get-prefix ['a', 'b', 'c']  => ''
export def get-prefix [from: list<string>] {
  if ($from | is-empty) { return '' }
  if ($from | length) == 1 { return ($from | first) }

  # Find the shortest string to avoid out-of-bounds
  let min_len = ($from | each {|s| $s | str length} | math min)
  if $min_len == 0 { return '' }

  # Use first string as reference
  let first = ($from | first)
  let rest = ($from | skip 1)

  # Find the maximum prefix length by checking each character position
  mut prefix_len = 0

  for i in 0..<$min_len {
    let prefix_candidate = ($first | str substring 0..($i + 1))
    # Check if all other strings start with this prefix
    let all_match = ($rest | all {|s| $s | str starts-with $prefix_candidate})
    if $all_match { $prefix_len = $i + 1 } else { break }
  }

  if $prefix_len == 0 { '' } else { $first | str substring 0..$prefix_len }
}
