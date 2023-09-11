import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNameNotifier extends StateNotifier<Map<String, String>> {
  UserNameNotifier() : super(<String, String>{});
  void getuser(String user, String uid) {
    state = {"user": user, "uid": uid};
  }
}

final usernameprov =
    StateNotifierProvider<UserNameNotifier, Map<String, String>>(
  (ref) => UserNameNotifier(),
);
