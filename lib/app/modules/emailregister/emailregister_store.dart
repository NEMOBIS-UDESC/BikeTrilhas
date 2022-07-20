import 'package:mobx/mobx.dart';

//part 'emailregister_store.g.dart';

//class EmailregisterStore = _EmailregisterStoreBase with _$EmailregisterStore;
abstract class _EmailregisterStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 
}