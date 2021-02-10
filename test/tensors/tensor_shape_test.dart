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
  group('TensorShape', () {
    test('== / hashCode', () {
      final value = TensorShape(1, 2, 3);
      final clone = TensorShape(1, 2, 3);
      final other0 = TensorShape(1, 9999, 3);
      final other1 = TensorShape(1, 2, 3, 4);

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
    });

    group('getX()', () {
      test('1-dimensional tensor', () {
        final shape = TensorShape(3);
        final f = shape.getX;
        expect(() => f(-1), throwsArgumentError);
        expect(f(0), 0);
        expect(f(1), 1);
        expect(f(2), 2);
        expect(() => f(3), throwsArgumentError);
      });
      test('2-dimensional tensor', () {
        final shape = TensorShape(2, 3);
        final f = shape.getY;
        expect(() => f(-1), throwsArgumentError);
        expect(f(0), 0);
        expect(f(1), 0);
        expect(f(2), 1);
        expect(f(3), 1);
        expect(f(4), 2);
        expect(f(5), 2);
        expect(() => f(6), throwsArgumentError);
      });
      test('3-dimensional tensor', () {
        expect(TensorShape(2, 3, 4).getX(1), 1);
      });
    });

    group('getY()', () {
      test('1-dimensional tensor', () {
        expect(() => TensorShape(3).getY(0), throwsStateError);
      });
      test('2-dimensional tensor', () {
        final shape = TensorShape(2, 3);
        final f = shape.getY;
        expect(() => f(-1), throwsArgumentError);
        expect(f(0), 0);
        expect(f(1), 0);
        expect(f(2), 1);
        expect(f(3), 1);
        expect(f(4), 2);
        expect(f(5), 2);
        expect(() => f(6), throwsArgumentError);
      });
      test('3-dimensional tensor', () {
        expect(TensorShape(2, 3, 4).getY(3), 1);
      });
    });

    test('getZ()', () {
      expect(() => TensorShape(1).getZ(0), throwsStateError);
      expect(() => TensorShape(1, 2).getZ(0), throwsStateError);
      expect(TensorShape(2, 3, 4).getZ(7), 1);
      expect(TensorShape(2, 3, 4, 5).getZ(7), 1);
    });

    test('getW()', () {
      expect(() => TensorShape(2).getW(0), throwsStateError);
      expect(() => TensorShape(2, 3).getW(0), throwsStateError);
      expect(() => TensorShape(2, 3, 4).getW(0), throwsStateError);
      expect(TensorShape(2, 3, 4, 5).getW(25), 1);
    });

    group('getFlatIndex', () {
      test('1-dimensional tensor', () {
        final shape = TensorShape(3);
        expect(shape.flatten(0), 0);
        expect(shape.flatten(1), 1);
        expect(shape.flatten(2), 2);
        expect(() => shape.flatten(2, 0), throwsArgumentError);
        expect(() => shape.flatten(2, 0, 0), throwsArgumentError);
      });

      test('2-dimensional tensor', () {
        final shape = TensorShape(3, 4);
        expect(shape.flatten(0, 0), 0);
        expect(shape.flatten(0, 1), 3);
        expect(shape.flatten(0, 2), 6);
        expect(shape.flatten(0, 3), 9);

        expect(shape.flatten(1, 0), 1);
        expect(shape.flatten(1, 1), 4);
        expect(shape.flatten(1, 2), 7);
        expect(shape.flatten(1, 3), 10);

        expect(shape.flatten(2, 0), 2);
        expect(shape.flatten(2, 1), 5);
        expect(shape.flatten(2, 2), 8);
        expect(shape.flatten(2, 3), 11);

        expect(() => shape.flatten(3, 3), throwsArgumentError);
        expect(() => shape.flatten(2, 4), throwsArgumentError);
        expect(() => shape.flatten(1), throwsArgumentError);
        expect(() => shape.flatten(1, 1, 0), throwsArgumentError);
      });

      test('3-dimensional tensor', () {
        final shape = TensorShape(3, 4, 5);

        expect(shape.flatten(0, 0, 0), 0);
        expect(shape.flatten(0, 0, 1), 12);
        expect(shape.flatten(0, 1, 0), 3);
        expect(shape.flatten(1, 1, 0), 4);

        expect(
          shape.flatten(2, 3, 4),
          2 + (3 * 3) + (3 * 4 * 4),
        );

        expect(() => shape.flatten(1, 1, 5), throwsArgumentError);
        expect(() => shape.flatten(1, 4, 1), throwsArgumentError);
        expect(() => shape.flatten(3, 1, 1), throwsArgumentError);
        expect(() => shape.flatten(1), throwsArgumentError);
        expect(() => shape.flatten(1, 1), throwsArgumentError);
      });
    });
  });
}
