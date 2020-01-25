import 'dart:async';
import 'package:flutter/material.dart';

typedef RolodexValueWidgetBuilder<T> = Widget Function(BuildContext context, T value);

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

class Rolodex<T> extends StatefulWidget {

  final RolodexValueWidgetBuilder<T> builder;
  final T value;
  final Comparator comparator;
  final Decoration decoration;

  const Rolodex({
    @required
    this.builder,
    @required
    this.value,
    this.decoration,
    this.comparator = comparableComparator,
  });

  @override
  _RolodexState createState() => _RolodexState<T>();
}

class _RolodexCard<T> extends StatefulWidget {
  final Rolodex rolodex;
  int direction; // 0 = first, 1 = down, -1 = up

  _RolodexCard(Key key, this.rolodex, this.direction): super(key: key);

  T get value => rolodex.value;

  @override
  _RolodexCardState createState() => _RolodexCardState();
}

class _RolodexCardState<T> extends State<_RolodexCard<T>> with SingleTickerProviderStateMixin {

  AnimationController ac;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    ac = AnimationController(vsync: this, lowerBound: 0, upperBound: 1, duration: const Duration(milliseconds: 500));
    animation = ac.drive(CurveTween(curve: Curves.linear));
    if(widget.direction > 0) {
      ac.forward();
    } else if(widget.direction < 0) {
      ac.reverse(from: 1);
    } else {
      ac.value = 1;
    }
  }

  @override
  void dispose() {
    this.ac?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        Widget w = widget.rolodex.builder(context, widget.rolodex.value);
        if(widget.rolodex.decoration != null) {
          w = Container(
            decoration: widget.rolodex.decoration,
            child: w,
          );
        }
        return Transform(
          origin: Offset.zero,
          transform: Matrix4.diagonal3Values(1.0, animation.value, 1.0),
          child: w,
        );
      },
    );
  }
}

class _RolodexState<T> extends State<Rolodex<T>> {

  final List<_RolodexCard> cards = List<_RolodexCard>();
  int direction = 1;
  int _nextKey = 0;

  Key get nextKey => ValueKey<int>(_nextKey++);

  @override
  void initState() {
    super.initState();
    final card = _RolodexCard(nextKey, widget, 0);
    cards.add(card);
  }

  @override
  void didUpdateWidget(Rolodex<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final last = oldWidget.value;
    if(last != widget.value) {
      final d = widget.comparator(widget.value, last);
      if(d >= 0) {
        if(direction > 0) {
          setState(() {
            cards.add(_RolodexCard(nextKey, widget, 1));
          });
        } else {
          direction = 1;
          setState(() {
            final firstCard = cards.removeAt(0);
            cards.clear();
            cards.add(_RolodexCard(nextKey, firstCard.rolodex, 0));
            cards.add(_RolodexCard(nextKey, widget, 1));
          });
        }
      } else {
        if(direction > 0) {
          direction = -1;
          setState(() {
            final lastCard = cards.last;
            cards.clear();
            cards.add(_RolodexCard(nextKey, widget, 0));
            cards.add(_RolodexCard(nextKey, lastCard.rolodex, -1));
          });
        } else {
          setState(() {
            final lastCard = cards.removeAt(0);
            cards.insert(0, _RolodexCard(nextKey, lastCard.rolodex, -1));
            cards.insert(0, _RolodexCard(nextKey, widget, 0));
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: cards,);
  }
}
