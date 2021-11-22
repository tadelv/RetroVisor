//
//  Elements.swift
//  RetroVisor
//
//  Created by Vid Tadel on 11/21/21.
//

import UIKit

public struct Elements<T: UIView> {
  public typealias ElementsType = [T]
  private let elements: ElementsType

  init(_ elements: ElementsType) {
    self.elements = elements
  }
}

extension Elements: Collection {
  public typealias Element = ElementsType.Element
  public typealias Index = ElementsType.Index

  public var startIndex: ElementsType.Index {
    elements.startIndex
  }

  public var endIndex: ElementsType.Index {
    elements.endIndex
  }

  public subscript(position: ElementsType.Index) -> ElementsType.Element {
    elements[position]
  }

  public func index(after index: ElementsType.Index) -> ElementsType.Index {
    elements.index(after: index)
  }
}

public extension Elements {
  func of<U>(_ type: U.Type) -> Elements<U> {
    Elements<U>(elements.compactMap { $0 as? U })
  }

  func containing(_ text: String) -> Elements {
    matching {
      findText($0) { $0.contains(text) }
    }
  }

  func matching(_ text: String) -> Elements {
    matching {
      findText($0) { $0 == text }
    }
  }

  func matching(_ predicate: (Element) -> Bool) -> Elements {
    let matching = Array(Set(elements + elements.flatMap { $0.elements.of(Element.self) }))
      .filter { predicate($0) }
    let ancestors = matching.filter { element in
      !matching.contains { element != $0 && element.isDescendant(of: $0) }
    }
    return Elements(Array(ancestors))
  }

  func matching<U: UIView>(_ predicate: (U) -> Bool) -> Elements<U> {
    let matching = Set(elements + elements.flatMap { $0.elements })
      .compactMap { element -> U? in
        guard let el = element as? U else {
          return nil
        }
        return predicate(el) ? el : nil
      }
    return Elements<U>(Array(matching))
  }

  subscript(_ text: String) -> Elements {
    matching(text)
  }

  private func findText(_ subject: UIView, comparator: (String) -> Bool) -> Bool {
    if let findable = subject as? TextFindable {
      return comparator(findable.text)
    }
    if let findable = subject as? OptionalTextFindable {
      return findable.text != nil ? comparator(findable.text!) : false
    }
    if let findable = subject as? ImplicitTextFindable {
      return comparator(findable.text)
    }
    let selector = Selector(("text"))
    if subject.responds(to: selector),
       let text = subject.perform(selector)?.takeUnretainedValue() as? String,
       comparator(text) {
      return true
    }
    return false
  }
}
