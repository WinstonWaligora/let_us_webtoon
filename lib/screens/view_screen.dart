import 'package:flutter/material.dart';
import '../models/webtoon.dart';

class ViewScreen extends StatelessWidget {
  final Webtoon webtoon;

  const ViewScreen({super.key, required this.webtoon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(webtoon.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Arc: ${webtoon.arc}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Episode: ${webtoon.episode}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            ...webtoon.script.map((script) => Text(script.text)).toList(),
          ],
        ),
      ),
    );
  }
}
