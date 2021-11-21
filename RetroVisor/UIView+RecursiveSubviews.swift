//
//  UIView+RecursiveSubviews.swift
//  RetroVisor
//
//  Created by Vid Tadel on 11/21/21.
//

import UIKit

public extension UIView {
  var elements: Elements<UIView> {
    Elements(recursiveSubviews)
  }
}

extension UIView {
  var recursiveSubviews: [UIView] {
    subviews.filter { !String(describing: $0.self).starts(with: "_") } +
      subviews.flatMap { $0.recursiveSubviews }
  }
}
