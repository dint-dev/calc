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
  group('Frequencies', () {
    test('== / hashCode', () {
      final value = Frequencies.from([2, 2, 3]);
      final clone = Frequencies.from(
          [2, 2, 2, 2, 3, 3]); // Relative frequencies are just scaled.
      final other0 = Frequencies.from([2, 2, 3, 3]);

      expect(value, clone);
      expect(value, isNot(other0));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
    });
    test('from([])', () {
      final frequencies = Frequencies<int>.from([]);
      expect(frequencies.pmf(0), 0.0);
      expect(frequencies.pmf(1), 0.0);
      expect(frequencies.pmf(2), 0.0);
      expect(() => frequencies.sample(), throwsStateError);
    });
    test('from([2,3])', () {
      final frequencies = Frequencies<int>.from([2, 3]);
      expect(frequencies.pmf(0), 0.0);
      expect(frequencies.pmf(1), 0.0);
      expect(frequencies.pmf(2), 0.5);
      expect(frequencies.pmf(3), 0.5);
      expect(frequencies.pmf(4), 0.0);
      expect(frequencies.sampleList(100), everyElement(anyOf(2, 3)));
    });
    test('from([2,2,3,2])', () {
      final frequencies = Frequencies<int>.from([2, 2, 3, 2]);
      expect(frequencies.pmf(0), 0.0);
      expect(frequencies.pmf(1), 0.0);
      expect(frequencies.pmf(2), 0.75);
      expect(frequencies.pmf(3), 0.25);
      expect(frequencies.pmf(4), 0.0);
      expect(frequencies.sampleList(100), everyElement(anyOf(2, 3)));
      expect(
        frequencies.sampleList(1000).where((e) => e == 3),
        hasLength(lessThan(400)),
      );
    });
    test('fromMap({})', () {
      final frequencies = Frequencies<int>.fromMap({});
      expect(frequencies.pmf(0), 0.0);
      expect(frequencies.pmf(1), 0.0);
      expect(frequencies.pmf(2), 0.0);
    });
    test('fromMap({2: 3.14})', () {
      final frequencies = Frequencies<int>.fromMap({2: 3.14});
      expect(frequencies.pmf(0), 0.0);
      expect(frequencies.pmf(1), 0.0);
      expect(frequencies.pmf(2), 1.0);
      expect(frequencies.pmf(3), 0.0);
      expect(frequencies.sampleList(100), everyElement(2));
    });
    test('fromMap({2: 30, 3: 10})', () {
      final frequencies = Frequencies<int>.fromMap({2: 30, 3: 10});
      expect(frequencies.pmf(0), 0.0);
      expect(frequencies.pmf(1), 0.0);
      expect(frequencies.pmf(2), 0.75);
      expect(frequencies.pmf(3), 0.25);
      expect(frequencies.pmf(4), 0.0);
      expect(frequencies.sampleList(100), everyElement(anyOf(2, 3)));
    });
  });
}
