import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Handles custom animation of new entry into the list
class CustomAnimatedList<T> extends StatefulWidget {
  final List<T> items;
  final bool Function(T a, T b) itemsAreTheSame;
  final Widget Function(T item) itemBuilder;
  const CustomAnimatedList(
      {super.key,
      required this.items,
      required this.itemsAreTheSame,
      required this.itemBuilder});

  @override
  State<CustomAnimatedList<T>> createState() => _CustomAnimatedListState<T>();
}

class _CustomAnimatedListState<T> extends State<CustomAnimatedList<T>>
    with SingleTickerProviderStateMixin {
  List<T> _entering = [];
  late List<T> _items;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Duration get _animationDuration => const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _items = [...widget.items];

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _entering = [];
          _animationController.reset();
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomAnimatedList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length > oldWidget.items.length) {
      _entering = widget.items
          .where((i) => _items.none((o) => widget.itemsAreTheSame(i, o)))
          .toList();
      _items = [...widget.items];
      _animationController.forward();
    }
  }

  bool _isEntering(T item) =>
      _entering.any((i) => widget.itemsAreTheSame(item, i));

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: _items.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = _items[index];
          return _isEntering(item)
              ? SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: widget.itemBuilder(_items[index]),
                  ),
                )
              : widget.itemBuilder(_items[index]);
        });
  }
}
