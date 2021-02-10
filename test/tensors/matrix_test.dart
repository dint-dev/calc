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
  group('Float32Matrix', () {
    test('== / hashCode', () {
      final value = Float32Matrix.fromRows([
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
      ]);
      final clone = Float32Matrix.fromRows([
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
      ]);
      final other0 = Float32Matrix.fromRows([
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 99999.0],
      ]);
      final other1 = Float32Matrix.fromRows([
        [1.0, 2.0],
        [3.0, 4.0],
        [5.0, 6.0],
      ]);
      final other2 = Float32Matrix.fromColumns([
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
      ]);

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
      expect(value.hashCode, isNot(other2.hashCode));
    });

    group('toString()', () {
      test('small row matrix', () {
        final matrix = Float32Matrix.fromRowVector([1, 2, 3]);
        expect(
          matrix.toString(),
          'Float32Matrix.fromRowVector([1.0, 2.0, 3.0])',
        );
      }, testOn: '!browser');

      test('small column matrix', () {
        final matrix = Float32Matrix.fromColumnVector([1, 2, 3]);
        expect(
          matrix.toString(),
          'Float32Matrix.fromColumnVector([1.0, 2.0, 3.0])',
        );
      }, testOn: '!browser');

      test('small 4x4 matrix', () {
        final matrix = Float32Matrix.fromRows([
          [1, 2, 3, 4],
          [5, 6, 7, 8],
          [9, 10, 11, 12],
          [13, 14, 15, 16],
        ]);
        expect(
          matrix.toString(),
          'Float32Matrix.fromRows([\n'
          '  [ 1.0,   2.0,   3.0,   4.0 ],\n'
          '  [ 5.0,   6.0,   7.0,   8.0 ],\n'
          '  [ 9.0,   10.0,  11.0,  12.0 ],\n'
          '  [ 13.0,  14.0,  15.0,  16.0 ],\n'
          '])',
        );
      }, testOn: '!browser');

      test('small 4x4 matrix', () {
        final matrix = Float32Matrix.fromRows([
          [1, 2, 3, 4],
          [5, 6, 7, 8],
          [9, 10, 11, 12],
          [13, 14, 15, 16],
        ]);
        expect(
          matrix.toString(),
          'Float32Matrix.fromRows([\n'
          '  [ 1,   2,   3,   4 ],\n'
          '  [ 5,   6,   7,   8 ],\n'
          '  [ 9,   10,  11,  12 ],\n'
          '  [ 13,  14,  15,  16 ],\n'
          '])',
        );
      }, testOn: 'browser');

      test('5x6 matrix', () {
        final matrix = Float32Matrix.filled(5, 6);
        expect(matrix.toString(), 'Float32Matrix(...; width=5, height=6)');
      });
    });

    test('Matrix.fromDiagonal', () {
      final matrix = Float32Matrix.fromDiagonal([1, 2, 3]);
      expect(
        matrix,
        Float32Matrix.fromRows([
          [1.0, 0.0, 0.0],
          [0.0, 2.0, 0.0],
          [0.0, 0.0, 3.0],
        ]),
      );
    });

    group('matrixMul', () {
      test('throws ArgumentError when arguments are invalid', () {
        final left = Float32Matrix.fromRows([
          [1.0, 2.0],
        ]);
        final right = Float32Matrix.fromRows([
          [1.0, 2.0],
        ]);
        expect(() => left.matrixMul(right), throwsArgumentError);
      });

      test('example', () {
        final vector = Float32Matrix.fromRows([
          [1.0, 2.0, 3.0],
        ]);
        expect(
          vector.matrixMul(vector.transpose()),
          Float32Matrix.fromRows([
            [14.0]
          ]),
        );
      });

      test('example', () {
        final left = Float32Matrix.fromRows([
          [1.0, 2.0, 3.0],
          [4.0, 5.0, 6.0],
        ]);
        final right = Float32Matrix.fromRows([
          [1.0, 2.0],
          [3.0, 4.0],
          [5.0, 6.0],
        ]);
        expect(left.getXY(2, 1), 6.0);
        expect(right.getXY(1, 2), 6.0);

        final actual = left.matrixMul(right);
        expect(actual.width, 2);
        expect(actual.height, 2);
        expect(actual.getXY(0, 0), 22.0);
        expect(actual.getXY(1, 0), 28.0);
        expect(actual.getXY(0, 1), 49.0);
        expect(actual.getXY(1, 1), 64.0);
      });
    });

    test('getXY()', () {
      final matrix = Float32Matrix.fromRows([
        [1.0, 2.0],
        [3.0, 4.0],
        [5.0, 6.0],
      ]);
      expect(() => matrix.getXY(3, 1), throwsArgumentError);
      expect(matrix.getXY(0, 0), 1.0);
      expect(matrix.getXY(1, 0), 2.0);
      expect(matrix.getXY(0, 1), 3.0);
      expect(matrix.getXY(1, 1), 4.0);
      expect(matrix.getXY(0, 2), 5.0);
      expect(matrix.getXY(1, 2), 6.0);
    });

    group('binary operators', () {
      test('operator +', () {
        final left = Float32Matrix.fromRows([
          [2.0, 3.0]
        ]);
        final right = Float32Matrix.fromRows([
          [1.0, 4.0]
        ]);
        expect(
            () =>
                left +
                Float32Matrix.fromColumns([
                  [0.0]
                ]),
            throwsArgumentError);
        expect(
            left + right,
            Float32Matrix.fromRows([
              [3.0, 7.0]
            ]));
      });

      test('operator -', () {
        final left = Float32Matrix.fromRowVector([2.0, 3.0]);
        final right = Float32Matrix.fromRowVector([1.0, 4.0]);
        expect(
          () => left - Float32Matrix.fromColumnVector([0.0]),
          throwsArgumentError,
        );
        expect(left - right, Float32Matrix.fromRowVector([1.0, -1.0]));
      });

      test('operator *', () {
        final left = Float32Matrix.fromRowVector([2.0, 3.0]);
        final right = Float32Matrix.fromRowVector([1.0, 4.0]);
        expect(
          () => left * Float32Matrix.fromColumnVector([0.0]),
          throwsArgumentError,
        );
        expect(left * right, Float32Matrix.fromRowVector([2.0, 12.0]));
      });

      test('operator /', () {
        final left = Float32Matrix.fromRowVector([2.0, 3.0]);
        final right = Float32Matrix.fromRowVector([1.0, 4.0]);
        expect(
          () => left / Float32Matrix.fromColumnVector([0.0]),
          throwsArgumentError,
        );
        expect(
          left / right,
          Float32Matrix.fromRowVector([2.0, 0.75]),
        );
      });

      test('scale', () {
        final matrix = Float32Matrix.fromRowVector([2.0, 3.0]);
        expect(
          matrix.scale(3.0),
          Float32Matrix.fromRowVector([6.0, 9.0]),
        );
      });
    });

    test('operator - (unary)', () {
      final matrix = Float32Matrix.fromRowVector([2.0, 3.0]);
      expect(
        -matrix,
        Float32Matrix.fromRowVector([-2.0, -3.0]),
      );
    });

    test('transpose()', () {
      final matrix = Float32Matrix.fromRows([
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
      ]);
      final transposed = matrix.transpose();
      expect(
        transposed,
        Float32Matrix.fromRows([
          [1.0, 4.0],
          [2.0, 5.0],
          [3.0, 6.0],
        ]),
      );
      expect(transposed.transpose(), matrix);
    });
  });
}
