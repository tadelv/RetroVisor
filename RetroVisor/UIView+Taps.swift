//
//  UIView+Taps.swift
//  RetroVisor
//
//  Created by Vid Tadel on 11/21/21.
//

import UIKit

public extension UIView {
  func tap() {
    runTap()
  }
}

extension UIControl {
  override func runTap() {
    // sending actions to classic target/action targets does not work in unit tests,
    // so we have to call the actions manually
    for target in allTargets {
      guard let actionsStrings = actions(forTarget: target, forControlEvent: .touchUpInside) else {
        break
      }
      for actionString in actionsStrings {
        let selector = NSSelectorFromString(actionString)
        (target as NSObject).performSelector(onMainThread: selector, with: self, waitUntilDone: true)
      }
    }
    // also send event to all registered UIActions
    sendActions(for: .touchUpInside)
  }
}

extension UIView {
  @objc
  func runTap() {
    let maybeRecognizers = gestureRecognizers?.compactMap { $0 as? UITapGestureRecognizer }
    guard let recognizers = maybeRecognizers else {
      return
    }

    // swiftlint:disable line_length
    // thanks to https://github.com/manGoweb/SpecTools/blob/master/SpecTools/Classes/Action/Action%2BUIGestureRecognizer.swift#L72
    recognizers.forEach { recognizer in
      guard let targets = recognizer.value(forKeyPath: "_targets") as? [NSObject] else {
        return
      }
      for target in targets {
        let selectorString = String(describing: target)
          .components(separatedBy: ", ")
          .first!
          .replacingOccurrences(of: "(action=", with: "")
        let selector = NSSelectorFromString(selectorString)

        let targetActionPairClass: AnyClass = NSClassFromString("UIGestureRecognizerTarget")!
        let targetIvar: Ivar = class_getInstanceVariable(targetActionPairClass, "_target")!
        let targetObject: AnyObject = object_getIvar(target, targetIvar) as AnyObject

        targetObject.performSelector(onMainThread: selector, with: recognizer, waitUntilDone: true)
      }
    }
  }
}
