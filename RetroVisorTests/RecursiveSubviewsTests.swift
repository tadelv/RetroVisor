//
//  RecursiveSubviewsTests.swift
//  RetroVisorTests
//
//  Created by Vid Tadel on 11/21/21.
//

@testable import RetroVisor
import XCTest

class RecursiveSubviewsTests: XCTestCase {
  func testFindsAllSubviews() {
    let mainView = UIView()
    let innerView = UIView()

    [
      innerView,
      UILabel(),
      UILabel()
    ].forEach { mainView.addSubview($0) }

    [
      UILabel(),
      UILabel()
    ].forEach { innerView.addSubview($0) }

    XCTAssertEqual(mainView.recursiveSubviews.count, 5)
  }
}
