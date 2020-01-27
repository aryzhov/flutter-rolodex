# Rolodex

A Flutter widget that animates a value change by simulating a card with the new value falling 
on top of the previous value. Useful for indicating a change in the displayed value.
You can use it for showing scores, stock quotes, bonus points, etc.

![animated image](https://github.com/aryzhov/rolodex/blob/master/doc/rolodex.gif?raw=true)


## Getting Started

It's very easy to add Rolodex to an existing app. All you need to do is:

1. Add a dependency on `rolodex` package in `pubspec.yaml`:
```yaml
dependencies:
  rolodex: any
```

2. Import the library:
```dart
import 'package:rolodex/rolodex.dart';
```

3. Wrap a widget that shows a value with [Rolodex]:

```dart
Rolodex(
  value: _counter,  // <-- Make sure to specify the value 
  child: Text(      // <-- The wrapped widget
    '$_counter',
    style: Theme.of(context).textTheme.display1,
  ),
),
```

You can try this with the default Flutter app generated by `flutter create`.

## Customization

Rolodex provides limited but extensive customization capabilities via themes. You can customize Rolodex by specifying theme 
attributes, for example:

```dart
Rolodex(
  theme: const RolodexThemeData(
    direction: RolodexDirection.reversed,
    cardColor: Colors.blue,
    shadowColor: Colors.indigo,
    clipBorderRadius: BorderRadius.all(Radius.circular(6)),
    alwaysShowBackground: true,
  ),
  value: _counter,
  child: SizedBox(
    width: 60,
    height: 60,
    child: Center(
      child: Text("$_counter",
        style: Theme.of(context).textTheme.display1.copyWith(
          fontSize: 40, color: Colors.white,
        ),
        softWrap: false, overflow: TextOverflow.ellipsis,
      ),
    ),
  ),
),
```

## Global Settings

Instead of customizing every Rolodex widget in your app, you might want to specify global theme settings 
via [RolodexTheme]:

```dart
return MaterialApp(
  title: 'Flutter Demo',
  theme: ThemeData(
    primarySwatch: Colors.blue,
  ),
  home: RolodexTheme(
    data: RolodexThemeData(           // <-- These settings will apply to all Rolodex widgets in the widget tree
      mode: RolodexMode.splitFlap,
      maxCards: 2,
      animationDuration: Duration(milliseconds: 200),
    ),
    child: MyHomePage(title: 'Flutter Demo Home Page')
  ),
);

```
