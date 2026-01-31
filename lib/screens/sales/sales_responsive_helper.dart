import 'package:flutter/material.dart';

/// Responsive helper for Sales screen
class SalesResponsiveHelper {
  final BuildContext context;
  late final double screenWidth;
  late final double screenHeight;

  SalesResponsiveHelper(this.context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
  }

  bool get isCompact => screenWidth < 800;
  bool get isMedium => screenWidth >= 800 && screenWidth < 1200;
  bool get isExpanded => screenWidth >= 1200;

  double get pagePadding => isCompact ? 12 : (isMedium ? 18 : 22);
  double get cardPadding => isCompact ? 12 : (isMedium ? 16 : 20);
  double get itemSpacing => isCompact ? 8 : 10;
  double get sectionSpacing => 15;

  double get titleSize => isCompact ? 20 : (isMedium ? 24 : 28);
  double get headingSize => isCompact ? 16 : (isMedium ? 18 : 20);
  double get bodySize => isCompact ? 13 : (isMedium ? 14 : 15);
  double get captionSize => isCompact ? 11 : (isMedium ? 12 : 13);
  double get statValueSize => isCompact ? 20 : (isMedium ? 26 : 32);

  int get statsColumns => isCompact ? 2 : 4;
  double get statsCardWidth => isCompact ? 140 : (isMedium ? 180 : 220);
  double get statsCardHeight => isCompact ? 90 : (isMedium ? 100 : 110);

  double get saleCardHeight => isCompact ? 85 : (isMedium ? 95 : 105);

  double get cardRadius => isCompact ? 12 : (isMedium ? 14 : 16);
  double get buttonRadius => isCompact ? 8 : (isMedium ? 10 : 12);
  double get chipRadius => isCompact ? 16 : (isMedium ? 18 : 20);

  double get iconSize => isCompact ? 18 : (isMedium ? 20 : 22);
  double get statIconSize => isCompact ? 24 : (isMedium ? 28 : 32);

  double get buttonHeight => isCompact ? 36 : (isMedium ? 40 : 44);
  double get filterButtonWidth => isCompact ? 90 : (isMedium ? 110 : 130);
}
