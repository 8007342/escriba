import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// A metal spiral spring binding running down the left edge of the notepad.
///
/// The painter's box straddles the paper's left edge: [paperEdgeX] is where
/// the paper starts inside this box. Each coil is a punched hole in the paper
/// plus a chrome wire loop that wraps from behind the pad, over the edge and
/// into the hole.
class SpiralPainter extends CustomPainter {
  const SpiralPainter({
    this.paperEdgeX = 18,
    this.pitch = 26,
    this.holeRadius = 4.5,
  });

  final double paperEdgeX;
  final double pitch;
  final double holeRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final holeX = paperEdgeX + 14;
    final count = ((size.height - pitch) / pitch).floor();
    final startY = (size.height - (count - 1) * pitch) / 2;

    for (var i = 0; i < count; i++) {
      final y = startY + i * pitch;
      _paintHole(canvas, Offset(holeX, y));
      _paintCoil(canvas, holeX, y);
    }
  }

  void _paintHole(Canvas canvas, Offset c) {
    canvas.drawCircle(c, holeRadius + 1, Paint()..color = const Color(0x33000000));
    canvas.drawCircle(c, holeRadius, Paint()..color = const Color(0xFF5D4632));
  }

  void _paintCoil(Canvas canvas, double holeX, double y) {
    // The wire loop: from the hole, out over the left edge, and back behind.
    final left = 2.0;
    final rect = Rect.fromLTRB(left, y - pitch * 0.42, holeX + 1, y + pitch * 0.18);

    final shadow = Path()..addArc(rect.shift(const Offset(1.5, 2)), math.pi * 0.55, math.pi * 1.35);
    canvas.drawPath(
      shadow,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = const Color(0x40000000),
    );

    final wire = Path()..addArc(rect, math.pi * 0.55, math.pi * 1.35);
    canvas.drawPath(
      wire,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.6
        ..strokeCap = StrokeCap.round
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6E737A), Color(0xFFF4F6F8), Color(0xFF9AA0A6), Color(0xFF4A4F55)],
          stops: [0, 0.35, 0.65, 1],
        ).createShader(rect),
    );

    // Specular highlight along the top of the loop.
    final highlight = Path()..addArc(rect.deflate(1), math.pi * 1.15, math.pi * 0.45);
    canvas.drawPath(
      highlight,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xCCFFFFFF),
    );
  }

  @override
  bool shouldRepaint(SpiralPainter oldDelegate) =>
      oldDelegate.paperEdgeX != paperEdgeX ||
      oldDelegate.pitch != pitch ||
      oldDelegate.holeRadius != holeRadius;
}
