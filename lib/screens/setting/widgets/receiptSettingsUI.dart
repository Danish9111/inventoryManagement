import 'package:flutter/material.dart';
import 'package:dream_pos/widgets/appColors.dart';

class ReceiptSettingsUI extends StatefulWidget {
  const ReceiptSettingsUI({super.key});

  @override
  State<ReceiptSettingsUI> createState() => _ReceiptSettingsUIState();
}

class _ReceiptSettingsUIState extends State<ReceiptSettingsUI> {
  // ───────────────── CONTROLLERS ─────────────────

  final TextEditingController shopNameCtrl =
  TextEditingController(text: 'My Retail Shop');

  final TextEditingController addressCtrl =
  TextEditingController(text: '123 Main Street, City, State - 123456');

  final TextEditingController phoneCtrl =
  TextEditingController(text: '+1 234 567 8900');

  final TextEditingController taxCtrl =
  TextEditingController(text: '22AAAAA0000A1Z5');

  final TextEditingController footerCtrl =
  TextEditingController(text: 'Thank you for your business!');

  // ───────────────── OPTIONS ─────────────────

  bool showLogo = true;
  bool showBarcode = true;
  bool showTaxBreakdown = true;
  bool autoPrint = false;

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
                      _input(
                        label: 'Shop name',
                        controller: shopNameCtrl,
                      ),
                      const SizedBox(height: 20),

                      _input(
                        label: 'Shop address',
                        controller: addressCtrl,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),

                      _input(
                        label: 'Contact number',
                        controller: phoneCtrl,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),

                      _input(
                        label: 'Tax ID / GST number',
                        controller: taxCtrl,
                      ),
                      const SizedBox(height: 28),

                      _input(
                        label: 'Footer message',
                        controller: footerCtrl,
                      ),

                      const SizedBox(height: 32),
                      const Divider(height: 1),
                      const SizedBox(height: 24),

                      _sectionTitle('Display options'),
                      const SizedBox(height: 16),

                      _checkbox(
                        label: 'Show logo on receipt',
                        value: showLogo,
                        onChanged: (v) => setState(() => showLogo = v),
                      ),
                      _checkbox(
                        label: 'Show barcode',
                        value: showBarcode,
                        onChanged: (v) => setState(() => showBarcode = v),
                      ),
                      _checkbox(
                        label: 'Show tax breakdown',
                        value: showTaxBreakdown,
                        onChanged: (v) =>
                            setState(() => showTaxBreakdown = v),
                      ),
                      _checkbox(
                        label: 'Auto-print after payment',
                        value: autoPrint,
                        onChanged: (v) => setState(() => autoPrint = v),
                      ),

                      const SizedBox(height: 32),
                      _saveButton(),
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
                'Receipt settings',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 4),
              Text(
                'Customize receipt information and display options',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }


  // ───────────────── INPUT ─────────────────

  Widget _input({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black.withOpacity(0.03),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────── CHECKBOX ─────────────────

  Widget _checkbox({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: AppColors.primaryOrange,
      value: value,
      onChanged: (v) => onChanged(v!),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ───────────────── ACTION ─────────────────

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          debugPrint('Receipt settings saved');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Save changes',
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
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
