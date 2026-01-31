import '../dashBoard/responsive_helper.dart';

/// 🔹 Reports Responsive Helper - Extends base responsive system
/// Inherits core scaling and adds report-specific dimensions
class ReportsResponsiveHelper extends ResponsiveHelper {
  ReportsResponsiveHelper(super.screenWidth);

  // === REPORT HEADER ===
  double get reportHeaderTitleSize => scale(22, 32);
  double get reportHeaderSubtitleSize => scale(12, 16);

  // === REPORT CARDS (for report type selection) ===
  int get reportCardColumns {
    if (screenWidth > 1000) return 4;
    if (screenWidth > 700) return 3;
    if (screenWidth > 500) return 2;
    return 1;
  }

  double get reportCardAspectRatio {
    if (screenWidth > 1000) return 1.3;
    if (screenWidth > 700) return 1.4;
    return 2.8;
  }

  double get reportCardPadding => scale(14, 24);
  double get reportCardBorderRadius => scale(12, 20);
  double get reportCardIconSize => scale(28, 44);
  double get reportCardTitleSize => scale(13, 17);
  double get reportCardSubtitleSize => scale(10, 13);
  double get reportCardIconContainerSize => scale(48, 72);

  // === STAT CARDS (KPI cards) ===
  int get statCardColumns {
    if (screenWidth > 900) return 4;
    if (screenWidth > 600) return 2;
    // if (screenWidth > 300) return 1;
    return 2;
  }

  double get statCardHeight => scale(100, 140);
  double get statCardPadding => scale(14, 24);
  double get statCardIconSize => scale(20, 28);
  double get statCardIconContainerSize => scale(40, 56);
  double get statCardValueSize => scale(22, 30);
  double get statCardLabelSize => scale(11, 12);
  double get statCardChangeSize => scale(9, 12);

  // === CHARTS ===
  double get chartHeight => scale(220, 360);
  double get chartPadding => scale(12, 16);
  double get chartTitleSize => scale(14, 18);
  double get chartLabelSize => scale(9, 12);
  double get chartBarWidth => scale(12, 24);

  // === DATE FILTER ===
  double get dateFilterHeight => scale(38, 48);
  double get dateFilterPadding => scale(12, 20);
  double get dateFilterFontSize => scale(12, 14);
  double get dateFilterBorderRadius => scale(8, 12);

  // === TABLES ===
  double get tableHeaderSize => scale(11, 14);
  double get tableCellSize => scale(12, 14);
  double get tableRowHeight => scale(44, 56);
  double get tablePadding => scale(12, 20);

  // === SECTION SPACING ===
  double get reportSectionSpacing => scale(20, 36);
  double get reportCardSpacing => scale(12, 20);

  // === LAYOUT HELPERS ===
  bool get useWideLayout => screenWidth > 800;
  bool get useExtraWideLayout => screenWidth > 1100;
}
