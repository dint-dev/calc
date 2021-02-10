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
  group('LinearRegressionTensorModel', () {
    test('== / hashCode', () {
      final object = LinearTensorModel(
        coefficients: Float32Vector([1, 2, 3]),
        constants: Float32Vector([0, 0, 1]),
      );
      final clone = LinearTensorModel(
        coefficients: Float32Vector([1, 2, 3]),
        constants: Float32Vector([0, 0, 1]),
      );
      final other0 = LinearTensorModel(
        coefficients: Float32Vector([1, 2, 9999]),
        constants: Float32Vector([0, 0, 1]),
      );
      final other1 = LinearTensorModel(
        coefficients: Float32Vector([1, 2, 3]),
        constants: Float32Vector([0, 0, 9999]),
      );

      expect(object, clone);
      expect(object, isNot(other0));
      expect(object, isNot(other1));

      expect(object.hashCode, clone.hashCode);
      expect(object.hashCode, isNot(other0.hashCode));
      expect(object.hashCode, isNot(other1.hashCode));
    });

    test('predict', () {
      final model = LinearTensorModel(
        coefficients: Float32Vector([1, 2, 3]),
        constants: Float32Vector([0, 0, 1]),
      );
      expect(
        model.predict(Float32Vector([2.0, 2.0, 2.0])),
        Float32Vector([2.0, 4.0, 7.0]),
      );
    });
  });
}
