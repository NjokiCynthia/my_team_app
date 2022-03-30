import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget customSlider({BuildContext context, int index, List count}) {
  return AnimatedSmoothIndicator(
    activeIndex: index,
    count: count.length,
    effect: SlideEffect(
        dotWidth: 12.0,
        dotHeight: 12.0,
        paintStyle: PaintingStyle.fill,
        strokeWidth: 1.5,
        dotColor: Colors.grey[400],
        activeDotColor: Theme.of(context).primaryColor),
  );
}
