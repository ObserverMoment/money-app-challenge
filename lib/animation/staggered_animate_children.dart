import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum AnimationType {
  fadeIn,
  scaleIn,
  slideIn,
  fadeScaleIn,
  fadeSlideIn,
}

List<Widget> staggeredAnimateChildren(List<Widget> children,
        {AnimationType type = AnimationType.fadeIn, int delayMs = 100}) =>
    switch (type) {
      AnimationType.fadeIn => children
          .mapIndexed((index, child) => child
              .animate(delay: Duration(milliseconds: index * delayMs))
              .fadeIn())
          .toList(),
      AnimationType.scaleIn => children
          .mapIndexed((index, child) => child
              .animate(delay: Duration(milliseconds: index * delayMs))
              .scale())
          .toList(),
      AnimationType.slideIn => children
          .mapIndexed((index, child) => child
              .animate(delay: Duration(milliseconds: index * delayMs))
              .slide())
          .toList(),
      AnimationType.fadeScaleIn => children
          .mapIndexed((index, child) => child
              .animate(delay: Duration(milliseconds: index * delayMs))
              .fadeIn()
              .scale())
          .toList(),
      AnimationType.fadeSlideIn => children
          .mapIndexed((index, child) => child
              .animate(delay: Duration(milliseconds: index * delayMs))
              .fadeIn()
              .slide())
          .toList(),
    };
