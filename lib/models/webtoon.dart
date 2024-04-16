import 'script.dart';

class Webtoon {
  String series;
  String arc;
  int episode;
  String title;
  String description;
  List<String> characters;
  List<Script> script;

  Webtoon({
    required this.series,
    required this.arc,
    required this.episode,
    required this.title,
    required this.description,
    required this.characters,
    required this.script,
  });

  Map<String, dynamic> toJson() => {
        'series': series,
        'arc': arc,
        'episode': episode,
        'title': title,
        'description': description,
        'characters': characters,
        'script': script.map((s) => s.toJson()).toList(),
      };

  Webtoon.fromJson(Map<String, dynamic> json)
      : series = json['series'],
        arc = json['arc'],
        episode = json['episode'],
        title = json['title'],
        description = json['description'],
        characters = List<String>.from(json['characters']),
        script = (json['script'] as List)
            .map((item) => Script.fromJson(item))
            .toList();
}
