import 'enums.dart';

class UserInfo {
  UserInfo({
    required this.userId,
    required this.loginStatus,
  });

  final int userId;
  final LoginStatus loginStatus;
}
