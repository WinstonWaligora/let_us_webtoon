import 'webtoon.dart';

class User {
  String email;
  String password;
  List<Webtoon> webtoons;

  User({
    required this.email,
    required this.password,
    required this.webtoons,
  });
}
