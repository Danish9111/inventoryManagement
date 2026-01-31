import 'package:dream_pos/screens/barcode/barcode_responsive_helper.dart';
import 'package:dream_pos/screens/products/data/productsData.dart';
import 'package:dream_pos/screens/products/model/product.dart';
import 'package:dream_pos/services/barcode_service.dart';
import 'package:dream_pos/widgets/appColors.dart';
import 'package:dream_pos/widgets/hardware_scanner_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({super.key});

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  final BarcodeService _barcodeService = BarcodeService();
  final FocusNode _scannerFocusNode = FocusNode();
  final TextEditingController _manualScanController = TextEditingController();

  // Generated barcode state
  String? _generatedBarcode;
  String? _selectedCategory;

  // Scanned product state
  Product? _scannedProduct;
  String _scanStatus = '';
  bool _isScanning = false;

  @override
  void dispose() {
    _scannerFocusNode.dispose();
    _manualScanController.dispose();
    super.dispose();
  }

  void _generateNewBarcode() {
    setState(() {
      _generatedBarcode = _barcodeService.generateBarcode(
        categoryCode: _selectedCategory,
      );
    });
  }

  void _handleBarcodeScanned(String barcode) {
    setState(() {
      _isScanning = true;
      _scanStatus = 'Searching for: $barcode';
    });

    final product = productsList.firstWhere(
      (p) => p.barcode!.trim() == barcode.trim(),

      orElse: () => Product(
        id: '',
        name: '',
        slug: '',
        sku: '',
        category: '',
        subCategory: '',
        brand: '',
        unit: '',
        sellingType: '',
        price: 0,
        quantity: 0,
        quantityAlert: 0,
        images: [],
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
          if (product.id.isNotEmpty) {
            _scannedProduct = product;
            _scanStatus = 'Product found!';
          } else {
            _scannedProduct = null;
            _scanStatus = 'Product not found for barcode: $barcode';
          }
        });
      }
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard'),
        backgroundColor: AppColors.purchaseGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearScanResult() {
    setState(() {
      _scannedProduct = null;
      _scanStatus = '';
      _manualScanController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final r = BarcodeResponsiveHelper(constraints.maxWidth);
        final isWide = constraints.maxWidth > 800;

        return HardwareScannerListener(
          onBarcodeScanned: _handleBarcodeScanned,
          child: Container(
            color: AppColors.backgroundGrey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: r.pagePadding,
                vertical: r.pagePadding * 0.75,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Compact Header
                  _buildCompactHeader(r),
                  SizedBox(height: r.scale(12, 16)),

                  // Cards Layout
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildGenerateCard(r)),
                        SizedBox(width: r.scale(12, 16)),
                        Expanded(child: _buildScanCard(r)),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildGenerateCard(r),
                        SizedBox(height: r.scale(12, 16)),
                        _buildScanCard(r),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactHeader(BarcodeResponsiveHelper r) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.scale(12, 16),
        vertical: r.scale(10, 14),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryBlue.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(r.scale(8, 10)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.qr_code_2_rounded,
              size: r.iconSize + 4,
              color: Colors.white,
            ),
          ),
          SizedBox(width: r.scale(10, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Barcode Management',
                  style: TextStyle(
                    fontSize: r.subtitleSize + 1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Generate & scan product barcodes',
                  style: TextStyle(
                    fontSize: r.labelSize,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: r.scale(10, 12),
              vertical: r.scale(5, 6),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.purchaseGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: r.scale(5, 6)),
                Text(
                  'Ready',
                  style: TextStyle(
                    fontSize: r.labelSize - 1,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateCard(BarcodeResponsiveHelper r) {
    final categories = ['General', 'Mobiles', 'Computers', 'Audio', 'Watches'];

    return Container(
      padding: EdgeInsets.all(r.scale(12, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(r.scale(6, 8)),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.add_box_rounded,
                  size: r.iconSize,
                  color: AppColors.primaryBlue,
                ),
              ),
              SizedBox(width: r.scale(8, 10)),
              Text(
                'Generate QR Code',
                style: TextStyle(
                  fontSize: r.bodySize + 1,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),

          SizedBox(height: r.scale(12, 14)),

          // QR Code Display
          Center(
            child: Container(
              padding: EdgeInsets.all(r.scale(12, 16)),
              decoration: BoxDecoration(
                color: _generatedBarcode != null
                    ? AppColors.purchaseGreenLight.withOpacity(0.3)
                    : AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _generatedBarcode != null
                      ? AppColors.purchaseGreen.withOpacity(0.3)
                      : AppColors.cardBorder,
                ),
              ),
              child: _generatedBarcode != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        QrImageView(
                          data: _generatedBarcode!,
                          version: QrVersions.auto,
                          size: r.scale(100, 140),
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(height: r.scale(8, 10)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                _generatedBarcode!,
                                style: TextStyle(
                                  fontSize: r.labelSize - 1,
                                  fontFamily: 'monospace',
                                  color: AppColors.textDark,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: r.scale(6, 8)),
                            InkWell(
                              onTap: () => _copyToClipboard(_generatedBarcode!),
                              child: Icon(
                                Icons.copy_rounded,
                                size: r.iconSize - 4,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code_2,
                          size: r.scale(60, 80),
                          color: AppColors.textGrey.withOpacity(0.25),
                        ),
                        SizedBox(height: r.scale(6, 8)),
                        Text(
                          'QR code will appear here',
                          style: TextStyle(
                            fontSize: r.labelSize,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          SizedBox(height: r.scale(10, 12)),

          // Category Chips
          Text(
            'Category',
            style: TextStyle(
              fontSize: r.labelSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
            ),
          ),
          SizedBox(height: r.scale(6, 8)),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedCategory = isSelected ? null : cat;
                }),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.scale(10, 12),
                    vertical: r.scale(4, 6),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryBlue : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.cardBorder,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: r.labelSize - 1,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textGrey,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: r.scale(12, 14)),

          // Generate Button
          SizedBox(
            width: double.infinity,
            height: r.scale(38, 44),
            child: ElevatedButton.icon(
              onPressed: _generateNewBarcode,
              icon: Icon(
                _generatedBarcode != null
                    ? Icons.refresh_rounded
                    : Icons.qr_code_rounded,
                size: r.iconSize - 2,
              ),
              label: Text(
                _generatedBarcode != null ? 'Regenerate' : 'Generate',
                style: TextStyle(
                  fontSize: r.bodySize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanCard(BarcodeResponsiveHelper r) {
    return Container(
      padding: EdgeInsets.all(r.scale(12, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(r.scale(6, 8)),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  size: r.iconSize,
                  color: AppColors.primaryOrange,
                ),
              ),
              SizedBox(width: r.scale(8, 10)),
              Text(
                'Scan Barcode',
                style: TextStyle(
                  fontSize: r.bodySize + 1,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),

          SizedBox(height: r.scale(12, 14)),

          // Scanner Icon
          Center(
            child: Container(
              padding: EdgeInsets.all(r.scale(24, 30)),
              decoration: BoxDecoration(
                color: _isScanning
                    ? AppColors.primaryOrange.withOpacity(0.1)
                    : AppColors.backgroundGrey,
                // shape: BoxShape.circle,
                border: Border.all(color: AppColors.cardBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isScanning
                    ? Icons.sensors_rounded
                    : Icons.qr_code_scanner_rounded,
                size: r.scale(36, 48),
                color: _isScanning
                    ? AppColors.primaryOrange
                    : AppColors.textGrey.withOpacity(0.4),
              ),
            ),
          ),

          SizedBox(height: r.scale(8, 10)),

          Center(
            child: Text(
              _isScanning ? 'Scanning...' : 'Ready to scan',
              style: TextStyle(
                fontSize: r.bodySize,
                fontWeight: FontWeight.w500,
                color: _isScanning
                    ? AppColors.primaryOrange
                    : AppColors.textGrey,
              ),
            ),
          ),

          SizedBox(height: r.scale(10, 12)),

          // Manual Input
          TextField(
            controller: _manualScanController,
            focusNode: _scannerFocusNode,
            style: TextStyle(fontSize: r.bodySize),
            decoration: InputDecoration(
              hintText: 'Type barcode...',
              hintStyle: TextStyle(
                color: AppColors.textGrey.withOpacity(0.6),
                fontSize: r.bodySize,
              ),
              prefixIcon: Icon(
                Icons.keyboard_rounded,
                color: AppColors.textGrey,
                size: r.iconSize - 2,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  final text = _manualScanController.text.trim();
                  if (text.isNotEmpty) _handleBarcodeScanned(text);
                },
                icon: Icon(
                  Icons.search_rounded,
                  size: r.iconSize - 2,
                  color: AppColors.primaryOrange,
                ),
              ),
              filled: true,
              fillColor: AppColors.backgroundGrey,
              contentPadding: EdgeInsets.symmetric(
                horizontal: r.scale(12, 14),
                vertical: r.scale(10, 12),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.primaryOrange,
                  width: 1.5,
                ),
              ),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) _handleBarcodeScanned(value.trim());
            },
          ),

          // Scan Result
          if (_scannedProduct != null || _scanStatus.isNotEmpty) ...[
            SizedBox(height: r.scale(10, 12)),
            _buildScanResult(r),
          ],
        ],
      ),
    );
  }

  Widget _buildScanResult(BarcodeResponsiveHelper r) {
    final hasProduct = _scannedProduct != null;

    return Container(
      padding: EdgeInsets.all(r.scale(10, 12)),
      decoration: BoxDecoration(
        color: hasProduct
            ? AppColors.purchaseGreenLight.withOpacity(0.4)
            : AppColors.expensesRedLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasProduct
              ? AppColors.purchaseGreen.withOpacity(0.3)
              : AppColors.expensesRed.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                hasProduct
                    ? Icons.check_circle_rounded
                    : Icons.error_outline_rounded,
                size: r.iconSize - 2,
                color: hasProduct
                    ? AppColors.purchaseGreen
                    : AppColors.expensesRed,
              ),
              SizedBox(width: r.scale(6, 8)),
              Expanded(
                child: Text(
                  hasProduct ? 'Product Found' : 'Not Found',
                  style: TextStyle(
                    fontSize: r.bodySize,
                    fontWeight: FontWeight.w600,
                    color: hasProduct
                        ? AppColors.purchaseGreen
                        : AppColors.expensesRed,
                  ),
                ),
              ),
              InkWell(
                onTap: _clearScanResult,
                child: Icon(
                  Icons.close_rounded,
                  size: r.iconSize - 4,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),

          if (hasProduct) ...[
            SizedBox(height: r.scale(8, 10)),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _scannedProduct!.imageUrl,
                    width: r.scale(44, 56),
                    height: r.scale(44, 56),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: r.scale(44, 56),
                      height: r.scale(44, 56),
                      color: Colors.white,
                      child: Icon(
                        Icons.image_rounded,
                        color: AppColors.textGrey,
                        size: r.iconSize,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: r.scale(10, 12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _scannedProduct!.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: r.bodySize,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: r.scale(2, 4)),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: r.scale(6, 8),
                              vertical: r.scale(2, 3),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '\$${_scannedProduct!.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: r.labelSize - 1,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: r.scale(6, 8)),
                          Text(
                            'Stock: ${_scannedProduct!.quantity}',
                            style: TextStyle(
                              fontSize: r.labelSize - 1,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ] else
            Padding(
              padding: EdgeInsets.only(top: r.scale(4, 6)),
              child: Text(
                _scanStatus,
                style: TextStyle(
                  fontSize: r.labelSize,
                  color: AppColors.textGrey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
