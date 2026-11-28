import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A square paper sticky note, slightly rotated, used as a navigation button.
/// The selected note is drawn a little larger and lifted.
class StickyNote extends StatelessWidget {
  const StickyNote({
    super.key,
    required this.label,
    required this.color,
    required this.angleDegrees,
    required this.selected,
    required this.onTap,
    this.size = 112,
  });

  final String label;
  final Color color;
  final double angleDegrees;
  final bool selected;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scale = selected ? 1.08 : 1.0;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 160),
          child: Transform.rotate(
            angle: angleDegrees * math.pi / 180,
            child: Container(
              width: size,
              height: size * 0.86,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.lerp(color, Colors.black, 0.08)!,
                    color,
                    Color.lerp(color, Colors.white, 0.25)!,
                  ],
                  stops: const [0, 0.18, 1],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x55000000),
                    blurRadius: selected ? 14 : 6,
                    offset: Offset(2, selected ? 8 : 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: const Color(0xFF263238),
                    decoration: selected ? TextDecoration.underline : null,
                    decorationColor: const Color(0xFF263238),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
