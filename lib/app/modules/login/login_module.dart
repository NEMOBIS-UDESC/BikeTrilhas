import 'package:biketrilhas_modular/app/modules/login/login_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:biketrilhas_modular/app/modules/login/login_page.dart';

class LoginModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => LoginController(i.get())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, args) => LoginPage()),
      ];
}
