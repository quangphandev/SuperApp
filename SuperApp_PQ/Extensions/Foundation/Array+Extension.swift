//
//  Array+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import Foundation

// MARK: - Safe Subscript

extension Array {

    /// Returns the element at the given index, or `nil` if out of bounds.
    /// Prevents index-out-of-range crashes.
    ///
    /// Usage: `items[safe: 5]` → nil instead of crash
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Chunking

extension Array {

    /// Splits the array into sub-arrays of the given size.
    /// The last chunk may be smaller if the array doesn't divide evenly.
    ///
    /// Usage: `[1,2,3,4,5].chunked(by: 2)` → `[[1,2],[3,4],[5]]`
    func chunked(by size: Int) -> [[Element]] {
        guard size > 0 else { return [self] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

// MARK: - Unique

extension Array where Element: Hashable {

    /// Returns a new array with duplicate elements removed, preserving original order.
    var unique: [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

extension Array {

    /// Returns a new array with duplicates removed based on the given key path.
    /// Preserves the first occurrence of each unique key.
    func unique<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}

// MARK: - Grouping

extension Array {

    /// Groups elements by a key derived from each element.
    /// Preserves insertion order of keys.
    ///
    /// Usage:
    /// ```swift
    /// let grouped = users.grouped(by: \.department)
    /// // ["Engineering": [...], "Design": [...]]
    /// ```
    func grouped<Key: Hashable>(by keyPath: KeyPath<Element, Key>) -> [Key: [Element]] {
        Dictionary(grouping: self, by: { $0[keyPath: keyPath] })
    }

    /// Groups elements by a key closure, returning an ordered array of (key, elements) pairs.
    func groupedOrdered<Key: Hashable>(by keyOf: (Element) -> Key) -> [(key: Key, elements: [Element])] {
        var keys: [Key] = []
        var dict: [Key: [Element]] = [:]
        for element in self {
            let key = keyOf(element)
            if dict[key] == nil {
                keys.append(key)
                dict[key] = []
            }
            dict[key]?.append(element)
        }
        return keys.map { (key: $0, elements: dict[$0]!) }
    }
}

// MARK: - Convenience

extension Array {

    /// `true` if the array is not empty.
    var isNotEmpty: Bool { !isEmpty }

    /// Returns the second element, or `nil` if the array has fewer than 2 elements.
    var second: Element? { self[safe: 1] }

    /// Returns the last element safely (alias for `.last`, explicit naming for clarity).
    var lastSafe: Element? { last }
}

extension Array where Element: Equatable {

    /// Removes the first occurrence of the given element.
    @discardableResult
    mutating func remove(_ element: Element) -> Bool {
        guard let index = firstIndex(of: element) else { return false }
        remove(at: index)
        return true
    }
}
