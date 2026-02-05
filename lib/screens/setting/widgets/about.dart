import 'package:flutter/material.dart';
import 'package:dream_pos/constants/appColors.dart';

class AboutPosUI extends StatelessWidget {
  const AboutPosUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _heroHeader(), // 🔒 unchanged
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  children: [
                    _infoRow(
                      icon: Icons.info_outline,
                      title: 'About Dream POS',
                      description:
                          'A modern point-of-sale system designed for fast billing, '
                          'reliable performance, and smooth daily operations on tablet devices.',
                    ),

                    _divider(),

                    _infoRow(
                      icon: Icons.flash_on_outlined,
                      title: 'Built for speed',
                      description:
                          'Optimized workflows ensure quick billing and reduced checkout time.',
                    ),

                    _infoRow(
                      icon: Icons.print_outlined,
                      title: 'Printer ready',
                      description:
                          'Works seamlessly with Bluetooth receipt printers (58mm & 80mm).',
                    ),

                    _infoRow(
                      icon: Icons.cloud_off_outlined,
                      title: 'Offline capable',
                      description:
                          'Continue billing even without internet connectivity.',
                    ),

                    _infoRow(
                      icon: Icons.touch_app_outlined,
                      title: 'Tablet optimized',
                      description:
                          'Designed specifically for landscape tablet usage in stores.',
                    ),

                    _divider(),

                    _metaRow(
                      icon: Icons.support_agent_outlined,
                      label: 'Support',
                      value: 'support@mail.com',
                    ),
                    _metaRow(
                      icon: Icons.phone_outlined,
                      label: 'Contact',
                      value: '+1 234 567 8900',
                    ),
                    _metaRow(
                      icon: Icons.system_update_outlined,
                      label: 'Version',
                      value: '1.0.0',
                    ),

                    const SizedBox(height: 28),

                    _footer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────── HERO HEADER ─────────────────
  // ❗ UNCHANGED – keep your existing hero header code here
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
                'Dream POS',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 4),
              Text(
                'Professional Point of Sale System',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ───────────────── INFO ROW ─────────────────

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.primaryOrange),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── META ROW ─────────────────

  Widget _metaRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── DIVIDER ─────────────────

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(height: 1, color: Colors.black.withOpacity(0.08)),
    );
  }

  // ───────────────── FOOTER ─────────────────

  Widget _footer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Divider(height: 1),
        SizedBox(height: 12),
        Text(
          '© 2026 Dreem POS Ltd. All rights reserved. ',
          style: TextStyle(fontSize: 12, color: Colors.black45),
        ),
      ],
    );
  }
}
