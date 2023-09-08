import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNameNotifier extends StateNotifier<String> {
  UserNameNotifier() : super("");
  void getuser(String user) {
    state = user;
  }
}

final usernameprov = StateNotifierProvider<UserNameNotifier, String>(
  (ref) => UserNameNotifier(),
);
