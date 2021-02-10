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
  group('Tensor<double>IterableMath', () {
    test('mean(...)', () {
      expect(() => <Tensor<double>>[].mean(), throwsStateError);
      expect(
        <Tensor<double>>[
          Float32Vector([42.0])
        ].mean(),
        Float32Vector([42.0]),
      );
      expect(
        <Tensor<double>>[
          Float32Vector([42.0]),
          Float32Vector([42.0]),
          Float32Vector([42.0])
        ].mean(),
        Float32Vector([42.0]),
      );
      expect(
        <Tensor<double>>[
          Float32Vector([1.0]),
          Float32Vector([3.0])
        ].mean(),
        Float32Vector([2.0]),
      );
      expect(
        <Tensor<double>>[
          Float32Vector([0.0]),
          Float32Vector([0.0]),
          Float32Vector([6.0])
        ].mean(),
        Float32Vector([2.0]),
      );
    });

    test('sum(...)', () {
      expect(() => <Tensor<double>>[].sum(), throwsStateError);
      expect(
        <Tensor<double>>[
          Float32Vector([2.0])
        ].sum(),
        Float32Vector([2.0]),
      );
      expect(
        <Tensor<double>>[
          Float32Vector([2.0]),
          Float32Vector([3.0])
        ].sum(),
        Float32Vector([5.0]),
      );
    });

    test('variance(...)', () {
      expect(() => <Tensor<double>>[].variance(), throwsStateError);
      expect(
        <Tensor<double>>[
          Float32Vector([2.0])
        ].variance(),
        Float32Vector([0.0]),
      );
      expect(
        <Tensor<double>>[
          Float32Vector([2.0]),
          Float32Vector([3.0])
        ].variance(),
        Float32Vector([0.25]),
      );
    });

    test('toScalars()', () {
      final tensors = <Tensor<double>>[
        Float32Vector([2.0]),
        Float32Vector([3.0])
      ];
      expect(tensors.toScalars(), [2.0, 3.0]);
    });
  });
}
