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
  group('UniformDistribution', () {
    test('== / hashCode', () {
      final value = UniformDistribution(2.0, 3.0);
      final clone = UniformDistribution(2.0, 3.0);
      final other0 = UniformDistribution(-9999.0, 3.0);
      final other1 = UniformDistribution(2.0, 9999.0);

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
    });
    test('pdf', () {
      final distribution = UniformDistribution(0.2, 0.3);
      expect(distribution.pdf(0.199), 0.0);
      expect(distribution.pdf(0.2), 10.000000000000002);
      expect(distribution.pdf(0.25), 10.000000000000002);
      expect(distribution.pdf(0.3), 10.000000000000002);
      expect(distribution.pdf(0.311), 0.0);
    });
    test('cdf', () {
      final distribution = UniformDistribution(0.2, 0.3);
      expect(distribution.cdf(0.1), 0.0);
      expect(distribution.cdf(0.2), 0.0);
      expect(distribution.cdf(0.21), 0.09999999999999984);
      expect(distribution.cdf(0.25), 0.5);
      expect(distribution.cdf(0.3), 1.0);
      expect(distribution.cdf(0.4), 1.0);
    });
    test('sample()', () {
      final distribution = UniformDistribution(0.2, 0.3);
      final x = distribution.sampleList(100);
      expect(x.toSet(), hasLength(greaterThan(50)));
      expect(x, everyElement(greaterThanOrEqualTo(0.2)));
      expect(x, everyElement(lessThanOrEqualTo(0.3)));
    });
  });
}
