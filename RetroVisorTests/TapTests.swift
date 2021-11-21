//
//  TapTests.swift
//  RetroVisorTests
//
//  Created by Vid Tadel on 11/21/21.
//

import RetroVisor
import XCTest

class TapTests: XCTestCase {
  func testTapsButton() {
    class Test: NSObject {
      var exp: XCTestExpectation?

      @objc
      func trigger() {
        exp?.fulfill()
      }
    }

    let exp = expectation(description: "action called")
    let dummy = Test()
    dummy.exp = exp

    let button = UIButton()
    button.layoutSubviews()
    button.addTarget(dummy, action: #selector(Test.trigger), for: .touchUpInside)

    button.tap()

    waitForExpectations(timeout: 0.1)
  }

  @available(iOS 14, *)
  func testTapButtonTriggersUIAction() {
    let exp = expectation(description: "action executed")
    let button = UIButton()
    button.addAction(.init(handler: { _ in
      exp.fulfill()
    }), for: .touchUpInside)

    button.tap()

    waitForExpectations(timeout: 0.1)
  }

  func testTapGestureRecognizer() {
    class Dummy: UIView {
      var exp: XCTestExpectation?

      @objc
      func gesture() {
        exp?.fulfill()
      }
    }

    let exp = expectation(description: "recognizer triggered")
    let view = Dummy()
    view.exp = exp
    let recognizer = UITapGestureRecognizer(target: view, action: #selector(Dummy.gesture))
    view.addGestureRecognizer(recognizer)

    view.tap()

    waitForExpectations(timeout: 0.1)
  }
}
