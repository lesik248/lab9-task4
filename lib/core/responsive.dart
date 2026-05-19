import 'package:flutter/widgets.dart';

enum FormFactor { compact, medium, expanded }

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  FormFactor get formFactor {
    final w = screenWidth;
    if (w < 600) return FormFactor.compact;
    if (w < 1024) return FormFactor.medium;
    return FormFactor.expanded;
  }

  bool get isCompact => formFactor == FormFactor.compact;
  bool get isMedium  => formFactor == FormFactor.medium;
  bool get isExpanded => formFactor == FormFactor.expanded;

  double wp(double fraction) => screenWidth * fraction;
  double hp(double fraction) => screenHeight * fraction;

  int gridColumns({int min = 1, int max = 4}) {
    final w = screenWidth;
    if (w < 480) return min;
    if (w < 800) return (min + 1).clamp(min, max);
    if (w < 1200) return (min + 2).clamp(min, max);
    return max;
  }
}
