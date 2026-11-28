import 'package:escriba/app/app.dart';
import 'package:escriba/app/section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const EscribaApp());
  // The Flame game loop never settles, so pump fixed frames instead of
  // pumpAndSettle.
  await tester.pump(const Duration(milliseconds: 300));
}

/// Lets the page cross-fade (AnimatedSwitcher) finish so only one page,
/// and one title, remains.
Future<void> _settleSwitch(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump();
}

String _pageTitle(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('page-title'))).data!;

void main() {
  testWidgets('landscape: shows every sticky note and starts on Practice', (tester) async {
    await _pumpAt(tester, const Size(1280, 800));
    for (final s in Section.values) {
      expect(find.byKey(Key('note-${s.name}')), findsOneWidget);
    }
    expect(_pageTitle(tester), 'Practice');
  });

  testWidgets('tapping a sticky note switches the notepad page', (tester) async {
    await _pumpAt(tester, const Size(1280, 800));
    await tester.tap(find.byKey(const Key('note-alphabets')));
    await _settleSwitch(tester);
    expect(_pageTitle(tester), 'Alphabets');
    expect(find.textContaining('Greek'), findsOneWidget);

    await tester.tap(find.byKey(const Key('note-settings')));
    await _settleSwitch(tester);
    expect(_pageTitle(tester), 'Settings');
  });

  testWidgets('portrait phone layout renders without overflow', (tester) async {
    await _pumpAt(tester, const Size(400, 860));
    expect(tester.takeException(), isNull);
    await tester.tap(find.byKey(const Key('note-progress')));
    await _settleSwitch(tester);
    expect(_pageTitle(tester), 'Progress');
  });

  for (final size in const [Size(1024, 600), Size(800, 360), Size(360, 640)]) {
    testWidgets('lays out without overflow at $size', (tester) async {
      await _pumpAt(tester, size);
      expect(tester.takeException(), isNull);
    });
  }
}
