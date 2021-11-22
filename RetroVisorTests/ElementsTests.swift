//
//  ElementsTests.swift
//  RetroVisorTests
//
//  Created by Vid Tadel on 11/21/21.
//

import RetroVisor
import XCTest

class ElementsTests: XCTestCase {
  private func makeLabel(_ text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    return label
  }

  private func makeButton(_ text: String) -> UIButton {
    let button = UIButton()
    button.setTitle(text, for: .normal)
    button.layoutSubviews()
    return button
  }

  private func makeTextField(_ text: String) -> UITextField {
    let field = UITextField()
    field.text = text
    return field
  }

  private func makeCell(_ text: String) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = text
    return cell
  }

  private func makeTextView(_ text: String) -> UITextView {
    let view = UITextView()
    view.text = text
    return view
  }

  func testFindsLabelWithContaining() {
    let view = UIView()
    let label = makeLabel("lorem ipsum")
    [
      makeLabel("abc"),
      label
    ].forEach { view.addSubview($0) }

    let results = view.elements.containing("ips")
    XCTAssertEqual(results.count, 1)
    XCTAssertEqual(results.first, label)
  }

  func testFindsAllElementsWithContaining() {
    let view = UIView()
    [
      makeLabel("abc"),
      makeLabel("lorem"),
      makeButton("abc"),
      makeButton("lorem"),
      makeTextField("abc"),
      makeTextField("lorem"),
      makeCell("abc"),
      makeCell("lorem"),
      makeTextView("abc"),
      makeTextView("lorem")
    ].forEach { view.addSubview($0) }

    XCTAssertEqual(view.elements.containing("lor").count, 5)
  }

  func testFindElementsOfType() {
    let view = UIView()
    [
      makeLabel("abc"),
      makeLabel("lorem"),
      makeButton("abc"),
      makeButton("lorem"),
      makeTextField("abc"),
      makeTextField("lorem"),
      makeCell("abc"),
      makeCell("lorem"),
      makeTextView("abc"),
      makeTextView("lorem")
    ].forEach { view.addSubview($0) }

    XCTAssertEqual(view.elements.of(UIButton.self).count, 2)
  }

  func testContainsSubclass() {
    class Button: UIButton {
      init() {
        super.init(frame: .zero)
        setTitle("abc", for: .normal)
        layoutSubviews()
      }

      @available(*, unavailable)
      required init?(coder: NSCoder) {
        fatalError("not implemented")
      }
    }

    let view = UIView()
    view.addSubview(Button())

    XCTAssertEqual(view.elements.containing("abc").count, 1)
  }

  func testContainsCustomType() {
    class Dummy: UIView, TextFindable {
      var text: String {
        "abc"
      }
    }

    let view = UIView()
    view.addSubview(Dummy())
    view.addSubview(makeLabel("test"))

    XCTAssertEqual(view.elements.containing("abc").count, 1)
  }

  func testContainsClassWithObjCVar() {
    class Dummy: UIView {
      @objc var text: String {
        "abc"
      }
    }

    let view = UIView()
    view.addSubview(Dummy())
    view.addSubview(makeLabel("test"))

    XCTAssertEqual(view.elements.containing("abc").count, 1)
  }

  func testMatchesExactly() {
    let view = UIView()

    let ipsView = makeTextView("ips")
    [
      makeLabel("abc"),
      makeCell("lorem ipsum"),
      makeButton("ipsos"),
      ipsView,
      makeTextView("ipspossible")
    ].forEach { view.addSubview($0) }

    let matches = view.elements.matching("ips")
    XCTAssertEqual(matches.count, 1)
    XCTAssertEqual(matches.first, ipsView)
  }

  func testMatchingPredicate() {
    let view = UIView()

    let label = makeLabel("abc")
    label.textColor = .blue

    [
      makeLabel("abc"),
      makeCell("abc"),
      makeButton(""),
      label
    ].forEach { view.addSubview($0) }

    let results = view.elements.of(UILabel.self).matching { label in
      label.textColor == .blue
    }
    XCTAssertEqual(results.first, label)
  }

  func testMatchingSubscript() {
    let view = UIView()

    let ipsView = makeTextView("ips")
    [
      makeLabel("abc"),
      makeCell("lorem ipsum"),
      makeButton("ipsos"),
      ipsView,
      makeTextView("ipspossible")
    ].forEach { view.addSubview($0) }

    let matches = view.elements["ips"]
    XCTAssertEqual(matches.count, 1)
    XCTAssertEqual(matches.first, ipsView)
  }

  func testFindsNestedView() {
    let parentView = UIView()
    let innerView = UIView()
    let button = makeButton("test")

    innerView.addSubview(button)
    parentView.addSubview(innerView)

    let results = parentView.elements.matching("test")
    XCTAssertEqual(results.first, button)

    let res2 = parentView.elements.matching { (button: UIButton) in
      button.title(for: .normal) == "test"
    }
    XCTAssertEqual(res2.first, button)
  }
}
