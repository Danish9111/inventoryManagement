import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  final String? text;
  final int flex;
  final double? width;

  const Cell({super.key, this.text, this.flex = 1, this.width});

  @override
  Widget build(BuildContext context) {
    final child = Text(
      text ?? '',
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    );

    return width != null
        ? SizedBox(width: width, child: child)
        : Expanded(flex: flex, child: child);
  }
}

class ActionIcon extends StatelessWidget {
  final IconData icon;

  const ActionIcon(this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(icon, size: 18), onPressed: () {});
  }
}
