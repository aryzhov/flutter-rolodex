import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RolodexThemeData {
  static final RolodexThemeData defaults = RolodexThemeData(
    cardColor: Color.fromARGB(255, 255, 255, 255),
    shadowColor: Color.fromARGB(128, 128, 128, 128),
    alwaysShowBackground: false,
    maxCards: 3,
    animationDuration: const Duration(milliseconds: 500),
    animationCurve: Curves.linear,
    clipBorderRadius: BorderRadius.zero,
    cardFallDirection: AxisDirection.down,
    cardStackAlignment:  AlignmentDirectional.center,
  );

  static final RolodexThemeData empty = RolodexThemeData();

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
        alwaysShowBackground: theme.alwaysShowBackground ?? defaults.alwaysShowBackground,
        maxCards: theme.maxCards ?? defaults.maxCards,
        animationDuration: theme.animationDuration ?? defaults.animationDuration,
        animationCurve: theme.animationCurve ?? defaults.animationCurve,
        clipBorderRadius: theme.clipBorderRadius ?? defaults.clipBorderRadius,
        cardStackAlignment: theme.cardStackAlignment ?? defaults.cardStackAlignment,
        cardFallDirection: theme.cardFallDirection ?? defaults.cardFallDirection,
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
        this.cardFallDirection != null;
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
          this.cardFallDirection == o.cardFallDirection;
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
  if(a == null || b == null)
    return -1;
  if(a is Comparable) {
    return a.compareTo(b);
  } else {
    return 1;
  }
}

class _RolodexCard<T> extends StatelessWidget {
  final _RolodexItem item;
  final _RolodexItem topItem;

  _RolodexCard(this.item, this.topItem): super(key: item.key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: item.animation,
      builder: (context, child) {
        Widget w = item.rolodex.child ?? item.rolodex.builder(context);
        final theme = item.theme;
        if(theme.alwaysShowBackground || (item.direction != 0 || topItem != null)) {
          w = DecoratedBox(
            child: w,
            decoration: BoxDecoration(
              color: theme.cardColor,
            ),
            position: DecorationPosition.background,
          );
        }
        if(topItem != null) {
          final w0 = w;
          w = AnimatedBuilder(
            animation: topItem.animation,
            builder: (context, _) {
              return DecoratedBox(
                child: w0,
                decoration: BoxDecoration(
                  color: theme.shadowColor.withOpacity(topItem.animation.value),
//                    color: Colors.black26.withOpacity((1.0 - item.animation.value + topItem.animation.value) * 0.6),
                ),
                position: DecorationPosition.foreground,
              );
            }
          );
        }

        if(theme.clipBorderRadius != BorderRadius.zero) {
          if(item.direction != 0 || theme.alwaysShowBackground || item.animation.value < 1 || (topItem?.animation?.value ?? 1) < 1) {
            w = ClipRRect(
              borderRadius: theme.clipBorderRadius,
              child: w,
              clipBehavior: Clip.antiAlias,
            );
          }
        }

        if(item.direction == 0) {
          return w;
        } else {
          return Transform(
            origin: Offset.zero,
            alignment: _getTransformAlignment(theme.cardFallDirection),
            transform: _getTransformMatrix(theme.cardFallDirection, item.animation.value),
            child: w,
          );
        }
      },
    );
  }

  static _getTransformAlignment(AxisDirection ad) {
    switch(ad) {
      case AxisDirection.down: return AlignmentDirectional.topCenter;
      case AxisDirection.up: return AlignmentDirectional.bottomCenter;
      case AxisDirection.left: return AlignmentDirectional.centerEnd;
      case AxisDirection.right: return AlignmentDirectional.centerStart;
      default: return AlignmentDirectional.center;
    }
  }

  static _getTransformMatrix(AxisDirection ad, double scale) {
    switch(ad) {
      case AxisDirection.down:
      case AxisDirection.up: return Matrix4.diagonal3Values(1.0, scale, 1.0);
      case AxisDirection.left:
      case AxisDirection.right: return Matrix4.diagonal3Values(scale, 1.0, 1.0);
      default: return Matrix4.diagonal3Values(scale, scale, 1.0);
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
    ac = AnimationController(vsync: state, lowerBound: 0, upperBound: 1, duration: theme.animationDuration);
    animation = ac.drive(CurveTween(curve: Curves.linear));
    if(direction > 0) {
      ac.forward();
    } else if(direction < 0) {
      ac.reverse(from: 1);
    } else {
      ac.forward();
    }
    animation.addStatusListener((status) {
      if(status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        state.itemAnimationDone(this);
      }
    });
  }

  RolodexThemeData get theme => state.theme;

  T get value => rolodex.value;

  bool get visible => ac.value > 0;

  void dispose() {
    ac.dispose();
  }
}


class Rolodex<T> extends StatefulWidget {

  final WidgetBuilder builder;
  final Widget child;
  final T value;
  final Comparator comparator;
  final RolodexThemeData theme;

  const Rolodex({
    this.builder,
    this.child,
    @required
    this.value,
    this.comparator = comparableComparator,
    this.theme,
  }): assert(builder != null || child != null);

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

  _RolodexItem newItem(Rolodex widget, int direction) => _RolodexItem<T>(nextKey, widget, this, direction);

  @override
  void didUpdateWidget(Rolodex<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final last = oldWidget.value;
    if(last != widget.value) {
      final d0 = direction;
      final d = widget.comparator(widget.value, last);
      direction = d >= 0 ? 1: -1;
      setState(() {
        if(d >= 0) {
          if(d0 > 0) {
            items.add(newItem(widget, 1));
          } else {
            items.forEach((item) => item.dispose());
            final firstCard = items.removeAt(0);
            items.clear();
            items.add(newItem(firstCard.rolodex, 0));
            items.add(newItem(widget, 1));
          }
          while(items.length > theme.maxCards) {
            items.removeAt(0)..dispose();
            items[0].ac.value = 1;
          }
        } else {
          if(d0 > 0) {
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
          while(items.length > theme.maxCards) {
            items.removeLast()..dispose();
          }
        }
      });
    }
    theme = RolodexThemeData.withDefaults(widget.theme, context, rebuildOnChange: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = RolodexThemeData.withDefaults(widget.theme, context, rebuildOnChange: false);
  }


  @override
  Widget build(BuildContext context) {

    if(items.isEmpty) {
      final card = newItem(widget, 0);
      items.add(card);
    }

    return Stack(
      alignment: theme.cardStackAlignment,
      fit: StackFit.loose,
      children: [
        for(var i = 0; i < items.length; i++)
          _RolodexCard(items[i], i < items.length-1 ? items[i+1]: null)
      ],
    );
  }

  itemAnimationDone(_RolodexItem<T> item) {
    int idx = items.indexOf(item);
    if(idx < 0) {
      return;
    }
    if(item.visible) {
      setState(() {
        for(var i = 0; i < idx; i++)
          items[i].dispose();
        items.removeRange(0, idx);
        if(item.direction != 0) {
          items.removeAt(0).dispose();
          items.insert(0, newItem(item.rolodex, 0));
        }
      });
    } else {
      setState(() {
        items.removeAt(idx).dispose();
      });
    }
  }
}
