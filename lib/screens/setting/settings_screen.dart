import 'package:dream_pos/screens/setting/widgets/about.dart';
import 'package:dream_pos/screens/setting/widgets/faqs.dart';
import 'package:dream_pos/screens/setting/widgets/printerSettingUI.dart';
import 'package:dream_pos/screens/setting/widgets/profileUI.dart';
import 'package:dream_pos/screens/setting/widgets/receiptSettingsUI.dart';
import 'package:dream_pos/screens/setting/widgets/security.dart';
import 'package:flutter/material.dart';

import '../../constants/appColors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_snackbar.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Row(
        children: [
          /// LEFT SIDEBAR
          Container(
            width: 220,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(2, 0),
                ),
              ],
              border: const Border(right: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Manage application preferences',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 12),

                /// MENU ITEMS
                _sideItem(Icons.person_outline, 'Profile', 0, islogout: false),
                _sideItem(
                  Icons.print_outlined,
                  'Printer Settings',
                  1,
                  islogout: false,
                ),
                _sideItem(
                  Icons.receipt_long_outlined,
                  'Receipt Settings',
                  2,
                  islogout: false,
                ),
                // _sideItem(Icons.storefront_outlined, 'Shop Details', 3),
                _sideItem(
                  Icons.security_outlined,
                  'Security',
                  3,
                  islogout: false,
                ),
                _sideItem(Icons.security_outlined, 'FAQs', 4, islogout: false),
                _sideItem(Icons.info_outline, 'About App', 5, islogout: false),
                _sideItem(Icons.logout, 'Logout', 6, islogout: true),
              ],
            ),
          ),

          /// RIGHT CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sideItem(
    IconData icon,
    String title,
    int index, {
    bool islogout = false,
  }) {
    final isActive = selectedIndex == index;

    return Consumer(
      builder: (context, ref, _) {
        return InkWell(
          onTap: () async {
            if (islogout) {
              try {
                await ref.read(authProvider.notifier).logout();
              } catch (e) {
                if (context.mounted) {
                  CustomSnackBar.show(
                    context,
                    message: 'Logout failed: $e',
                    isError: true,
                  );
                }
              }
            } else {
              setState(() => selectedIndex = index);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFF1F5FF) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: islogout
                      ? Colors.red
                      : isActive
                      ? AppColors.primaryOrange
                      : Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: islogout
                        ? Colors.red
                        : isActive
                        ? AppColors.primaryOrange
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    switch (selectedIndex) {
      case 0:
        return const ProfileUI();
      case 1:
        return const PrinterSettingsUI();
      case 2:
        return const ReceiptSettingsUI();
      case 3:
        return const SecurityUI();
      case 4:
        return const PosFaqUI();
      case 5:
        return const AboutPosUI();
      default:
        return const SizedBox();
    }
  }
}
