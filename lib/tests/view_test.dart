import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:let_us_webtoon/screens/view_screen.dart';
import 'package:let_us_webtoon/models/webtoon.dart';
import 'package:let_us_webtoon/models/script.dart';

void main() {
  group('ViewScreen Tests', () {
    // Create a fake webtoon with all required fields for testing
    final Webtoon testWebtoon = Webtoon(
      series: 'Series 1',
      arc: 'Arc 1',
      episode: 1,
      title: 'Title 1',
      description: 'Description 1',
      characters: ['Character A', 'Character B'],
      script: [
        Script(
          scene: 0,
          description: 'A thrilling space adventure.',
          text: 'Dialogue 1',
        ),
      ],
    );

    // Initialize the ViewScreen with the test webtoon
    late ViewScreen viewScreen;

    setUp(() {
      viewScreen = ViewScreen(webtoon: testWebtoon);
    });

    testWidgets('Displays webtoon details correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(MaterialApp(home: viewScreen));

      // Verify that the webtoon details are displayed correctly
      expect(find.text(testWebtoon.series), findsOneWidget);
      expect(find.text('Arc: ${testWebtoon.arc}'), findsOneWidget);
      expect(find.text('Episode: ${testWebtoon.episode}'), findsOneWidget);
      expect(find.text(testWebtoon.title), findsOneWidget);
    });
  });
}
