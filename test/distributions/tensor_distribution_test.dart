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
  group('TensorDistribution:', () {
    test('== / hashCode', () {
      final value = TensorDistribution.filled(
        TensorShape(2, 3),
        NormalDistribution(mean: 0, variance: 1.0),
      );
      final clone = TensorDistribution.filled(
        TensorShape(2, 3),
        NormalDistribution(mean: 0, variance: 1.0),
      ); // Relative frequencies are just scaled.
      final other0 = TensorDistribution.filled(
        TensorShape(2, 9999),
        NormalDistribution(mean: 0, variance: 1.0),
      );
      final other1 = TensorDistribution.filled(
        TensorShape(2, 3),
        NormalDistribution(mean: 0, variance: 99999.0),
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
    });
  });
}
