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
  group('Float32MatrixBuilder', () {
    test('tensorShape', () {
      final builder = Float32TensorBuilder();
      expect(builder.tensorShape, TensorShape.scalar);

      // Change shape
      builder.tensorShape = TensorShape(2, 3);
      expect(builder.tensorShape, TensorShape(2, 3));
      expect(builder.elements, hasLength(6));

      // Change shape to bigger
      builder.tensorShape = TensorShape(5, 6);
      expect(builder.tensorShape, TensorShape(5, 6));
      expect(builder.elements, hasLength(30));

      // Change shape to smaller
      builder.tensorShape = TensorShape(3, 4);
      expect(builder.tensorShape, TensorShape(3, 4));
      expect(builder.elements, hasLength(12));

      // Build
      expect(builder.build().tensorShape, TensorShape(3, 4));
    });

    group('setXY(x,y,), getXY(x,y)', () {
      test('valid indices', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(2, 3);

        // (0,0)
        builder.setXY(0, 0, 5);
        expect(builder.getXY(0, 0), 5);
        expect(builder.elements, [5, 0, 0, 0, 0, 0]);

        // (1,0)
        builder.setXY(1, 0, 6);
        expect(builder.getXY(1, 0), 6);
        expect(builder.elements, [5, 6, 0, 0, 0, 0]);

        // (0,1)
        builder.setXY(0, 1, 7);
        expect(builder.getXY(0, 1), 7);
        expect(builder.elements, [5, 6, 7, 0, 0, 0]);

        // Last index
        builder.setXY(1, 2, 8);
        expect(builder.getXY(1, 2), 8);
        expect(builder.elements, [5, 6, 7, 0, 0, 8]);
      });

      test('invalid indices', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(2, 3);

        expect(() => builder.setXY(-1, 0, 0), throwsArgumentError);
        expect(() => builder.setXY(0, -1, 0), throwsArgumentError);
        expect(() => builder.setXY(2, 0, 0), throwsArgumentError);
        expect(() => builder.setXY(0, 3, 0), throwsArgumentError);

        expect(() => builder.getXY(-1, 0), throwsArgumentError);
        expect(() => builder.getXY(0, -1), throwsArgumentError);
        expect(() => builder.getXY(2, 0), throwsArgumentError);
        expect(() => builder.getXY(0, 3), throwsArgumentError);
      });

      test('when tensor is a vector', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(2);
        expect(() => builder.setXY(0, 0, 0), throwsArgumentError);
        expect(() => builder.getXY(0, 0), throwsArgumentError);
      });
    });

    test('build()', () {
      final builder = Float32TensorBuilder();
      builder.tensorShape = TensorShape(2, 3);

      // Build
      final built = builder.build();
      expect(built.tensorShape, TensorShape(2, 3));
      expect(built.elements, hasLength(6));
      expect(built.isZero, isTrue);

      // Builder has been reset
      expect(builder.tensorShape, TensorShape.scalar);
      expect(builder.elements, isEmpty);

      // New changes have no impact on the built tensor
      builder.tensorShape = TensorShape(2, 3);
      builder.setXY(0, 0, 1);
      expect(built.isZero, isTrue);

      // Build again
      final built2 = builder.build();
      expect(built, isNot(same(built2)));
      expect(built.isZero, isTrue);
    });

    test('build(recycle:true)', () {
      final builder = Float32TensorBuilder();
      builder.tensorShape = TensorShape(2, 3);

      // build(recycle:true)
      final built1 = builder.build(recycle: true);
      expect(built1.tensorShape, TensorShape(2, 3));
      expect(built1.elements, hasLength(6));
      expect(built1.isZero, isTrue);

      // TensorBuilder has not been reset
      expect(builder.tensorShape, TensorShape(2, 3));
      expect(builder.elements, same(built1.elements));

      // Changes in the builder are visible in the built tensor.
      builder.setXY(0, 0, 1);
      expect(built1.isZero, isFalse);

      // build(recycle:true) returns the same instance
      final built2 = builder.build(recycle: true);
      expect(built2, same(built1));

      // build() returns the same instance (but stops recycling).
      final built3 = builder.build();
      expect(built3, same(built1));

      // TensorBuilder has been reset
      expect(builder.tensorShape, TensorShape.scalar);
      expect(builder.elements, isEmpty);
      builder.tensorShape = built1.tensorShape;

      // build(recycle:true) should not return a recycled tensor
      final built4 = builder.build(recycle: true);
      expect(built4, isNot(same(built1)));
    });

    group('Mathematical operations', () {
      test('abs()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.elements[0] = -2;
        builder.elements[2] = 3;
        builder.abs();
        expect(builder.elements, [2, 0, 3]);
      });

      test('add()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.elements[0] = -2.0;
        builder.elements[2] = 3.5;
        builder.add(builder.build(recycle: true));
        expect(builder.elements, [-4, 0, 7]);
      });

      test('ceil()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.elements[0] = -1.7;
        builder.elements[2] = 2.3;
        builder.ceil();
        expect(builder.elements, [-1, 0, 3]);
      });

      test('cos()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.elements[0] = pi;
        builder.elements[2] = pi / 2;
        builder.cos();
        expect(builder.elements, [-1, 1, -4.371138828673793e-8]);
      });

      test('div()', () {
        final left = Float32TensorBuilder();
        left.tensorShape = TensorShape(3);
        left.elements[0] = -4.0;
        left.elements[2] = 3.0;
        left.div(left.build(recycle: true));
        expect(left.elements[0], 1.0);
        expect(left.elements[1], isNaN);
        expect(left.elements[2], 1.0);
      });

      test('exp()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.elements[0] = 2;
        builder.elements[2] = 3;
        builder.exp();
        expect(builder.elements, [7.389056205749512, 1.0, 20.08553695678711]);
      });

      test('floor()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.elements[0] = -1.7;
        builder.elements[2] = 2.3;
        builder.floor();
        expect(builder.elements, [-2, 0, 2]);
      });

      test('log()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.elements[0] = 2;
        builder.elements[2] = 3;
        builder.log();
        expect(builder.elements,
            [0.6931471824645996, double.negativeInfinity, 1.0986123085021973]);
      });

      test('mul()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.elements[0] = -2.0;
        builder.elements[2] = 3.0;
        builder.mul(builder.build(recycle: true));
        expect(builder.elements, [4.0, 0, 9.0]);
      });

      test('neg()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.elements[0] = -2.0;
        builder.elements[2] = 3.5;
        builder.neg();
        expect(builder.elements, [2.0, 0, -3.5]);
      });

      test('pow()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.elements[0] = 2;
        builder.elements[2] = 3;
        builder.pow(Float32Vector([4, 0, 2]));
        expect(builder.elements, [16, 1, 9]);
      });

      test('round()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.elements[0] = -1.7;
        builder.elements[2] = 2.3;
        builder.round();
        expect(builder.elements, [-2, 0, 2]);
      });

      test('sin()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.elements[0] = pi;
        builder.elements[2] = pi / 2;
        builder.sin();
        expect(builder.elements, [-8.742277657347586e-8, 0, 1]);
      });

      test('sq()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.elements[0] = 0.5;
        builder.elements[2] = 1.5;
        builder.sq();
        expect(builder.elements, [0.25, 0, 2.25]);
      });

      test('sqrt()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(2);
        builder.elements[0] = 0.25;
        builder.elements[1] = 2.25;
        builder.sqrt();
        expect(builder.elements, [0.5, 1.5]);
      });

      test('sub()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.elements[0] = -2.0;
        builder.elements[2] = 3.5;
        builder.sub(builder.build(recycle: true));
        expect(builder.elements, [0.0, 0, 0.0]);
      });
    });
  });
}
