import 'package:flutter_test/flutter_test.dart';
import 'package:biketrilhas_modular/app/modules/email/email_store.dart';
 
void main() {
  late EmailStore store;

  setUpAll(() {
    store = EmailStore();
  });

  test('increment count', () async {
    expect(store.value, equals(0));
    store.increment();
    expect(store.value, equals(1));
  });
}