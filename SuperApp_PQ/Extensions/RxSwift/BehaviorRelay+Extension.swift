//
//  BehaviorRelay+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import RxCocoa
import RxSwift

// MARK: - Array Relay Mutation

extension BehaviorRelay where Element: RangeReplaceableCollection {

    /// Appends a single element to the relay's collection.
    ///
    /// Usage: `itemsRelay.append(newItem)`
    func append(_ element: Element.Element) {
        var current = value
        current.append(element)
        accept(current)
    }

    /// Appends a sequence of elements to the relay's collection.
    func append<S: Sequence>(contentsOf sequence: S) where S.Element == Element.Element {
        var current = value
        current.append(contentsOf: sequence)
        accept(current)
    }

    /// Removes all elements matching the predicate.
    func removeAll(where predicate: (Element.Element) -> Bool) {
        var current = value
        current.removeAll(where: predicate)
        accept(current)
    }
}

// MARK: - Generic Mutation

extension BehaviorRelay {

    /// Applies a mutation closure to the current value and accepts the result.
    /// Eliminates boilerplate copy-mutate-accept pattern.
    ///
    /// Usage:
    /// ```swift
    /// // Without mutate (verbose):
    /// var items = itemsRelay.value
    /// items.append(newItem)
    /// itemsRelay.accept(items)
    ///
    /// // With mutate (clean):
    /// itemsRelay.mutate { $0.append(newItem) }
    /// ```
    func mutate(_ action: (inout Element) -> Void) {
        var value = self.value
        action(&value)
        accept(value)
    }
}

// MARK: - Array Relay Convenience

extension BehaviorRelay where Element: Collection {

    /// `true` if the relay's collection is empty.
    var isEmpty: Bool { value.isEmpty }

    /// `true` if the relay's collection has elements.
    var isNotEmpty: Bool { !value.isEmpty }

    /// Returns the number of elements.
    var count: Int { value.count }
}

extension BehaviorRelay where Element: Collection, Element.Element: Equatable {

    /// `true` if the relay's collection contains the given element.
    func contains(_ element: Element.Element) -> Bool {
        value.contains(element)
    }
}

// MARK: - Optional Relay

extension BehaviorRelay where Element == Bool {

    /// Toggles the boolean value.
    func toggle() {
        accept(!value)
    }
}
