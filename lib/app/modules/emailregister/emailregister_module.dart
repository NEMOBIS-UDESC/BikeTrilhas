import 'package:biketrilhas_modular/app/modules/emailregister/emailregister_Page.dart';
import 'package:biketrilhas_modular/app/modules/emailregister/emailregister_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmailregisterModule extends Module {
  @override
  final List<Bind> binds = [
    //Bind.lazySingleton((i) => EmailregisterStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => EmailregisterPage()),
  ];
}
