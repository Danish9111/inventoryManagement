import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/appColors.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String description,
  String? title,
  List<Widget>? actions,
  Duration duration = const Duration(seconds: 3),
}) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      final topPadding = MediaQuery.of(context).padding.top;

      return Positioned(
        top: topPadding + 30,
        left: 16,
        right: 16,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 220),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, (1 - value) * -10),
                child: child,
              ),
            );
          },
          child: _BlurSnackBarContent(
            title: title,
            description: description,
            actions: actions,
            onClose: () => entry.remove(),
          ),
        ),
      );
    },
  );

  overlay.insert(entry);

  // auto-dismiss
  Future.delayed(duration, () {
    if (entry.mounted) entry.remove();
  });
}

class _BlurSnackBarContent extends StatelessWidget {
  final String description;
  final String? title;
  final List<Widget>? actions;
  final VoidCallback onClose;

  const _BlurSnackBarContent({
    required this.description,
    this.title,
    this.actions,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              // “no color” look – very light glass
              // color: Colors.white.withOpacity(0.08),
              color: AppColors.primaryOrange.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 0.8,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null && title!.isNotEmpty) ...[
                        Text(
                          title!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryOrange.withOpacity(0.9),
                        ),
                      ),
                      if (actions != null && actions!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: actions!,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
