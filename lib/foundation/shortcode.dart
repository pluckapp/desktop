//
// shortcode.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 09/10/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'dart:math';


final _letters = 'abcdefghijklmnopqrstuvwxyz';
final _numbers = '0123456789';
final _symbols = '_-';
final _characters = [
  ..._letters.split(''),
  ..._letters.toUpperCase().split(''),
  ..._numbers.split(''),
  ..._symbols.split('')
].join();

List<int> _randomByte(int size) {
  List<int> bytes = [];

  for(var i = 0; i < size; i++) {
    bytes.add(
      (Random().nextDouble() * 256)
      .floor()
    );
  }

  return bytes;
}

String _format(String characters, int size) {
   final mask = (2 << log(_characters.length - 1) ~/ ln2) - 1;
  final step = (1.6 * mask * size / _characters.length).ceil();

  var id = '';
  const faker = true;
  while (faker) {
    final bytes = _randomByte(step);
    for (var i = 0; i < step; i++) {
      final byte = bytes[i] & mask;
      if (byte > 0 && _characters.length > byte) {
        id += _characters[byte];
        if (id.length == size) {
          return id;
        }
      }
    }
  }
  return '';
}

String generate(int number) {
  var counter = 0;

  final buffer = StringBuffer();

  var complete = false;
  while(!complete) {
    buffer.write(_format(_characters, number < 5 ? 5 : number));
    
    complete = number < pow(16, counter + 1);
    counter++;
  }

  return buffer.toString();
}