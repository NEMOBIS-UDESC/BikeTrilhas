import 'package:flutter_test/flutter_test.dart';
import 'package:biketrilhas_modular/app/modules/emailregister/emailregister_store.dart';
 
void main() {
  late EmailregisterStore store;

  setUpAll(() {
    store = EmailregisterStore();
  });

  test('increment count', () async {
    expect(store.value, equals(0));
    store.increment();
    expect(store.value, equals(1));
  });
}