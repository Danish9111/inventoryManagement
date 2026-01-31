import 'dart:ui';

import 'package:flutter/material.dart';

/// 🔹 Feature Item Model
class FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color bgColor;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.bgColor,
  });
}
