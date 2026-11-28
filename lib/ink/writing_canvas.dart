import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

/// The writing area on the Practice page.
///
/// Why Flame here (and only here): the writing surface will grow into a
/// real-time scene — live ink with pressure, guide glyphs, stroke-order
/// animations, feedback effects — which is what a game loop and component
/// tree are good at. The surrounding chrome (desk, notepad, sticky notes) is
/// static layout and stays plain Flutter widgets, which are simpler, give us
/// accessibility semantics and respond to layout changes for free.
class WritingCanvas extends StatefulWidget {
  const WritingCanvas({super.key});

  @override
  State<WritingCanvas> createState() => _WritingCanvasState();
}

class _WritingCanvasState extends State<WritingCanvas> {
  // Created once per page so rebuilds don't reset the ink.
  final InkGame _game = InkGame();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0x553E6FB0), width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: GameWidget<InkGame>(game: _game),
      ),
    );
  }
}

/// Placeholder ink game: one layer that records drags as polylines.
/// Real stroke capture (pointer kind, pressure, tilt, timing, resampling)
/// will replace [StrokeLayer].
class InkGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    await add(StrokeLayer());
  }
}

/// Collects strokes from drag events and paints them as ink.
class StrokeLayer extends PositionComponent with DragCallbacks, HasGameReference<InkGame> {
  final List<List<Vector2>> strokes = [];
  final Map<int, Vector2> _cursors = {};
  final Map<int, List<Vector2>> _active = {};

  static final Paint _ink = Paint()
    ..color = const Color(0xFF1A2F6B)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    final p = event.localPosition.clone();
    final stroke = <Vector2>[p.clone()];
    _cursors[event.pointerId] = p;
    _active[event.pointerId] = stroke;
    strokes.add(stroke);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final cursor = _cursors[event.pointerId];
    final stroke = _active[event.pointerId];
    if (cursor == null || stroke == null) return;
    cursor.add(event.localDelta);
    stroke.add(cursor.clone());
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _cursors.remove(event.pointerId);
    _active.remove(event.pointerId);
  }

  @override
  void render(Canvas canvas) {
    for (final stroke in strokes) {
      if (stroke.length == 1) {
        canvas.drawCircle(stroke.first.toOffset(), 1.5, _ink);
        continue;
      }
      final path = Path()..moveTo(stroke.first.x, stroke.first.y);
      for (final p in stroke.skip(1)) {
        path.lineTo(p.x, p.y);
      }
      canvas.drawPath(path, _ink);
    }
  }
}
