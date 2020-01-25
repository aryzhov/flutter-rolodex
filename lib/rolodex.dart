import 'dart:async';
import 'package:flutter/material.dart';

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

  _RolodexCard(this.item): super(key: item.key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: item.animation,
      builder: (context, child) {
        Widget w = item.rolodex.builder(context);
        return Transform(
          origin: Offset.zero,
          transform: Matrix4.diagonal3Values(1.0, item.animation.value, 1.0),
          child: w,
        );
      },
    );
  }
}

class _RolodexItem<T> {
  final Rolodex rolodex;
  final ValueKey<T> key;
  final _RolodexState<T> state;
  AnimationController ac;
  Animation<double> animation;

  _RolodexItem(this.key, this.rolodex, this.state, int direction) {
    ac = AnimationController(vsync: state, lowerBound: 0, upperBound: 1, duration: const Duration(milliseconds: 500));
    animation = ac.drive(CurveTween(curve: Curves.linear));
    if(direction > 0) {
      ac.forward();
    } else if(direction < 0) {
      ac.reverse(from: 1);
    } else {
      ac.value = 1;
    }
    animation.addStatusListener((status) {
      if(status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        state.itemAnimationDone(this);
      }
    });
  }

  T get value => rolodex.value;

  bool get visible => ac.value > 0;

  void dispose() {
    ac.dispose();
  }
}


class Rolodex<T> extends StatefulWidget {

  final WidgetBuilder builder;
  final T value;
  final Comparator comparator;
  static final maxItems = 3;

  const Rolodex({
    @required
    this.builder,
    @required
    this.value,
    this.comparator = comparableComparator,
  });

  @override
  _RolodexState createState() => _RolodexState<T>();
}


class _RolodexState<T> extends State<Rolodex<T>> with TickerProviderStateMixin {

  final List<_RolodexItem> items = List<_RolodexItem>();
  int direction = 1;
  int _nextKey = 0;

  Key get nextKey => ValueKey<int>(_nextKey++);

  @override
  void initState() {
    super.initState();
    final card = newItem(widget, 0);
    items.add(card);
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
          while(items.length > Rolodex.maxItems) {
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
            items[0].ac.reverse();
            items.insert(0, newItem(widget, 0));
          }
          while(items.length > Rolodex.maxItems) {
            items.removeLast()..dispose();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: items.map((item) => _RolodexCard(item)).toList(),
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
      });
    } else {
      setState(() {
        items.removeAt(idx).dispose();
      });
    }
  }
}