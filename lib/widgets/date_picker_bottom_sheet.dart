import 'package:flutter/material.dart';
import '../constants/appColors.dart';

Future<DateTime?> showPosDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String title = 'Select Date',
}) async {
  final media = MediaQuery.of(context);
  DateTime selectedDate = initialDate ?? DateTime.now();

  return await showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    constraints: const BoxConstraints(
      maxWidth: double.infinity, // 🔥 THIS IS THE KEY
    ),
    builder: (_) {
      return Container(
        width: media.size.width,
        height: media.size.height * 0.8,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.close, size: 20, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            /// CALENDAR
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: AppColors.primaryOrange, // selected day
                    onPrimary: AppColors.white,
                    onSurface: AppColors.black,
                  ),
                ),
                child: CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: firstDate ?? DateTime(2000),
                  lastDate: lastDate ?? DateTime(2100),
                  onDateChanged: (date) {
                    selectedDate = date;
                  },
                ),
              ),
            ),

            /// ACTIONS
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 200,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryBlue,
                        side: BorderSide(
                          color: AppColors.primaryBlue.withOpacity(0.4),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, selectedDate);
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
