import 'package:biketrilhas_modular/app/modules/email/email_Page.dart';
import 'package:biketrilhas_modular/app/modules/email/email_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmailModule extends Module {
  @override
  final List<Bind> binds = [
    //Bind.lazySingleton((i) => EmailStore(i.get())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => EmailPage()),
  ];
}
