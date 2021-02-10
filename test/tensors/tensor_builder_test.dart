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
      expect(builder.data, hasLength(6));

      // Change shape
      builder.tensorShape = TensorShape(5, 6);
      expect(builder.tensorShape, TensorShape(5, 6));
      expect(builder.data, hasLength(30));

      // Change shape
      builder.tensorShape = TensorShape(3, 4);
      expect(builder.tensorShape, TensorShape(3, 4));
      expect(builder.data, hasLength(30));

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
        expect(builder.data, [5, 0, 0, 0, 0, 0]);

        // (1,0)
        builder.setXY(1, 0, 6);
        expect(builder.getXY(1, 0), 6);
        expect(builder.data, [5, 6, 0, 0, 0, 0]);

        // (0,1)
        builder.setXY(0, 1, 7);
        expect(builder.getXY(0, 1), 7);
        expect(builder.data, [5, 6, 7, 0, 0, 0]);

        // Last index
        builder.setXY(1, 2, 8);
        expect(builder.getXY(1, 2), 8);
        expect(builder.data, [5, 6, 7, 0, 0, 8]);
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
      expect(built.elements(), hasLength(6));
      expect(built.isZero, isTrue);

      // Builder has been reset
      expect(builder.tensorShape, TensorShape.scalar);
      expect(builder.data, isEmpty);

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
      expect(built1.elements(), hasLength(6));
      expect(built1.isZero, isTrue);

      // TensorBuilder has not been reset
      expect(builder.tensorShape, TensorShape(2, 3));
      expect(builder.data, same(built1.elements()));

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
      expect(builder.data, isEmpty);
      builder.tensorShape = built1.tensorShape;

      // build(recycle:true) should not return a recycled tensor
      final built4 = builder.build(recycle: true);
      expect(built4, isNot(same(built1)));
    });

    group('Mathematical operations', () {
      test('add()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.data[0] = -2.0;
        builder.data[2] = 3.5;
        builder.add(builder.build(recycle: true));
        expect(builder.data, [-4, 0, 7]);
      });

      test('div()', () {
        final left = Float32TensorBuilder();
        left.tensorShape = TensorShape(3);
        left.data[0] = -4.0;
        left.data[2] = 3.0;
        left.div(left.build(recycle: true));
        expect(left.data[0], 1.0);
        expect(left.data[1], isNaN);
        expect(left.data[2], 1.0);
      });

      test('mul()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.data[0] = -2.0;
        builder.data[2] = 3.0;
        builder.mul(builder.build(recycle: true));
        expect(builder.data, [4.0, 0, 9.0]);
      });

      test('neg()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.data[0] = -2.0;
        builder.data[2] = 3.5;
        builder.neg();
        expect(builder.data, [2.0, 0, -3.5]);
      });

      test('elementsSq()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.data[0] = 0.5;
        builder.data[2] = 1.5;
        builder.sq();
        expect(builder.data, [0.25, 0, 2.25]);
      });

      test('sqrt()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(2);
        builder.data[0] = 0.25;
        builder.data[1] = 2.25;
        builder.sqrt();
        expect(builder.data, [0.5, 1.5]);
      });

      test('sub()', () {
        final builder = Float32TensorBuilder();
        builder.tensorShape = TensorShape(3);
        builder.data[0] = -2.0;
        builder.data[2] = 3.5;
        builder.sub(builder.build(recycle: true));
        expect(builder.data, [0.0, 0, 0.0]);
      });
    });
  });
}
