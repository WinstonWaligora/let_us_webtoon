import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:let_us_webtoon/screens/home_screen.dart';
import 'package:let_us_webtoon/models/webtoon.dart';
import 'package:let_us_webtoon/models/script.dart';

void main() {
  group('HomeScreen Tests', () {
    // Create a list of fake webtoons with all required fields for testing
    final List<Webtoon> testWebtoons = [
      Webtoon(
        series: 'Series 1',
        arc: 'Arc 1',
        episode: 1,
        title: 'Title 1',
        description: 'Description 1',
        characters: ['Character A', 'Character B'],
        script: [
          Script(
              scene: 1, description: 'Description A', text: 'Character Dialog')
        ],
      ),
    ];

    // Initialize the HomeScreen with the test webtoons
    late HomeScreen homeScreen;

    setUp(() {
      homeScreen = HomeScreen(webtoons: testWebtoons);
    });

    testWidgets('Displays the correct number of webtoons',
        (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(MaterialApp(home: homeScreen));

      // Verify that the correct number of webtoons are displayed
      expect(find.byType(ListTile), findsNWidgets(testWebtoons.length));
    });

    testWidgets('Displays webtoon details correctly',
        (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(MaterialApp(home: homeScreen));

      // Verify that the webtoon details are displayed correctly
      for (var webtoon in testWebtoons) {
        expect(find.text(webtoon.series), findsOneWidget);
        expect(find.text(webtoon.title), findsOneWidget);
      }
    });
  });
}
