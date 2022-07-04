import 'package:biketrilhas_modular/app/modules/email/email_user.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_repository_interface.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthRepository implements IAuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Dio dio;

  AuthRepository(this.dio);

  @override
  Future<User> getGoogleLogin() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final User user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  @override
  Future<User> getUser() async {
    return _auth.currentUser;
  }

  @override
  Future getLogout() {
    return _auth.signOut();
  }

  Future<bool> insertUser(User user) async {
    var result = await dio.post('server/usuario', data: {
      "usuEmail": user.email,
      "usuNome": user.displayName,
      "deletado": 0,
      "admin": 0
    });
    return result.data;
  }

  Future<int> isAdmin(String email) async {
    var result = await dio.get('server/admin/$email');
    return result.data as int;
  }

  @override
  Future<User> getEmailLogin(EmailUser usuario) async {
    int i = usuario.value;
    if (i == 1) {
      print("Login");
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha);
        print(userCredential.user.email);
        final User user = userCredential.user;
        return user;
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == "user-not-found") {
          throw AuthException("Usuário não encontrado, Cadastre-se");
        } else if (e.code == "wrong-password") {
          throw AuthException("Senha Incorreta");
        } else if (e.code == "too-many-requests") {
          throw AuthException("Aguarde um instante e tente novamente");
        } else {
          throw AuthException("Verifique os dados e tente novamente");
        }
      }
    } else if (i == 0) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: usuario.email, password: usuario.senha);
        final User user = userCredential.user;
        await user.updateDisplayName(usuario.nome);
        await user.updatePhotoURL(
            "https://cdn-icons-png.flaticon.com/512/21/21104.png");
        return user;
      } on FirebaseAuthException catch (e) {
        print(e);
        if (e.code == "email-already-in-use") {
          print("Email Ja Cadastrado");
          throw AuthException("Usuário já Cadastrado");
        } else if (e.code == "weak-password") {
          print("Senha muito fraca");
          throw AuthException("Senha muito fraca");
        } else if (e.code == "invalid-email") {
          throw AuthException("Digite um e-mail válido");
        } else {
          throw AuthException("Verifique os dados e Tente Novamente");
        }
      }
    }
  }
}
