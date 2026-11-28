import 'package:flutter/material.dart';

import 'paper_painter.dart';
import 'spiral_painter.dart';

/// A spiral-bound notepad lying on the desk. [child] is laid out inside the
/// writing area: right of the red margin and below the header band.
class Notepad extends StatelessWidget {
  const Notepad({super.key, required this.child, this.metrics = const PaperMetrics()});

  final Widget child;
  final PaperMetrics metrics;

  /// How far the spiral sticks out to the left of the paper.
  static const spiralOverhang = 18.0;
  static const _spiralWidth = spiralOverhang + 24;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: spiralOverhang),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Paper with a soft shadow on the wood.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                boxShadow: const [
                  BoxShadow(color: Color(0x66000000), blurRadius: 18, offset: Offset(4, 8)),
                  BoxShadow(color: Color(0x33000000), blurRadius: 3, offset: Offset(1, 1)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: RepaintBoundary(
                  child: CustomPaint(painter: PaperPainter(metrics: metrics)),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.fromLTRB(metrics.marginX + 16, 20, 24, 16),
              child: child,
            ),
          ),
          Positioned(
            left: -spiralOverhang,
            top: 0,
            bottom: 0,
            width: _spiralWidth,
            child: const IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(painter: SpiralPainter(paperEdgeX: spiralOverhang)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
