import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that listens for hardware barcode scanner input.
///
/// Hardware scanners work like keyboards - they rapidly "type" the barcode
/// and then press Enter. This widget detects that pattern and fires
/// [onBarcodeScanned] with the scanned value.
class HardwareScannerListener extends StatefulWidget {
  final Widget child;
  final void Function(String barcode) onBarcodeScanned;
  final Duration scanTimeout;
  final bool enabled;

  const HardwareScannerListener({
    super.key,
    required this.child,
    required this.onBarcodeScanned,
    this.scanTimeout = const Duration(milliseconds: 100),
    this.enabled = true,
  });

  @override
  State<HardwareScannerListener> createState() =>
      _HardwareScannerListenerState();
}

class _HardwareScannerListenerState extends State<HardwareScannerListener> {
  final StringBuffer _buffer = StringBuffer();
  DateTime? _lastKeyTime;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!widget.enabled) return;

    // Only handle key down events
    if (event is! KeyDownEvent) return;

    final now = DateTime.now();
    final character = event.character;

    // Check for Enter key (submit the barcode)
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      if (_buffer.isNotEmpty) {
        final barcode = _buffer.toString().trim();

        // Validate it looks like scanner input (rapid, multiple chars)
        if (barcode.length >= 4) {
          widget.onBarcodeScanned(barcode);
        }

        _resetBuffer();
      }
      return;
    }

    // Add printable characters to buffer
    if (character != null && character.isNotEmpty) {
      // Check if this is rapid input (likely scanner)
      if (_lastKeyTime != null) {
        final timeSinceLastKey = now.difference(_lastKeyTime!);

        // If too slow, might be manual typing - reset buffer
        if (timeSinceLastKey > widget.scanTimeout && _buffer.length > 2) {
          _resetBuffer();
        }
      }

      _buffer.write(character);
      _lastKeyTime = now;

      // Reset timer
      _resetTimer?.cancel();
      _resetTimer = Timer(const Duration(milliseconds: 300), _resetBuffer);
    }
  }

  void _resetBuffer() {
    _buffer.clear();
    _lastKeyTime = null;
    _resetTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: widget.child,
    );
  }
}

/// Simpler version - wraps a TextField to detect scanner input
class ScannerTextField extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(String barcode)? onBarcodeScanned;
  final InputDecoration? decoration;
  final bool autofocus;
  final FocusNode? focusNode;

  const ScannerTextField({
    super.key,
    this.controller,
    this.onBarcodeScanned,
    this.decoration,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  State<ScannerTextField> createState() => _ScannerTextFieldState();
}

class _ScannerTextFieldState extends State<ScannerTextField> {
  late TextEditingController _controller;
  DateTime? _lastInputTime;
  String _lastValue = '';

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value) {
    final now = DateTime.now();
    final addedChars = value.length - _lastValue.length;

    // Scanner typically adds many characters at once
    if (addedChars > 3 && _lastInputTime != null) {
      final timeDiff = now.difference(_lastInputTime!);
      if (timeDiff.inMilliseconds < 100) {
        // Rapid multi-char input - likely scanner
        // Wait for input to complete, then fire callback
        Future.delayed(const Duration(milliseconds: 150), () {
          if (_controller.text.isNotEmpty && widget.onBarcodeScanned != null) {
            widget.onBarcodeScanned!(_controller.text);
          }
        });
      }
    }

    _lastValue = value;
    _lastInputTime = now;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onChanged: _onChanged,
      onSubmitted: widget.onBarcodeScanned,
      decoration: widget.decoration,
    );
  }
}
