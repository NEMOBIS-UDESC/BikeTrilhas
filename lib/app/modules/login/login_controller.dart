import 'package:biketrilhas_modular/app/modules/email/email_user.dart';
import 'package:biketrilhas_modular/app/shared/auth/auth_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mobx/mobx.dart';

part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final InfoRepository infoRepository;
  EmailUser user;
  @observable
  bool loading = false;

  _LoginControllerBase(this.infoRepository);

  @action
  Future loginWithGoogle(context) async {
    try {
      final auth = Modular.get<AuthController>();
      loading = true;
      await auth.loginWithGoogle();
      await auth.loginProcedure();
      await infoRepository.getModels();
      await locationPermissionPopUp(context);
      /*LocationPermission _permissionGranted =
          await Geolocator.requestPermission();
      if (_permissionGranted == LocationPermission.denied) {
        Modular.to.pushReplacementNamed('/map');
      } else {
        await functionPermisionEnables(context);
      }*/
    } catch (e) {
      loading = false;
    }
  }

  @action
  Future loginWithEmail(context, EmailUser user) async {
    int i = 1;
    print(user.email);
    if (i == 1) {
      try {
        final auth = Modular.get<AuthController>();
        loading = true;
        await auth.loginProcedure();
        await infoRepository.getModels();
        await locationPermissionPopUp(context);
        /*LocationPermission _permissionGranted =
            await Geolocator.requestPermission();
        if (_permissionGranted == LocationPermission.denied) {
          //locationPermissionPopUp(context);
          Modular.to.pushReplacementNamed('/map');
        } else {
          await functionPermisionEnables(context);
        }*/
      } catch (e) {
        loading = false;
      }
    }
  }
}
