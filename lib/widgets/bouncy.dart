import 'package:flutter/material.dart';

/// Shrinks its child while it is pressed and springs back on release.
class Bouncy extends StatefulWidget {
  const Bouncy({
    super.key,
    required this.child,
    this.enabled = true,
    this.pressedScale = 0.94,
  });

  final Widget child;
  final bool enabled;
  final double pressedScale;

  @override
  State<Bouncy> createState() => _BouncyState();
}

class _BouncyState extends State<Bouncy> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (widget.enabled && mounted && _pressed != pressed) {
      setState(() {
        _pressed = pressed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1.0,
        duration: _pressed
            ? const Duration(milliseconds: 90)
            : const Duration(milliseconds: 500),
        curve: _pressed ? Curves.easeOut : Curves.elasticOut,
        child: widget.child,
      ),
    );
  }
}
