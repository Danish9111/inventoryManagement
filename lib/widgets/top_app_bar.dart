import 'package:dream_pos/screens/barcode/barcode_screen.dart';
import 'package:dream_pos/screens/setting/settings_screen.dart';
import 'package:dream_pos/widgets/appColors.dart';
import 'package:flutter/material.dart';

import '../screens/pos/pos_screen.dart';
import 'add_new_overlay.dart';

class TopAppBar extends StatelessWidget {
  const TopAppBar({super.key, required this.onNavigate});

  final void Function(int, Widget) onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // 🔵 LEFT LOGO
          SizedBox(
            width: 60,
            height: 50,
            child: Image.asset('assets/images/blogo.png'),
          ),

          const SizedBox(width: 16),
          const Spacer(),

          // // 🔍 SEARCH BAR
          // Expanded(
          //   child: SizedBox(
          //     height: 34,
          //     child: TextField(
          //       decoration: InputDecoration(
          //         hintText: 'Search',
          //         hintStyle: TextStyle(color: Colors.grey.shade500),
          //         prefixIcon: const Icon(
          //           Icons.search,
          //           size: 20,
          //           color: Colors.grey,
          //         ),
          //         filled: true,
          //         fillColor: Colors.grey.shade100,
          //         contentPadding: const EdgeInsets.symmetric(vertical: 0),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(12),
          //           borderSide: BorderSide.none,
          //         ),
          //         enabledBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(12),
          //           borderSide: BorderSide.none,
          //         ),
          //         focusedBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(12),
          //           borderSide: BorderSide.none,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(width: 16),

          // 🟠 ADD NEW
          SizedBox(
            child: ElevatedButton.icon(
              onPressed: () {
                AddNewOverlay.show(context, onNavigate);
              },

              icon: const Icon(Icons.add_circle_outline, size: 12),
              label: const Text('Add New'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 10,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 🔵 POS BUTTON
          SizedBox(
            child: OutlinedButton.icon(
              onPressed: () {
                onNavigate(1, const PosScreen()); // 👈 index 1 = POS
              },
              icon: const Icon(Icons.computer, size: 10),
              label: const Text('POS'),
              style: OutlinedButton.styleFrom(
                // backgroundColor: const Color(0xFF0F1E3D),
                foregroundColor: AppColors.primaryBlue,
                side: BorderSide(color: AppColors.primaryBlue, width: 1.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 10,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          Row(
            children: [
              squareIcon(
                icon: Icons.qr_code_scanner_outlined,
                onTap: () {
                  onNavigate(4, const BarcodeScreen()); // 👈 index 4 = Barcode
                },
              ),
              const SizedBox(width: 8),

              // squareIcon(icon: Icons.notifications_none, onTap: () {}),
              // const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  onNavigate(6, const SettingsScreen()); // 👈 index 4 = POS
                },
                child: squareProfileImage(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget squareIcon({
  required IconData icon,
  VoidCallback? onTap,
  Color? color = AppColors.primaryBlue,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F5), // 👈 light grey bg
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: color),
    ),
  );
}

Widget squareProfileImage() {
  return Container(
    width: 50,
    height: 50,
    padding: const EdgeInsets.all(2),
    // subtle spacing like your pic
    // decoration: BoxDecoration(
    //   color: const Color(0xFFF2F3F5),
    //   borderRadius: BorderRadius.circular(10),
    // ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
    ),
  );
}
