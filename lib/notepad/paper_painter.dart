import 'package:flutter/widgets.dart';

/// Geometry shared by the paper painter and the content laid over it, so text
/// can sit on the ruled lines.
class PaperMetrics {
  const PaperMetrics({
    this.lineSpacing = 32,
    this.headerHeight = 72,
    this.marginX = 72,
  });

  /// Distance between ruled lines.
  final double lineSpacing;

  /// Blank band at the top of the page before the first ruled line.
  final double headerHeight;

  /// Distance from the paper's left edge to the red margin line.
  final double marginX;
}

/// White ruled paper: thin light-blue horizontal lines and one red vertical
/// margin line on the left.
class PaperPainter extends CustomPainter {
  const PaperPainter({this.metrics = const PaperMetrics()});

  final PaperMetrics metrics;

  static const paperColor = Color(0xFFFFFEFA);
  static const ruleColor = Color(0xFFA9C8EC);
  static const marginColor = Color(0xFFE57373);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = paperColor);

    final rule = Paint()
      ..color = ruleColor
      ..strokeWidth = 1;
    for (var y = metrics.headerHeight; y < size.height - 8; y += metrics.lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), rule);
    }

    final margin = Paint()
      ..color = marginColor
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(metrics.marginX, 0),
      Offset(metrics.marginX, size.height),
      margin,
    );
  }

  @override
  bool shouldRepaint(PaperPainter oldDelegate) => oldDelegate.metrics != metrics;
}
