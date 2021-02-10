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
  group('ContinuousDistribution', () {
    test('slice(min: _)', () {
      final distribution = NormalDistribution(
        mean: 0.0,
        variance: 1.0,
      ).slice(min: 0.0);
      expect(
        distribution.sampleList(1000),
        everyElement(greaterThanOrEqualTo(0.0)),
      );
      expect(distribution.sampleList(1000), contains(greaterThan(1.0)));
    });
    test('slice(max: _)', () {
      final distribution = NormalDistribution(
        mean: 0.0,
        variance: 1.0,
      ).slice(max: 0.0);
      expect(
        distribution.sampleList(1000),
        everyElement(lessThanOrEqualTo(0.0)),
      );
      expect(distribution.sampleList(1000), contains(lessThan(-1.0)));
    });
    test('slice(min: _, max: _)', () {
      final distribution = NormalDistribution(
        mean: 0.0,
        variance: 1.0,
      ).slice(min: -1.0, max: 1.0);
      expect(
        distribution.sampleList(1000),
        everyElement(greaterThanOrEqualTo(-1.0)),
      );
      expect(
        distribution.sampleList(1000),
        everyElement(lessThanOrEqualTo(1.0)),
      );
    });
  });
}
