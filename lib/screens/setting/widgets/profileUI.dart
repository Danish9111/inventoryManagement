import 'package:dream_pos/screens/products/widgets/product_text_field.dart';
import 'package:dream_pos/constants/appColors.dart';
import 'package:flutter/material.dart';

import '../../../widgets/customButtons.dart';

class ProfileUI extends StatelessWidget {
  const ProfileUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 HERO HEADER (edge to edge)
            _heroHeader(),

            // 🔽 CONTENT AREA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PROFILE IMAGE
                  _avatarSection(),

                  const SizedBox(height: 40),

                  /// FORM
                  _sectionTitle('Basic Information'),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: ProductTextField(
                          label: 'First Name',
                          controller: TextEditingController(),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ProductTextField(
                          label: 'Last Name',
                          controller: TextEditingController(),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ProductTextField(
                          label: 'Username',
                          controller: TextEditingController(),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ProductTextField(
                          label: 'Email',
                          controller: TextEditingController(),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  ProductTextField(
                    label: 'Phone Number',
                    controller: TextEditingController(),
                    keyboardType: TextInputType.text,
                  ),

                  const SizedBox(height: 48),

                  /// ACTIONS
                  _actionBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────── HEADER ─────────────────

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage your personal account details',
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppColors.black.withOpacity(0.55),
              ),
            ),
          ],
        ),
        Icon(
          Icons.account_circle_outlined,
          size: 30,
          color: AppColors.primaryBlue.withOpacity(0.45),
        ),
      ],
    );
  }

  // ───────────────── AVATAR ─────────────────

  Widget _avatarSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(
              Icons.person_outline,
              size: 36,
              color: Colors.black.withOpacity(0.6),
            ),
          ),

          const SizedBox(width: 20),

          // Name + info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile photo',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Used across receipts and account settings',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          // Action
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryOrange,
              side: BorderSide(color: AppColors.primaryOrange.withOpacity(0.4)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Change photo',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── FORM HELPERS ─────────────────

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryBlue.withOpacity(0.9),
        letterSpacing: 0.3,
      ),
    );
  }

  // ───────────────── ACTION BAR ─────────────────

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
                'Profile',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 4),
              Text(
                'Manage your personal account details',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBar() {
    return Row(
      children: [
        const Spacer(),
        CustomElevatedButton(
          text: 'Save Changes',
          onPressed: () {},
          width: 155,
          height: 40,
          textSize: 14,
        ),
      ],
    );
  }
}
