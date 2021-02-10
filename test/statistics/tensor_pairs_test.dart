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
  group('TensorPairs', () {
    test('== / hashCode', () {
      final value = TensorPairs.fromScalarLists([1, 2], [3, 4]);
      final clone = TensorPairs.generateFromScalarList([1, 2], (x) => 2 + x);
      final other0 = TensorPairs.fromScalarLists([1, 9999], [3, 4]);
      final other1 = TensorPairs.fromScalarLists([1, 2], [3, 9999]);

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
    });
    group('correlation(x,y)', () {
      test('x,x', () {
        final x = [1, 2, 3, 4];
        final samples = TensorPairs.fromScalarLists(x, x);
        expect(
          samples.correlation().toScalar(),
          0.800000011920929,
        );
      });
      test('when x has zero variance', () {
        final x = [2, 2, 2];
        final y = [1, 2, 3];
        final samples = TensorPairs.fromScalarLists(x, y);
        expect(
          () => samples.correlation().toScalar(),
          throwsArgumentError,
        );
      });
      test('when y has zero variance', () {
        final x = [1, 2, 3];
        final y = [2, 2, 2];
        final samples = TensorPairs.fromScalarLists(x, y);
        expect(
          () => samples.correlation().toScalar(),
          throwsArgumentError,
        );
      });
      test('when -0.8', () {
        final x = [1, 2, 3, 4];
        final y = [5, 4, 3, 2];
        final samples = TensorPairs.fromScalarLists(x, y);
        expect(
          samples.correlation().toScalar(),
          -0.800000011920929,
        );
      });
    });
    group('covariance(x,y)', () {
      test('x,x', () {
        final x = [1, 2, 3, 4];
        final samples = TensorPairs.fromScalarLists(x, x);
        expect(samples.covariance().toScalar(), 1.25);
      });
      test('when 0.0', () {
        final x = [2, 2, 2, 2];
        final samples = TensorPairs.fromScalarLists(x, x);
        expect(samples.covariance().toScalar(), 0.0);
      });
      test('when -1.25', () {
        final x = [1, 2, 3, 4];
        final y = [5, 4, 3, 2];
        final samples = TensorPairs.fromScalarLists(x, y);
        expect(samples.covariance().toScalar(), -1.25);
      });
    });
  });
}
