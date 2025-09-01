import 'package:flutter/material.dart';

extension EmptyPadding on num {
  SizedBox get sbH => SizedBox(height: toDouble());
  SizedBox get sbW => SizedBox(width: toDouble());
}

extension ContextExtensions on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  Color get primaryColor => Theme.of(this).primaryColor;
}
