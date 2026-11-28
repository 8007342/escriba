import 'package:flutter/painting.dart';

/// The top-level areas of the app. Each one is a sticky note on the desk and a
/// page on the notepad.
enum Section {
  practice('Practice', Color(0xFFFFF176)),
  alphabets('Alphabets', Color(0xFFFFB74D)),
  languages('Languages', Color(0xFF81D4FA)),
  progress('Progress', Color(0xFFA5D6A7)),
  settings('Settings', Color(0xFFF48FB1));

  const Section(this.label, this.color);

  final String label;
  final Color color;
}
