/// Responsive helper for Barcode screen
class BarcodeResponsiveHelper {
  final double screenWidth;

  BarcodeResponsiveHelper(this.screenWidth);

  // Breakpoints
  bool get isCompact => screenWidth < 900;

  bool get isMedium => screenWidth >= 900 && screenWidth < 1200;

  bool get isLarge => screenWidth >= 1200;

  // Grid columns
  int get gridColumns {
    if (screenWidth < 600) return 1;
    if (screenWidth < 900) return 2;
    if (screenWidth < 1200) return 3;
    return 4;
  }

  // Padding
  double get pagePadding => scale(16, 32);

  double get cardPadding => scale(12, 20);

  double get sectionSpacing => scale(16, 24);

  // Font sizes
  double get titleSize => scale(20, 28);

  double get subtitleSize => scale(14, 16);

  double get bodySize => scale(12, 14);

  double get labelSize => scale(10, 12);

  // Card dimensions
  double get cardRadius => scale(12, 16);

  double get iconSize => scale(20, 28);

  double get buttonHeight => scale(40, 48);

  // QR Code size
  double get qrCodeSize => scale(150, 220);

  double get qrCodeCardWidth => scale(280, 350);

  /// Scale value between min and max based on screen width
  double scale(double min, double max) {
    const minWidth = 600.0;
    const maxWidth = 1400.0;

    if (screenWidth <= minWidth) return min;
    if (screenWidth >= maxWidth) return max;

    final t = (screenWidth - minWidth) / (maxWidth - minWidth);
    return min + (max - min) * t;
  }
}
