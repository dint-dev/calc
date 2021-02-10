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
  group('Float32Vector', () {
    test('== / hashCode', () {
      final value = Float32Vector([1.0, 2.0, 3.0]);
      final clone = Float32Vector([1.0, 2.0, 3.0]);
      final other0 = Float32Vector([1.0, 9999.0, 3.0]);

      expect(value, clone);
      expect(value, isNot(other0));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
    });

    test('toMatrixRow()', () {
      final vector = Float32Vector([1, 2, 3]);
      final matrix = vector.toMatrixRow();
      expect(matrix.width, 3);
      expect(matrix.height, 1);
    });

    test('toMatrixColumn()', () {
      final vector = Float32Vector([1, 2, 3]);
      final matrix = vector.toMatrixColumn();
      expect(matrix.width, 1);
      expect(matrix.height, 3);
    });
  });
}
