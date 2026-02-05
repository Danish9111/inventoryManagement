import 'package:flutter/material.dart';
import 'package:dream_pos/constants/appColors.dart';

class PosFaqUI extends StatefulWidget {
  const PosFaqUI({super.key});

  @override
  State<PosFaqUI> createState() => _PosFaqUIState();
}

class _PosFaqUIState extends State<PosFaqUI> {
  int? openIndex;

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
                // 🔥 EDGE-TO-EDGE HEADER (NO PADDING)
                _heroHeader(),

                // 🔽 PADDED CONTENT ONLY
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        icon: Icons.play_circle_outline,
                        title: 'Getting started',
                      ),
                      _faqTile(
                        index: 0,
                        question: 'What is this POS system?',
                        answer:
                            'This POS system helps you manage sales, payments, receipts, and inventory from a single screen. '
                            'It is designed for fast billing and easy daily operations.',
                      ),
                      _faqTile(
                        index: 1,
                        question: 'Who should use this POS?',
                        answer:
                            'Cashiers, store managers, and business owners can use this POS. Minimal training is required.',
                      ),

                      const SizedBox(height: 24),
                      _sectionHeader(
                        icon: Icons.payment_outlined,
                        title: 'Billing & payments',
                      ),
                      _faqTile(
                        index: 2,
                        question: 'How do I create a bill?',
                        answer:
                            'Add items to the cart, select the payment method, and complete the payment.',
                      ),
                      _faqTile(
                        index: 3,
                        question: 'Which payment methods are supported?',
                        answer:
                            'Cash, card, UPI, and other digital payment methods supported by your setup.',
                      ),

                      const SizedBox(height: 24),
                      _sectionHeader(
                        icon: Icons.print_outlined,
                        title: 'Receipts & printing',
                      ),
                      _faqTile(
                        index: 4,
                        question: 'How do I print a receipt?',
                        answer:
                            'Receipts are printed automatically after payment if auto-print is enabled.',
                      ),
                      _faqTile(
                        index: 5,
                        question: 'Can I customize receipt details?',
                        answer:
                            'Yes. Shop name, tax details, footer message, and logo visibility can be customized.',
                      ),

                      const SizedBox(height: 24),
                      _sectionHeader(
                        icon: Icons.bluetooth_outlined,
                        title: 'Printers & Bluetooth',
                      ),
                      _faqTile(
                        index: 6,
                        question: 'How do I connect a Bluetooth printer?',
                        answer:
                            'Go to Printer & Bluetooth Settings, scan for devices, and select your printer.',
                      ),
                      _faqTile(
                        index: 7,
                        question: 'What paper sizes are supported?',
                        answer:
                            '58mm and 80mm thermal receipt paper sizes are supported.',
                      ),

                      const SizedBox(height: 24),
                      _sectionHeader(
                        icon: Icons.rule_outlined,
                        title: 'Best practice guidelines',
                      ),
                      _faqTile(
                        index: 8,
                        question: 'Do I need internet to use the POS?',
                        answer:
                            'Basic billing works offline. Internet is required for syncing and updates.',
                      ),
                      _faqTile(
                        index: 9,
                        question: 'What should I do if printing fails?',
                        answer:
                            'Check printer power, paper, Bluetooth connection, and retry test print.',
                      ),
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                'FAQs & Guidelines',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 4),
              Text(
                'Quick help for daily POS operations',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ───────────────── SECTION HEADER ─────────────────

  Widget _sectionHeader({required IconData icon, required String title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryOrange),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  // ───────────────── FAQ TILE ─────────────────

  Widget _faqTile({
    required int index,
    required String question,
    required String answer,
  }) {
    final bool isOpen = openIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          openIndex = isOpen ? null : index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isOpen
              ? AppColors.primaryOrange.withOpacity(0.08)
              : Colors.black.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: isOpen
              ? Border.all(color: AppColors.primaryOrange, width: 1)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.primaryOrange,
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  answer,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
              crossFadeState: isOpen
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}
