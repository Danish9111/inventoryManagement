/// 🔹 POS Responsive Helper - Fluid Scaling System
class PosResponsiveHelper {
  final double screenWidth;

  PosResponsiveHelper(this.screenWidth);

  // Base reference widths
  static const double _minWidth = 600;
  static const double _maxWidth = 1400;

  /// Core scaling function
  double scale(double minValue, double maxValue) {
    final normalized = ((screenWidth - _minWidth) / (_maxWidth - _minWidth))
        .clamp(0.0, 1.0);
    return minValue + (maxValue - minValue) * normalized;
  }

  // === LAYOUT ===
  double get leftPanelFlex => 0.62; // 62% for products
  double get rightPanelFlex => 0.38; // 38% for cart

  int get productGridColumns {
    if (screenWidth > 1200) return 4;
    if (screenWidth > 900) return 3;

    return 3;
  }

  // More compact aspect ratio (higher = shorter cards)
  double get productCardAspectRatio => scale(0.85, 0.95);

  // === SPACING ===
  double get panelPadding => scale(10, 20);
  double get gridSpacing => scale(8, 12);
  double get sectionSpacing => scale(10, 16);

  // === HEADER ===
  double get headerTitleSize => scale(16, 22);
  double get headerSubtitleSize => scale(10, 13);

  // === PRODUCT CARD (Compact) ===
  double get productCategorySize => scale(9, 11);
  double get productNameSize => scale(11, 13);
  double get productPriceSize => scale(12, 14);
  double get productCardPadding => scale(10, 12);
  double get productCardRadius => scale(8, 12);
  double get qtyButtonSize => scale(20, 24);
  double get qtyFontSize => scale(10, 12);

  // === CART PANEL ===
  double get cartHeaderSize => scale(14, 18);
  double get cartItemNameSize => scale(11, 13);
  double get cartItemPriceSize => scale(11, 13);
  double get cartItemPadding => scale(8, 12);
  double get cartItemRadius => scale(10, 12);

  // === ORDER SUMMARY ===
  double get summaryLabelSize => scale(11, 13);
  double get summaryValueSize => scale(11, 13);
  double get summaryTotalSize => scale(14, 18);
  double get payButtonHeight => scale(40, 48);
  double get payButtonFontSize => scale(13, 16);

  // === SEARCH & FILTERS ===
  double get searchHeight => scale(34, 42);
  double get filterButtonHeight => scale(30, 38);
  double get filterFontSize => scale(10, 12);
}
