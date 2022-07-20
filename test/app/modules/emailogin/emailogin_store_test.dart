import 'package:flutter_test/flutter_test.dart';
import 'package:biketrilhas_modular/app/modules/emailogin/emailogin_store.dart';
 
void main() {
  late EmailoginStore store;

  setUpAll(() {
    store = EmailoginStore();
  });

  test('increment count', () async {
    expect(store.value, equals(0));
    store.increment();
    expect(store.value, equals(1));
  });
}