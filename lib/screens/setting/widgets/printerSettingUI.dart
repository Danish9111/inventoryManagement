import 'package:dream_pos/widgets/customDropDown.dart';
import 'package:flutter/material.dart';

import '../../../widgets/appColors.dart';

class PrinterSettingsUI extends StatefulWidget {
  const PrinterSettingsUI({super.key});

  @override
  State<PrinterSettingsUI> createState() => _PrinterSettingsUIState();
}

class _PrinterSettingsUIState extends State<PrinterSettingsUI> {
  // ───────────────── STATE ─────────────────

  final List<String> printers = [
    'Bluetooth Printer 1 (58mm)',
    'Bluetooth Printer 2 (80mm)',
  ];

  String? defaultPrinter;
  String? kitchenPrinter;
  String paperSize = '58mm';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔥 EDGE-TO-EDGE HERO HEADER
                _heroHeader(),

                // 🔽 PADDED BODY ONLY
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropdown(
                        label: 'Default printer',
                        hintText: 'Select default printer',
                        options: printers,
                        value: defaultPrinter,
                        onChanged: (value) {
                          setState(() => defaultPrinter = value);
                        },
                      ),
                      const SizedBox(height: 24),

                      CustomDropdown(
                        label: 'Kitchen printer',
                        hintText: 'Select kitchen printer',
                        options: printers,
                        value: kitchenPrinter,
                        onChanged: (value) {
                          setState(() => kitchenPrinter = value);
                        },
                      ),
                      const SizedBox(height: 28),

                      _paperSizeSelector(),
                      const SizedBox(height: 32),

                      _testPrintButton(),

                      const SizedBox(height: 36),
                      const Divider(height: 1),
                      const SizedBox(height: 28),

                      _sectionTitle('Bluetooth devices'),
                      const SizedBox(height: 16),

                      _scanButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────── HEADER ─────────────────

  Widget _heroHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryOrange.withOpacity(0.12),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/blogo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Printer & Bluetooth',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 4),
              Text(
                'Manage receipt printers and Bluetooth connections',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }



  // ───────────────── PAPER SIZE ─────────────────

  Widget _paperSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Receipt paper size'),
        const SizedBox(height: 12),
        Row(
          children: [
            _radioOption('58mm'),
            const SizedBox(width: 24),
            _radioOption('80mm'),
          ],
        ),
      ],
    );
  }

  Widget _radioOption(String value) {
    final bool selected = paperSize == value;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() => paperSize = value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryOrange.withOpacity(0.1)
              : Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
          border: selected
              ? Border.all(color: AppColors.primaryOrange, width: 1.2)
              : null,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              activeColor: AppColors.primaryOrange,
              fillColor: MaterialStateProperty.all(AppColors.primaryOrange),
              groupValue: paperSize,
              onChanged: (v) {
                setState(() => paperSize = v!);
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primaryOrange : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────── ACTIONS ─────────────────

  Widget _testPrintButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          debugPrint(
            'Test print → Printer: $defaultPrinter, Paper: $paperSize',
          );
        },
        icon: const Icon(Icons.print_outlined, size: 20),
        label: const Text(
          'Test print',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _scanButton() {
    return SizedBox(
      height: 48,
      child: TextButton(
        onPressed: () {
          debugPrint('Scanning for Bluetooth devices...');
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.purple.withOpacity(0.1),
          foregroundColor: AppColors.primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Scan for devices',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ───────────────── HELPERS ─────────────────

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }


  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }
}
