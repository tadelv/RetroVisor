# RetroVisor

RetroVisor helps you with inspecting UIViews in your unit tests. You do test views in unit tests, right? Right?

Usually, I mark subview properties of my custom views as `private`, which I think is the right practice, only exposing what is really needed to use a certain view. This makes testing said views a bit more complex, since there is no way to access those private members in the Unit Test target. This is where RetroVisor comes to help. It adds a new property on UIView and subclasses, called `elements`, which contains all the views subviews (recursively, skipping class names starting with `_` or UIKit private classes) and allows for `Collection` like operations on these elements. It also provides matching and filtering helper functions, which help you find the specific view you are looking for more easily.

## Retro What?

RetroVisor works by recursively searching a given UIView's subviews for views that match a certain criteria. Additionally it provides (very crude) functionality for simulating tapping on said views. 

It is trying to mimic the behavior of `XCUIElement` by providing an interface for querying a view for its sub-elements

#### It supports: 

- finding views with text that contains a given string, i.e.:

```swift
// an array of views, which contain the text 'abc'
let viewsThatContainAbc = myViewController.view.elements.containing("abc")
```

- finding views with text that exactly matches a given string, i.e.:

```swift
// an array of views, which display the text 'abc'
let viewsThatMatchAbc = myViewController.view.elements.matching("abc")
```

- finding views that are of specific type:

```swift
// an array of UIButtons that are included in a view
let buttons = myViewController.view.elements.of(UIButton.self)
```

- finding views that match a custom predicate:

```swift
// an array of UILabels which have red text color
let redLabels = myViewController.view.elements.of(UILabel.self).matching { label in
  label.textColor == .red
}

// OR

// specify which types you want to match by specifying the closure parameter type 
let doneButton = myViewController.view.elements.matching { (button: UIButton) in
  button.title(for: .normal) == "Done" && 
    button.isEnabled == true
}
```

- tapping on a button:

```swift
// tap on a Button labeled 'done'
let doneButton = myViewController.view.elements.of(UIButton.self).matching("done").first
doneButton?.tap()
```

Note that tapping is implemented a bit clumsiliy, as sending UIControl Action events is not really supported by iOS without a running UIApplication object.

- tapping on a view (which has a tap gesture recognizer attached):

```swift
// tap on a custom view
let label = myViewController.view.elements.of(UILabel.self)["Tap here for more info"].first
label?.tap()
```

Oh yes, it also supports subscripting on the `elements` property. A subscript means RetroVisor will search for a view with an exact text match, i.e. it is equivalent to calling `view.elements.matching(text)`.

### Using RetroVisor with your own UIView subclasses

The fastest way is to specify the type you are looking for in the matcher predicate

```swift
let customSubview = view.elements.matching { (subview: MyCustomViewClass) in
  true
}.first
```

But RetroVisor also provides Protocols through which it can search for text in the custom UI elements. These protocols are `TextFindable`, `OptionalTextFindable` and `ImplicitTextFindable`. Extend your custom UIView subclass with one of these protocols in your Unit Tests and RetroVisor will be able to search for it via the exposed `text` property.

```swift
extension CustomView: TextFindable {
  public var text: String {
    "I am a custom view"
  }
}

// In your XCTestCase
let customView = view.elements.containing("custom").first // finds the CustomView
```

RetroVisor uses these protocols under the hood for some common UIKit classes. Here is an example on how it extends `UIButton` to make it searchable by text

```swift
extension UIButton: OptionalTextFindable {
  public var text: String? {
    title(for: state)
  }
}
```

## Running

To try out RetroVisor, clone the repo, create the project and install pods

```bash
$git clone ...
$xcodegen
$pod install
$open *.xcworkspace
```

You can also add it to your own project as a development pod. PLEASE only include it in your test target! It contains code that will not pass AppStore review.

```ruby
target "MyApp" do
  target "MyAppTests" do
    pod 'RetroVisor', :path => "PathToWhereYouDownloadedRetroVisor"
  end
end
```

You can also install it through CocoaPods

```ruby
pod 'RetroVisor'
```

## Contributing

Contributions are very welcome, in form of Pull Requests. The project could also do with more unit tests for more specialized cases.

## License

RetroVisor is available under the MIT license.