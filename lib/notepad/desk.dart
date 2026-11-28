import 'package:flutter/material.dart';

import '../app/section.dart';
import 'notepad.dart';
import 'pages.dart';
import 'sticky_note.dart';
import 'wood_painter.dart';

/// The whole screen: a wooden desk with the notepad on it and sticky notes as
/// the navigation menu.
///
/// Landscape (tablets, primary): notes stacked down the right-hand side.
/// Portrait (phones): notes in a row above the notepad.
class Desk extends StatefulWidget {
  const Desk({super.key});

  @override
  State<Desk> createState() => _DeskState();
}

class _DeskState extends State<Desk> {
  Section _section = Section.practice;

  // Fixed, slightly irregular tilts so the notes look hand-placed.
  static const _tilts = <double>[-4, 3, -2, 4.5, -3];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: RepaintBoundary(child: CustomPaint(painter: WoodPainter())),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final landscape = constraints.maxWidth >= constraints.maxHeight;
                return landscape ? _landscape(constraints) : _portrait(constraints);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _notepad() {
    return Notepad(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: SectionPage(key: ValueKey(_section), section: _section),
      ),
    );
  }

  List<Widget> _notes(double size) {
    return [
      for (final s in Section.values)
        StickyNote(
          key: Key('note-${s.name}'),
          label: s.label,
          color: s.color,
          angleDegrees: _tilts[s.index % _tilts.length],
          selected: s == _section,
          size: size,
          onTap: () => setState(() => _section = s),
        ),
    ];
  }

  Widget _landscape(BoxConstraints c) {
    final noteSize = (c.maxHeight / (Section.values.length * 1.05)).clamp(72.0, 128.0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 12, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _notepad()),
          const SizedBox(width: 20),
          SizedBox(
            width: noteSize + 24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _notes(noteSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _portrait(BoxConstraints c) {
    final noteSize = ((c.maxWidth - 32) / (Section.values.length * 1.12)).clamp(60.0, 112.0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: noteSize + 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _notes(noteSize),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: _notepad()),
        ],
      ),
    );
  }
}
