import 'dart:math';

/// Service for barcode/QR code operations
class BarcodeService {
  static final BarcodeService _instance = BarcodeService._internal();
  factory BarcodeService() => _instance;
  BarcodeService._internal();

  // Characters for random part of barcode
  static const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  static final _random = Random();

  /// Generate a unique barcode/QR code value
  /// Format: DPOS-{CATEGORY_CODE}-{TIMESTAMP}-{RANDOM}
  /// Example: DPOS-MOB-1706612345-A7X2
  String generateBarcode({String? categoryCode}) {
    final code = categoryCode?.substring(0, 3).toUpperCase() ?? 'GEN';
    final timestamp = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(5);
    final randomPart = _generateRandomString(4);
    return 'DPOS-$code-$timestamp-$randomPart';
  }

  /// Generate a simple numeric barcode (EAN-13 compatible length)
  String generateNumericBarcode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    // Take last 12 digits and add a check digit
    final base = timestamp.substring(timestamp.length - 12);
    final checkDigit = _calculateEAN13CheckDigit(base);
    return '$base$checkDigit';
  }

  /// Calculate EAN-13 check digit
  int _calculateEAN13CheckDigit(String code) {
    int sum = 0;
    for (int i = 0; i < code.length; i++) {
      int digit = int.parse(code[i]);
      sum += (i % 2 == 0) ? digit : digit * 3;
    }
    return (10 - (sum % 10)) % 10;
  }

  String _generateRandomString(int length) {
    return List.generate(
      length,
      (_) => _chars[_random.nextInt(_chars.length)],
    ).join();
  }

  /// Validate if a barcode format is valid
  bool isValidBarcode(String barcode) {
    if (barcode.isEmpty) return false;
    // Accept our format or standard numeric barcodes
    return barcode.startsWith('DPOS-') ||
        RegExp(r'^\d{8,14}$').hasMatch(barcode);
  }

  /// Check if input appears to be from hardware scanner
  /// Hardware scanners typically input very rapidly
  static bool isHardwareScannerInput(Duration inputDuration, int charCount) {
    // If many characters input very quickly, likely a scanner
    // Scanners typically input 10+ chars in under 100ms
    return charCount >= 8 && inputDuration.inMilliseconds < 200;
  }
}
