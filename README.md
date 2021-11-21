# RetroVisor

RetroVisor helps you with inspecting UIViews in your unit tests. You do test views in unit tests, right? Right?

## Retro What?

RetroVisor works by recursively searching a given UIView's subviews for views that match a certain criteria. Additionally it provides (very crude) functionality for simulating tapping on said views. 

It is trying to mimic the behavior of `XCUIElement` by providing an interface for querying a view for its sub-elements

####It supports: 

- finding views with text that contains a given string, i.e.:

```swift
// an array of views, which contain the text 'abc'
let viewsThatContainAbc = myViewController.view.elements.containing("abc")
```

- finding views with text that exactly matches a given string, i.e.:

```swift
// an array of views, which display the text 'abc'
let viewsThatContainAbc = myViewController.view.elements.matching("abc")
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
let label = myViewController.view.elements["Tap here for more info"].first
label?.tap()
```

Oh yes, it also supports subscripting on the `elements` property. A subscript means RetroVisor will search for a view with an exact text match, i.e. it is equivalent to calling `view.elements.matching(text)`.


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

## License

RetroVisor is available under the MIT license.