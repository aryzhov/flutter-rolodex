import 'package:flutter/material.dart';
import 'dart:math';

/// Card fall direction.
enum RolodexDirection {
  // Forward when new value is greater, backward when new value is less
  normal,

  // Forward when new value is less, backward when new value is greater
  reversed,

  // Always forward
  forward,

  // Always backward
  backward,
}

/// Mode of operation.
enum RolodexMode {
  // Falling cards simulation
  falling,
  // Split-flap simulation
  splitFlap,
}

/// Theme settings.
class RolodexThemeData {
  static final RolodexThemeData defaults = const RolodexThemeData(
    cardColor: const Color.fromARGB(255, 255, 255, 255),
    shadowColor: const Color.fromARGB(128, 128, 128, 128),
    alwaysShowBackground: false,
    maxCards: 3,
    animationDuration: const Duration(milliseconds: 500),
    animationCurve: Curves.linear,
    clipBorderRadius: BorderRadius.zero,
    cardFallDirection: AxisDirection.down,
    cardStackAlignment: AlignmentDirectional.center,
    direction: RolodexDirection.normal,
    mode: RolodexMode.falling,
  );

  static final RolodexThemeData empty = const RolodexThemeData();

  // Card color.
  final Color cardColor;

  // Shadow color.
  final Color shadowColor;

  // If [true] then card background will be shown even when no cards are in motion
  final bool alwaysShowBackground;

  // The maximum number of cards in flight, including the bottom card.
  final int maxCards;

  // The the time it takes for a card to drop.
  final Duration animationDuration;

  // Animation curve.
  final Curve animationCurve;

  // Border radius for clip rect.
  final BorderRadius clipBorderRadius;

  // The direction in which the cards "fall": down, up, left, right.
  final AxisDirection cardFallDirection;

  // Defines the alignment point in case if cards have different sizes.
  final AlignmentGeometry cardStackAlignment;

  final RolodexDirection direction;

  final RolodexMode mode;

  const RolodexThemeData({
    this.cardColor,
    this.shadowColor,
    this.alwaysShowBackground,
    this.maxCards,
    this.animationDuration,
    this.animationCurve,
    this.clipBorderRadius,
    this.cardStackAlignment,
    this.cardFallDirection,
    this.direction,
    this.mode,
  });

  static RolodexThemeData combine(
      RolodexThemeData theme, RolodexThemeData defaults) {
    if (defaults == null || defaults.isEmpty()) {
      return theme ?? empty;
    } else if (theme == null || theme.isEmpty()) {
      return defaults ?? empty;
    } else if (theme.isFull()) {
      return theme;
    } else {
      return RolodexThemeData(
        cardColor: theme.cardColor ?? defaults.cardColor,
        shadowColor: theme.shadowColor ?? defaults.shadowColor,
        alwaysShowBackground:
            theme.alwaysShowBackground ?? defaults.alwaysShowBackground,
        maxCards: theme.maxCards ?? defaults.maxCards,
        animationDuration:
            theme.animationDuration ?? defaults.animationDuration,
        animationCurve: theme.animationCurve ?? defaults.animationCurve,
        clipBorderRadius: theme.clipBorderRadius ?? defaults.clipBorderRadius,
        cardStackAlignment:
            theme.cardStackAlignment ?? defaults.cardStackAlignment,
        cardFallDirection:
            theme.cardFallDirection ?? defaults.cardFallDirection,
        direction: theme.direction ?? defaults.direction,
        mode: theme.mode ?? defaults.mode,
      );
    }
  }

  RolodexThemeData nullIfEmpty() {
    return isEmpty() ? null : this;
  }

  bool isEmpty() {
    return this == empty;
  }

  bool isFull() {
    return this.cardColor != null &&
        this.shadowColor != null &&
        this.alwaysShowBackground != null &&
        this.maxCards != null &&
        this.animationDuration != null &&
        this.animationCurve != null &&
        this.clipBorderRadius != null &&
        this.cardStackAlignment != null &&
        this.cardFallDirection != null &&
        this.direction != null &&
        this.mode != null;
  }

  bool operator ==(dynamic o) {
    if (identical(this, o)) {
      return true;
    } else if (o is RolodexThemeData) {
      return this.cardColor == o.cardColor &&
          this.shadowColor == o.shadowColor &&
          this.maxCards == o.maxCards &&
          this.alwaysShowBackground == o.alwaysShowBackground &&
          this.animationDuration == o.animationDuration &&
          this.animationCurve == o.animationCurve &&
          this.clipBorderRadius == o.clipBorderRadius &&
          this.cardStackAlignment == o.cardStackAlignment &&
          this.cardFallDirection == o.cardFallDirection &&
          this.direction == o.direction &&
          this.mode == o.mode;
    } else {
      return false;
    }
  }

  int get hashCode {
    return 0; // we don't care
  }

  static RolodexThemeData of(BuildContext context,
      {bool rebuildOnChange = true}) {
    final notifier = rebuildOnChange
        ? context.dependOnInheritedWidgetOfExactType<_RolodexThemeNotifier>()
        : context.findAncestorWidgetOfExactType<_RolodexThemeNotifier>();
    return notifier?.themeData ?? defaults;
  }

  static RolodexThemeData withDefaults(
      RolodexThemeData theme, BuildContext context,
      {bool rebuildOnChange = true}) {
    if (theme != null && theme.isFull()) {
      return theme;
    } else {
      return combine(
          combine(theme, of(context, rebuildOnChange: rebuildOnChange)),
          defaults);
    }
  }
}

/// Specifies theme settings for the widget tree underneath it.
class RolodexTheme extends StatelessWidget {
  final RolodexThemeData data;
  final Widget child;

  RolodexTheme({@required this.data, @required this.child});

  @override
  Widget build(BuildContext context) {
    _RolodexThemeNotifier n =
        context.dependOnInheritedWidgetOfExactType<_RolodexThemeNotifier>();
    return _RolodexThemeNotifier(
      themeData: RolodexThemeData.combine(data, n?.themeData),
      child: this.child,
    );
  }
}

/// Makes an [ExpandableController] available to the widget subtree.
/// Useful for making multiple [Expandable] widgets synchronized with a single controller.
class _RolodexThemeNotifier extends InheritedWidget {
  final RolodexThemeData themeData;

  _RolodexThemeNotifier({@required this.themeData, @required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return !(oldWidget is _RolodexThemeNotifier &&
        oldWidget.themeData == themeData);
  }
}

// A comparator that compares comparable values
int comparableComparator(dynamic a, dynamic b) {
  if (a == null || b == null) return a == b ? 0 : a == null ? -1 : 1;
  if (a is Comparable) {
    return a.compareTo(b);
  } else {
    return a == b ? 0 : 1;
  }
}

class _RolodexCard<T> extends StatelessWidget {
  final _RolodexItem item;
  final _RolodexItem topItem;

  _RolodexCard(this.item, this.topItem) : super(key: item.key);

  @override
  Widget build(BuildContext context) {
    final theme = item.theme;

    Widget addBackground(Widget w) {
      if (item.direction != 0 || topItem != null || theme.alwaysShowBackground) {
        return DecoratedBox(
          child: w,
          decoration: BoxDecoration(
            color: theme.cardColor,
          ),
          position: DecorationPosition.background,
        );
      } else {
        return w;
      }
    }

    Widget clipBackground(Widget w) {
      if (theme.clipBorderRadius != BorderRadius.zero) {
        if (item.direction != 0 || topItem != null || theme.alwaysShowBackground) {
          return ClipRRect(
            borderRadius: theme.clipBorderRadius,
            child: w,
            clipBehavior: Clip.antiAlias,
          );
        }
      }
      return w;
    }

    Widget addShadow(Widget w, double value) {
      return DecoratedBox(
        child: w,
        decoration: BoxDecoration(
          color: theme.shadowColor.withOpacity(value),
        ),
        position: DecorationPosition.foreground,
      );
    }

    Widget addShadowAnimation(
        Widget w, Animation<double> animation, double Function(double d) func) {
      if(animation == null)
        return w;
      return AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return addShadow(w, func(animation.value));
          });
    }

    Widget w = addBackground(item.rolodex.child);

    if (item.direction == 0) {
      return clipBackground(addShadowAnimation(w, topItem?.animation, (d) => d / 2));
    } else {
      return AnimatedBuilder(
        animation: item.animation,
        builder: (context, child) {
          final widget = clipBackground(addShadow(w, max(0.0, min(1.0, 1 - item.animation.value - (topItem?.animation?.value ?? 0)/ 2))));
          return Transform(
            origin: Offset.zero,
            alignment: _getTransformAlignment(theme.cardFallDirection),
            transform: _getTransformMatrix(
                theme.cardFallDirection, item.animation.value),
            child: widget,
          );
        },
      );
    }
  }

  static _getTransformAlignment(AxisDirection ad) {
    switch (ad) {
      case AxisDirection.up:
        return AlignmentDirectional.topCenter;
      case AxisDirection.down:
        return AlignmentDirectional.bottomCenter;
      case AxisDirection.right:
        return AlignmentDirectional.centerEnd;
      case AxisDirection.left:
        return AlignmentDirectional.centerStart;
    }
  }

  static _getTransformMatrix(AxisDirection ad, double scale) {
    switch (ad) {
      case AxisDirection.down:
      case AxisDirection.up:
        return Matrix4.diagonal3Values(1.0, scale, 1.0);
      case AxisDirection.left:
      case AxisDirection.right:
        return Matrix4.diagonal3Values(scale, 1.0, 1.0);
    }
  }
}

enum _SplitFlapCardPart {
  topHalf,
  bottomHalf,
  full,
}

class _SplitFlapCardClipper extends CustomClipper<Rect> {
  final _SplitFlapCardPart part;
  final AxisDirection direction;

  const _SplitFlapCardClipper(this.part, this.direction);

  @override
  Rect getClip(Size size) {
    switch (part) {
      case _SplitFlapCardPart.full:
        return Rect.fromLTRB(0, 0, size.width, size.height);
      case _SplitFlapCardPart.topHalf:
        switch (direction) {
          case AxisDirection.down:
            return Rect.fromLTRB(0, 0, size.width, size.height / 2);
          case AxisDirection.up:
            return Rect.fromLTRB(0, size.height / 2, size.width, size.height);
          case AxisDirection.left:
            return Rect.fromLTRB(0, 0, size.width / 2, size.height);
          case AxisDirection.right:
            return Rect.fromLTRB(size.width / 2, 0, size.width, size.height);
        }
        assert(false);
        return null;
      case _SplitFlapCardPart.bottomHalf:
        switch (direction) {
          case AxisDirection.down:
            return Rect.fromLTRB(0, size.height / 2, size.width, size.height);
          case AxisDirection.up:
            return Rect.fromLTRB(0, 0, size.width, size.height / 2);
          case AxisDirection.left:
            return Rect.fromLTRB(size.width / 2, 0, size.width, size.height);
          case AxisDirection.right:
            return Rect.fromLTRB(0, 0, size.width / 2, size.height);
        }
        assert(false);
        return null;
      default:
        assert(false);
        return null;
    }
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    if (oldClipper is _SplitFlapCardClipper) {
      return oldClipper.part != part || oldClipper.direction != direction;
    } else {
      return true;
    }
  }
}

class _SplitFlapCard<T> extends StatelessWidget {
  final _RolodexItem item;
  final _RolodexItem prevItem;
  final _RolodexItem nextItem;
  final _SplitFlapCardPart part;

  _SplitFlapCard(this.item, this.prevItem, this.nextItem, this.part);

  @override
  Widget build(BuildContext context) {
    final theme = item.theme;
    final direction = this.part == _SplitFlapCardPart.topHalf ? item.direction: (nextItem?.direction ?? 0);

    Widget addBackground(Widget w) {
      if (item.direction != 0 ||
          part != _SplitFlapCardPart.full ||
          theme.alwaysShowBackground) {
        return DecoratedBox(
          child: w,
          decoration: BoxDecoration(
            color: theme.cardColor,
          ),
          position: DecorationPosition.background,
        );
      } else {
        return w;
      }
    }

    Widget clipBackground(Widget w) {
      if (theme.clipBorderRadius != BorderRadius.zero) {
        if (direction != 0 ||
            part != _SplitFlapCardPart.full ||
            theme.alwaysShowBackground) {
          return ClipRRect(
            borderRadius: theme.clipBorderRadius,
            child: w,
            clipBehavior: Clip.antiAlias,
          );
        }
      }
      return w;
    }

    Widget clipPart(Widget w, _SplitFlapCardPart part) {
      if (part == _SplitFlapCardPart.full) {
        return w;
      } else {
        return ClipRect(
          clipper: _SplitFlapCardClipper(part, theme.cardFallDirection),
          child: w,
        );
      }
    }

    Widget addShadow(Widget w, double value) {
      return DecoratedBox(
        child: w,
        decoration: BoxDecoration(
          color: theme.shadowColor.withOpacity(value),
        ),
        position: DecorationPosition.foreground,
      );
    }

    Widget addShadowAnimation(
        Widget w, Animation<double> animation, double Function(double d) func) {
      if(animation == null)
        return w;
      return AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return addShadow(w, func(animation.value));
          });
    }

    Widget widget = addBackground(item.rolodex.child);

    if(direction == 0) {
      switch(part) {
        case _SplitFlapCardPart.topHalf:
          return clipPart(
          clipBackground(addShadowAnimation(widget, nextItem?.animation, (v) => max(0, v - 0.5))), part);
        case _SplitFlapCardPart.bottomHalf:
          return clipPart(
            clipBackground(addShadowAnimation(widget, item?.animation, (v) => 1.0 - v)), part);
        case _SplitFlapCardPart.full:
          return clipPart(clipBackground(addBackground(item.rolodex.child)), part);
        default:
          assert(false); return null;
      }
    }

    final animation = part == _SplitFlapCardPart.topHalf ? item.animation: nextItem.animation;

    assert(animation != null);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final shadowValue = part == _SplitFlapCardPart.topHalf ?
          max(0.0, 1.0 - animation.value):
          min(1.0, max(0.0, (animation.value * 0.5 + (1.0 - (item?.animation?.value ?? 1.0)))));
        Widget w = clipPart(clipBackground(addShadow(widget, shadowValue)), part);
        final scale = part == _SplitFlapCardPart.topHalf
            ? max(0.0, (animation.value * 2 - 1.0))
            : max(0.0, (1.0 - animation.value * 2));
        return Transform(
          origin: Offset.zero,
          alignment: AlignmentDirectional.center,
          transform: _getTransformMatrix(theme.cardFallDirection, scale),
          child: w,
        );
      },
    );
  }

  static _getTransformMatrix(AxisDirection ad, double scale) {
    switch (ad) {
      case AxisDirection.down:
      case AxisDirection.up:
        return Matrix4.diagonal3Values(1.0, scale, 1.0);
      case AxisDirection.left:
      case AxisDirection.right:
        return Matrix4.diagonal3Values(scale, 1.0, 1.0);
    }
  }
}

class _RolodexItem<T> {
  final Rolodex rolodex;
  final Key key;
  final _RolodexState<T> state;
  AnimationController ac;
  Animation<double> animation;
  final int direction;

  _RolodexItem(this.key, this.rolodex, this.state, this.direction) {
    if (direction != 0) {
      ac = AnimationController(
          vsync: state,
          lowerBound: 0,
          upperBound: 1,
          duration: theme.animationDuration);
      animation = ac.drive(CurveTween(curve: Curves.linear));
      if (direction > 0) {
        ac.forward();
      } else {
        ac.reverse(from: 1);
      }
      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          state.itemAnimationDone(this);
        }
      });
    }
  }

  RolodexThemeData get theme => state.theme;

  T get value => rolodex.value;

  bool get visible => ac.value > 0;

  void dispose() {
    ac?.dispose();
  }
}

/// Simulates value change events as falling cards.
class Rolodex<T> extends StatefulWidget {
  /// Specifies the latest value
  final Widget child;
  /// The latest value
  final T value;
  /// The comparator (optional). Allows to determine the order of falling cards.
  final Comparator comparator;
  /// Theme settings. These will override global settings defined in [RolodexTheme].
  final RolodexThemeData theme;

  const Rolodex({
    Key key,
    @required this.child,
    @required this.value,
    this.comparator = comparableComparator,
    this.theme,
  }) : super(key: key);

  @override
  _RolodexState createState() => _RolodexState<T>();
}

class _RolodexState<T> extends State<Rolodex<T>> with TickerProviderStateMixin {
  final List<_RolodexItem> items = List<_RolodexItem>();
  int direction = 1;
  int _nextKey = 0;
  Key get nextKey => ValueKey<int>(_nextKey++);
  RolodexThemeData theme;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    items.forEach((item) => item.dispose());
    items.clear();
    super.dispose();
  }

  _RolodexItem newItem(Rolodex widget, int direction) =>
      _RolodexItem<T>(nextKey, widget, this, direction);

  @override
  void didUpdateWidget(Rolodex<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final last = oldWidget.value;
    if (last != widget.value) {
      final d0 = direction;
      if (theme.direction == RolodexDirection.forward) {
        direction = 1;
      } else if (theme.direction == RolodexDirection.backward) {
        direction = -1;
      } else {
        final comp = widget.comparator(widget.value, last);
        direction = (comp >= 0) == (theme.direction == RolodexDirection.normal)
            ? 1
            : -1;
      }

      final d = direction;
      setState(() {
        if (d <= 0) {
          if (d0 < 0) {
            items.add(newItem(widget, 1));
          } else {
            items.forEach((item) => item.dispose());
            final firstCard = items.removeAt(0);
            items.clear();
            items.add(newItem(firstCard.rolodex, 0));
            items.add(newItem(widget, 1));
          }
          while (items.length > theme.maxCards) {
            items.removeAt(0)..dispose();
            items[0].ac.value = 1;
          }
        } else {
          if (d0 < 0) {
            items.forEach((item) => item.dispose());
            final lastCard = items.last;
            items.clear();
            items.add(newItem(widget, 0));
            items.add(newItem(lastCard.rolodex, -1));
          } else {
            final firstItem = items.removeAt(0);
            firstItem.dispose();
            items.insert(0, newItem(firstItem.rolodex, -1));
            items.insert(0, newItem(widget, 0));
          }
          while (items.length > theme.maxCards) {
            items.removeLast()..dispose();
          }
        }
//        print("${items.map((e) => e.value)} ${items.map((e) => e.direction)}");
      });
    }
    theme = RolodexThemeData.withDefaults(widget.theme, context,
        rebuildOnChange: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = RolodexThemeData.withDefaults(widget.theme, context,
        rebuildOnChange: false);
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      final card = newItem(widget, 0);
      items.add(card);
    }

    final children = List<Widget>();
    switch (theme.mode) {
      case RolodexMode.falling:
        for (var i = 0; i < items.length; i++)
          children.add(_RolodexCard(
              items[i], i < items.length - 1 ? items[i + 1] : null));
        break;
      case RolodexMode.splitFlap:
        if (items.length < 2) {
          children.add(_SplitFlapCard(items[0], null, null, _SplitFlapCardPart.full));
        } else {
          for (var i = 0; i < items.length; i++) {
            final item = items[i];
            final nextItem = i < items.length -1 ? items[i + 1]: null;
            final prevItem = i == 0 ? null: items[i - 1];
            children.add(_SplitFlapCard(item, prevItem, nextItem, _SplitFlapCardPart.topHalf));
          }
          for (var i = items.length-1; i >= 0; i--) {
            final item = items[i];
            final nextItem = i < items.length - 1 ? items[i + 1]: null;
            final prevItem = i == 0 ? null: items[i - 1];
            children.add(_SplitFlapCard(item, prevItem, nextItem, _SplitFlapCardPart.bottomHalf));
          }
        }

        break;
    }

    return Stack(
      alignment: theme.cardStackAlignment,
      fit: StackFit.loose,
      children: children,
    );
  }

  itemAnimationDone(_RolodexItem<T> item) {
    int idx = items.indexOf(item);
    if (idx < 0) {
      return;
    }
    if (item.visible) {
      setState(() {
        for (var i = 0; i < idx; i++) items[i].dispose();
        items.removeRange(0, idx);
        if (item.direction != 0) {
          items.removeAt(0).dispose();
          items.insert(0, newItem(item.rolodex, 0));
        }
//        print("${items.map((e) => e.value)} ${items.map((e) => e.direction)}");
      });
    } else {
      setState(() {
        items.removeAt(idx).dispose();
//        print("${items.map((e) => e.value)} ${items.map((e) => e.direction)}");
      });
    }
  }
}
