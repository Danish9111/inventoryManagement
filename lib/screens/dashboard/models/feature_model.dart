
import 'package:flutter/material.dart';

/// 🔹 Feature Item Model
class FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color bgColor;
  final int sidebarIndex;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.bgColor,
    required this.sidebarIndex,
  });
}
