# Frappé

A slightly [Bacon.js](http://baconjs.github.io/) inspired Dart package that aims  to make functional reactive programming easier in Dart. Frappé extends the behavior of Dart's streams, and introduces new concepts like properties.

## EventStream
An `EventStream` is just like a `Stream` in Dart. It inherits the same interface as a `Stream`, but extends its functionality. This makes it easy to compose both Frappé streams and Dart streams.

For instance, by wrapping `window.onMouseMove` in an `EventStream`, we can combine multiple mouse events to perform a mouse drag operation in just a few lines of code:

```dart
window.onMouseDown.forEach((mouseDown) {
  var pen = new Pen(mouseDown.client);
  new EventStream(window.onMouseMove).takeUntil(window.onMouseUp.first)
      .forEach((mouseMove) => pen.drawTo(mouseMove.client))
      .then((_) => pen.done())
})
```

Or, merging multiple streams together that will signal the close of your application:

```dart
var onQuit = new EventStream(quitButton.onClick)
    .merge(fileMenu.querySelector("quit").onClick)
    .merge(fatalErrors);
    
onQuit.listen((_) => closeApp());
```

## Properties
Properties are similar to streams, but they remember their last value. This means that if a property has previously emitted the value of *x* to its subscribers, it will deliver this value to any of its new subscribers.

For instance, a property could be used to unify synchronous and asynchronous calls to get the window's current size:

```dart
Size innerSize() => new Size(window.innerWidth, window.innerHeight);

var windowSize = new Property.fromStreamWithInitialValue(innerSize(),
    window.onResize.map((_) => innerSize()));

print(innerSize()); // hypothetical window size {"width": 1024, "height": 768}
windowSize.listen((size) => print(size)); // {"width": 1024, "height": 768}
windowSize.listen((size) => print(size)); // {"width": 1024, "height": 768}
```

Properties can be created from `EventStream`s, `Stream`s or `Future`s.

```dart
// Create a property from an EventStream
eventStream.asProperty();

// Create a property from a Dart Stream
Property.fromStream(stream);

// Create a property from a Future.
Property.fromFuture(futureValue);
```

Properties can also be combined, and their values will be recomputed whenever a dependency changes. For instance, the property `isFormValid` will update whenever a character is entered into the username or password fields:

```dart
bool isNotEmpty(String value) => value != null && value.isNotEmpty;

var isUsernamePresent = new Property
    .fromStream(usernameField.onChange.map((_) => usernameField.value))
    .map(isNotEmpty);
var isPasswordPresent = new Property
    .fromStream(passwordField.onChange.map((_) => passwordField.value))
    .map(isNotEmpty);
    
var isFormValid = isUsernamePresent.and(isPasswordPresent);
```
