class Script {
  int scene;
  String description;
  String text;

  Script({required this.scene, required this.description, required this.text});

  Map<String, dynamic> toJson() => {
        'scene': scene,
        'description': description,
        'text': text,
      };

  Script.fromJson(Map<String, dynamic> json)
      : scene = json['scene'],
        description = json['description'],
        text = json['text'];
}
