import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bento/main.dart';

void main() {
  testWidgets('Smoke test GridBreakApp renders core elements', (WidgetTester tester) async {
    await tester.pumpWidget(const GridBreakApp());

    // Verify header text exists
    expect(find.textContaining('DESIGN'), findsOneWidget);
    expect(find.text('BREAKS THE GRID.'), findsOneWidget);
    expect(find.text('PINCH TO ZOOM'), findsOneWidget);
    expect(find.text('SAVED MOODBOARD'), findsOneWidget);
    expect(find.text('LIGHT'), findsOneWidget);
  });

  testWidgets('Double tap toggles theme between light and dark', (WidgetTester tester) async {
    await tester.pumpWidget(const GridBreakApp());

    expect(find.text('LIGHT'), findsOneWidget);

    // Double tap header
    await tester.tap(find.textContaining('DESIGN'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.textContaining('DESIGN'));
    await tester.pumpAndSettle();

    expect(find.text('DARK'), findsOneWidget);
  });

  testWidgets('Swipe item dismisses and undo restores it', (WidgetTester tester) async {
    await tester.pumpWidget(const GridBreakApp());

    final firstItemText = 'Altera: Digital Wardrobe Mix & Match';
    expect(find.text(firstItemText), findsOneWidget);

    // Swipe item to the left
    await tester.drag(find.text(firstItemText), const Offset(-500, 0));
    await tester.pumpAndSettle();

    // Verify item is removed
    expect(find.text(firstItemText), findsNothing);
    expect(find.text('UNDO'), findsOneWidget);

    // Tap UNDO
    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();

    // Verify item is restored
    expect(find.text(firstItemText), findsOneWidget);
  });

  testWidgets('Renders properly without overflow on standard mobile viewport', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const GridBreakApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
