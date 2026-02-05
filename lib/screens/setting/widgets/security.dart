import 'package:flutter/material.dart';
import 'package:dream_pos/constants/appColors.dart';
import 'package:dream_pos/widgets/customButtons.dart';
import 'package:dream_pos/screens/products/widgets/product_text_field.dart';

class SecurityUI extends StatefulWidget {
  const SecurityUI({super.key});

  @override
  State<SecurityUI> createState() => _SecurityUIState();
}

class _SecurityUIState extends State<SecurityUI> {
  bool enablePin = true;
  bool autoLock = true;
  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  String autoLockTime = '5 minutes';

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
                // 🔥 HERO HEADER (unchanged pattern)
                _heroHeader(),

                // 🔽 BODY
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Password'),
                      const SizedBox(height: 12),

                      ProductTextField(
                        label: 'Current password',
                        controller: TextEditingController(),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !showCurrentPassword,
                        suffixIcon: showCurrentPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onTap: () {
                          setState(() {
                            showCurrentPassword = !showCurrentPassword;
                          });
                        },
                      ),

                      const SizedBox(height: 12),
                      ProductTextField(
                        label: 'New password',
                        controller: TextEditingController(),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !showNewPassword,
                        suffixIcon: showNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onTap: () {
                          setState(() {
                            showNewPassword = !showNewPassword;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      ProductTextField(
                        label: 'Confirm password',
                        controller: TextEditingController(),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !showConfirmPassword,
                        suffixIcon: showConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onTap: () {
                          setState(() {
                            showConfirmPassword = !showConfirmPassword;
                          });
                        },
                      ),

                      const SizedBox(height: 32),
                      _sectionTitle('POS lock & access'),
                      const SizedBox(height: 12),

                      _toggleTile(
                        title: 'Enable PIN lock',
                        subtitle:
                            'Require a PIN to access the POS after inactivity',
                        value: enablePin,
                        onChanged: (v) => setState(() => enablePin = v),
                      ),

                      _toggleTile(
                        title: 'Auto lock POS',
                        subtitle: 'Automatically lock the POS when not in use',
                        value: autoLock,
                        onChanged: (v) => setState(() => autoLock = v),
                      ),

                      const SizedBox(height: 12),
                      _dropdownTile(
                        title: 'Auto lock time',
                        value: autoLockTime,
                        options: const [
                          '1 minute',
                          '5 minutes',
                          '10 minutes',
                          '30 minutes',
                        ],
                        onChanged: (v) => setState(() => autoLockTime = v),
                      ),

                      const SizedBox(height: 32),
                      _sectionTitle('Session info'),
                      const SizedBox(height: 12),

                      _infoRow(label: 'Last login', value: 'Today, 10:24 AM'),
                      _infoRow(label: 'Device', value: 'Android Tablet'),
                      _infoRow(label: 'Location', value: 'Store terminal'),

                      const SizedBox(height: 40),

                      Row(
                        children: [
                          const Spacer(),
                          CustomElevatedButton(
                            text: 'Save changes',
                            onPressed: () {},
                            width: 160,
                            height: 40,
                            textSize: 14,
                          ),
                        ],
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

  // ───────────────── HERO HEADER ─────────────────

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
                'Security',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 4),
              Text(
                'Protect access to your POS system',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ───────────────── HELPERS ─────────────────

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    );
  }

  Widget _toggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppColors.primaryOrange,
            inactiveThumbColor: Colors.black,
            inactiveTrackColor: Colors.white,
            activeTrackColor: AppColors.white,
            onChanged: onChanged,
            trackOutlineColor: MaterialStateProperty.all(
              Colors.black.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownTile({
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            items: options
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => onChanged(v!),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
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
}
