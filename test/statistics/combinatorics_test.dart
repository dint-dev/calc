// Copyright 2021 Gohilla Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:calc/calc.dart';
import 'package:test/test.dart';

void main() {
  group('factorial(k)', () {
    test('0', () {
      expect(factorial(0), 1);
    });
    test('1', () {
      expect(factorial(1), 1);
    });
    test('2', () {
      expect(factorial(2), 2);
    });
    test('3', () {
      expect(factorial(3), 3 * 2);
    });
    test('4', () {
      expect(factorial(4), 4 * 3 * 2);
    });
    test('5', () {
      expect(factorial(5), 5 * 4 * 3 * 2);
    });
  });

  group('binomialCoefficient(n,k)', () {
    test('(10,5)', () {
      expect(binomialCoefficient(10, 5), 252);
    });
  });
}
