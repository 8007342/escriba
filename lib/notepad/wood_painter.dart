import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Paints a wooden desktop procedurally: horizontal planks with a warm base
/// tone, wavy grain lines, a few knots and dark seams between planks. The
/// pattern is seeded, so it is identical on every repaint.
class WoodPainter extends CustomPainter {
  const WoodPainter({this.seed = 7, this.plankHeight = 180});

  final int seed;
  final double plankHeight;

  static const _plankTones = <Color>[
    Color(0xFF8B5A2B),
    Color(0xFF7A4E26),
    Color(0xFF94633A),
    Color(0xFF835330),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final plankCount = (size.height / plankHeight).ceil() + 1;

    for (var p = 0; p < plankCount; p++) {
      final top = p * plankHeight;
      final rect = Rect.fromLTWH(0, top, size.width, plankHeight);
      final tone = _plankTones[p % _plankTones.length];

      canvas.drawRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.lerp(tone, const Color(0xFFFFFFFF), 0.06)!,
              tone,
              Color.lerp(tone, const Color(0xFF000000), 0.12)!,
            ],
          ).createShader(rect),
      );

      canvas.save();
      canvas.clipRect(rect);
      _paintGrain(canvas, rect, tone, rnd);
      _paintKnots(canvas, rect, rnd);
      canvas.restore();

      // Seam between planks.
      canvas.drawLine(
        Offset(0, top),
        Offset(size.width, top),
        Paint()
          ..color = const Color(0xAA2E1A0B)
          ..strokeWidth = 2,
      );
      canvas.drawLine(
        Offset(0, top + 2),
        Offset(size.width, top + 2),
        Paint()
          ..color = const Color(0x22FFFFFF)
          ..strokeWidth = 1,
      );
    }
  }

  void _paintGrain(Canvas canvas, Rect rect, Color tone, math.Random rnd) {
    final lines = 26 + rnd.nextInt(10);
    for (var i = 0; i < lines; i++) {
      final baseY = rect.top + rnd.nextDouble() * rect.height;
      final amp = 2 + rnd.nextDouble() * 7;
      final wave = 120 + rnd.nextDouble() * 380;
      final phase = rnd.nextDouble() * math.pi * 2;
      final dark = rnd.nextBool();
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6 + rnd.nextDouble() * 1.6
        ..color = dark
            ? Color.lerp(tone, const Color(0xFF2B160A), 0.35 + rnd.nextDouble() * 0.3)!
                .withValues(alpha: 0.55)
            : Color.lerp(tone, const Color(0xFFFFE0B2), 0.2 + rnd.nextDouble() * 0.2)!
                .withValues(alpha: 0.35);

      final path = Path()..moveTo(rect.left, baseY);
      for (var x = rect.left; x <= rect.right + 8; x += 8) {
        final y = baseY +
            math.sin(x / wave * math.pi * 2 + phase) * amp +
            math.sin(x / (wave * 0.37) + phase * 1.7) * amp * 0.3;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  void _paintKnots(Canvas canvas, Rect rect, math.Random rnd) {
    final knots = rnd.nextInt(3);
    for (var k = 0; k < knots; k++) {
      final c = Offset(
        rect.left + rnd.nextDouble() * rect.width,
        rect.top + rect.height * (0.25 + rnd.nextDouble() * 0.5),
      );
      final rx = 10 + rnd.nextDouble() * 16;
      for (var ring = 4; ring >= 0; ring--) {
        final s = 1 + ring * 0.55;
        canvas.drawOval(
          Rect.fromCenter(center: c, width: rx * 2 * s, height: rx * 0.9 * s),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2
            ..color = const Color(0xFF3B200D).withValues(alpha: 0.12 + 0.08 * (4 - ring)),
        );
      }
      canvas.drawOval(
        Rect.fromCenter(center: c, width: rx * 1.2, height: rx * 0.5),
        Paint()..color = const Color(0xFF3B200D).withValues(alpha: 0.55),
      );
    }
  }

  @override
  bool shouldRepaint(WoodPainter oldDelegate) =>
      oldDelegate.seed != seed || oldDelegate.plankHeight != plankHeight;
}
