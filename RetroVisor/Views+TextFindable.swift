//
//  Views+TextFindable.swift
//  RetroVisor
//
//  Created by Vid Tadel on 22/11/2021.
//

import UIKit

/// Allow RetroVisor to find a custom UIView subtype by text by implementing this protocol
public protocol TextFindable {
  var text: String { get }
}

/// Implement this protocol if a custom type has an optional text: String property
public protocol OptionalTextFindable {
  var text: String? { get }
}

/// Implement this protocol if a custom type has an implicitly unwrapped optional text: String property
public protocol ImplicitTextFindable {
  var text: String! { get }
}

extension UIButton: OptionalTextFindable {
  public var text: String? {
    title(for: state)
  }
}

extension UITextView: ImplicitTextFindable {}
extension UITextField: OptionalTextFindable {}
extension UILabel: OptionalTextFindable {}
