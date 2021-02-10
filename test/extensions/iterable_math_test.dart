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
  group('IterableMath', () {
    test('fractionalIndex(...)', () {
      expect(() => [].fractionalIndex(0.5), throwsStateError);

      final list = [1, 2, 3, 4, 5];
      expect(() => list.fractionalIndex(-0.1), throwsArgumentError);
      expect(() => list.fractionalIndex(1.1), throwsArgumentError);
      expect(() => list.fractionalIndex(double.nan), throwsArgumentError);
      expect(() => list.fractionalIndex(double.infinity), throwsArgumentError);
      expect(() => list.fractionalIndex(double.negativeInfinity),
          throwsArgumentError);
      expect(list.fractionalIndex(0.0), 1);
      expect(list.fractionalIndex(0.24), 2);
      expect(list.fractionalIndex(0.5), 3);
      expect(list.fractionalIndex(0.75), 4);
      expect(list.fractionalIndex(1.0), 5);

      expect([1, 2].fractionalIndex(0.5), 2);
    });

    test('fractionalRange(...)', () {
      expect(() => [].fractionalIndex(0.5), throwsStateError);

      final list = [1, 2, 3, 4, 5];
      expect(() => list.fractionalRange(-0.1, 1.0), throwsArgumentError);
      expect(() => list.fractionalRange(0.0, 1.1), throwsArgumentError);
      expect(() => list.fractionalRange(double.nan, 1.0), throwsArgumentError);
      expect(() => list.fractionalRange(0.0, double.nan), throwsArgumentError);
      expect(
        () => list.fractionalRange(double.infinity, 1.0),
        throwsArgumentError,
      );
      expect(
        () => list.fractionalRange(0.0, double.infinity),
        throwsArgumentError,
      );
      expect(
        () => list.fractionalRange(double.negativeInfinity, 1.0),
        throwsArgumentError,
      );
      expect(
        () => list.fractionalRange(0.0, double.negativeInfinity),
        throwsArgumentError,
      );

      expect(() => list.fractionalRange(1.0, 0.0), throwsArgumentError);

      expect(list.fractionalRange(0.0, 1.0), list);
      expect(list.fractionalRange(0.0, 0.0), []);
      expect(list.fractionalRange(1.0, 1.0), []);
      expect(list.fractionalRange(0.0, 0.5), [1, 2]);
      expect(list.fractionalRange(0.5, 1.0), [3, 4, 5]);
      expect(list.fractionalRange(0.4, 0.5), [2]);
      expect(list.fractionalRange(0.5, 0.6), [3]);

      expect([1, 2].fractionalRange(0.49, 0.51), [1]);
    });
  });
}
