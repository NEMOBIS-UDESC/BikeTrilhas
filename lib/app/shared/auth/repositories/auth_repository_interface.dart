import 'package:biketrilhas_modular/app/modules/email/email_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthRepository {
  Future<User> getUser();
  Future<User> getGoogleLogin();
  Future<User> getEmailLogin(EmailUser useremail);
  Future getLogout();
  Future<int> isAdmin(String email);
  Future<bool> insertUser(User user);
}
