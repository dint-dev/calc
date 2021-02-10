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
  group('PoissonDistribution', () {
    test('== / hashCode', () {
      final value = PoissonDistribution(rate: 0.25);
      final clone = PoissonDistribution(rate: 0.25);
      final other0 = PoissonDistribution(rate: 0.9999);

      expect(value, clone);
      expect(value, isNot(other0));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
    });
    test('pmf when rate=0.0', () {
      final distribution = PoissonDistribution(rate: 0.0);
      expect(distribution.pmf(0), 1.0);
      expect(distribution.pmf(1), 0.0);
      expect(distribution.pmf(2), 0.0);
      expect(distribution.pmf(3), 0.0);
    });
    test('pmf when rate=0.3', () {
      final distribution = PoissonDistribution(rate: 0.3);
      expect(distribution.pmf(0), 0.7408182206817179);
      expect(distribution.pmf(1), 0.22224546620451535);
      expect(distribution.pmf(2), 0.0333368199306773);
      expect(distribution.pmf(3),
          anyOf(0.0033336819930677303, 0.00333368199306773));
    });
    test('pmf when rate=2.0', () {
      final distribution = PoissonDistribution(rate: 2.0);
      expect(distribution.pmf(0), 0.1353352832366127);
      expect(distribution.pmf(1), 0.2706705664732254);
      expect(distribution.pmf(2), 0.2706705664732254);
      expect(distribution.pmf(3), 0.1804470443154836);
    });
    test('sample() when rate=0.000000001, n=100', () {
      final distribution = PoissonDistribution(rate: 0.000000001);
      final x = distribution.sampleList(100);
      expect(x, everyElement(0));
    });
    test('sample() when rate=0.3, n=100', () {
      final distribution = PoissonDistribution(rate: 0.3);
      final x = distribution.sampleList(100);
      expect(x.where((element) => element == 0), hasLength(greaterThan(10)));
      expect(x.where((element) => element == 2), hasLength(greaterThan(1)));
    });
  });
}
