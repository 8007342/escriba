import 'package:flutter/material.dart';

import '../app/section.dart';
import '../ink/writing_canvas.dart';
import '../lessons/lesson.dart';

/// Placeholder content for each section, written onto the notepad.
class SectionPage extends StatelessWidget {
  const SectionPage({super.key, required this.section});

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.label,
          key: const Key('page-title'),
          style: const TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A3A6B),
          ),
        ),
        const SizedBox(height: 18),
        Expanded(child: _body()),
      ],
    );
  }

  Widget _body() {
    switch (section) {
      case Section.practice:
        return const _Practice();
      case Section.alphabets:
        return ListView(
          children: [
            for (final a in sampleAlphabets)
              _Line('${a.name} — ${a.sample}'),
          ],
        );
      case Section.languages:
        return ListView(
          children: [
            for (final a in sampleAlphabets) _Line(a.language),
          ],
        );
      case Section.progress:
        return const _Line('No practice yet. Your progress will show here.');
      case Section.settings:
        return const _Line('Settings will live here (hand, pen, sounds).');
    }
  }
}

class _Practice extends StatelessWidget {
  const _Practice();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Line('Write here with your pen or finger:'),
        SizedBox(height: 8),
        Expanded(child: WritingCanvas()),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 19, color: Color(0xFF263238)),
      ),
    );
  }
}
