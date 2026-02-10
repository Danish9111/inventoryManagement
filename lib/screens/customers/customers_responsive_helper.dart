
class CustomersResponsiveHelper {
  final double screenWidth;

  CustomersResponsiveHelper(this.screenWidth);

  bool get isCompact => screenWidth < 800;
  bool get isMedium => screenWidth >= 800 && screenWidth < 1200;
  bool get isExpanded => screenWidth >= 1200;

  double get pagePadding => isCompact ? 16 : 24;
  double get sectionSpacing => isCompact ?8 : 14;

  double scale(double min, double max) {
    if (isCompact) return min;
    if (isExpanded) return max;
    return min + (max - min) * ((screenWidth - 800) / 400);
  }
}
