import 'package:flutter_test/flutter_test.dart';

import 'package:colours/colours.dart';

void main() {
  test('adds one to input values', () {
    final calculator = Colours.fromRGBO(233,255,255, 0);
    expect(calculator.red, 233);
  });
}
