/// 🔹 Responsive Helper - Fluid Scaling System
class ResponsiveHelper {
  final double screenWidth;

  ResponsiveHelper(this.screenWidth);

  // Base reference widths
  static const double _minWidth = 400;
  static const double _maxWidth = 1400;

  /// Core scaling function - smoothly interpolates between min and max values
  double scale(double minValue, double maxValue) {
    // Normalize screen width to 0-1 range
    final normalized = ((screenWidth - _minWidth) / (_maxWidth - _minWidth))
        .clamp(0.0, 1.0);
    // Lerp between min and max
    return minValue + (maxValue - minValue) * normalized;
  }

  // === LAYOUT ===
  int get featureGridColumns {
    if (screenWidth > 600) return 3; // 3 columns for medium and large
    return 2; // Single column for small screens
  }

  double get featureCardAspectRatio {
    // Fluid aspect ratio that grows with screen
    if (featureGridColumns == 3) {
      return scale(1.6, 2.8); // 3-column: grows from 1.6 to 2.8
    }
    return 3.2; // Small: single column, fixed
  }

  bool get useSummaryRow => screenWidth > 700;

  // === SPACING ===
  double get horizontalPadding => scale(16, 40);
  double get verticalPadding => scale(16, 32);
  double get sectionSpacing => scale(20, 36);
  double get gridSpacing => scale(12, 24);
  double get cardSpacing => scale(12, 24);

  // === HEADER ===
  double get headerTitleSize => scale(20, 30);
  double get headerSubtitleSize => scale(12, 15);

  // === FEATURE CARDS ===
  double get featureIconContainerSize => scale(40, 64);
  double get featureIconSize => scale(20, 32);
  double get featureTitleSize => scale(13, 18);
  double get featureSubtitleSize => scale(11, 14);
  double get featureCardPadding => scale(12, 24);
  double get featureCardBorderRadius => scale(12, 18);
  double get featureIconBorderRadius => scale(10, 16);
  double get featureInternalSpacing => scale(10, 18);

  // === SUMMARY CARDS (Smaller/Compact) ===
  double get summaryTitleSize => scale(16, 20);
  double get summaryCardPadding => scale(12, 20);
  double get summaryIconContainerSize => scale(32, 44);
  double get summaryIconSize => scale(16, 22);
  double get summaryLabelSize => scale(11, 14);
  double get summaryValueSize => scale(18, 28);
  double get summaryChangeSize => scale(10, 12);
  double get summaryCardBorderRadius => scale(10, 16);
}
