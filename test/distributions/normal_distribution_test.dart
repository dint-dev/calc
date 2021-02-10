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
  group('NormalDistribution', () {
    test('== / hashCode', () {
      final value = NormalDistribution(mean: 2.0, variance: 3.0);
      final clone = NormalDistribution(mean: 2.0, variance: 3.0);
      final other0 = NormalDistribution(mean: 9999.0, variance: 3.0);
      final other1 = NormalDistribution(mean: 2.0, variance: 9999.0);

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
    });
    test('when mean=0.0, variance=0.0', () {
      final distribution = NormalDistribution(mean: 0.0, variance: 0.0);
      // pdf()
      expect(distribution.pdf(-0.001), 0.0);
      expect(distribution.pdf(0.001), 1.0);

      // pcf()
      expect(distribution.cdf(-0.001), 0.0);
      expect(distribution.cdf(0.001), 1.0);

      // sample()
      expect(distribution.sampleList(100), everyElement(0.0));
    });
    test('when mean=2.0, variance=0.0', () {
      final distribution = NormalDistribution(mean: 2.0, variance: 0.0);

      // pdf()
      expect(distribution.pdf(1.999), 0.0);
      expect(distribution.pdf(2.001), 1.0);

      // pcf()
      expect(distribution.cdf(1.999), 0.0);
      expect(distribution.cdf(2.001), 1.0);

      // sample()
      expect(distribution.sampleList(100), everyElement(2.0));
    });
    test('when mean=2.0, variance=1.0', () {
      final distribution = NormalDistribution(mean: 2.0, variance: 1.0);

      // pdf()
      expect(distribution.pdf(-1.0), 0.004431848411938008);
      expect(distribution.pdf(1.0), 0.24197072451914337);
      expect(distribution.pdf(2.0), 0.3989422804014327);
      expect(distribution.pdf(3.0), 0.24197072451914337);
      expect(distribution.pdf(5.0), 0.004431848411938008);

      // cdf()
      expect(distribution.cdf(1.0), 0.15865526139567468);
      expect(distribution.cdf(2.0), 0.5000000150000002);
      expect(distribution.cdf(3.0), 0.8413447386043253);

      // probabilityForRange()
      expect(distribution.probabilityForRange(1.0, 3.0), 0.6826894772086507);

      // sample()
      expect(
        distribution.sampleList(1000).where((e) => e < 1.5),
        hasLength(lessThan(400)),
      );
    });
    test('sample() when mean = 100, variance = 100, n = 1000 has no values near 0', () {
      final distribution = NormalDistribution(mean: 100.0, variance: 100.0);
      expect(
        distribution.sampleList(1000).where((e) => e < 1.0),
        isEmpty,
      );
    });
    test('sample() when mean = 100, variance = 10 000, n = 1000 has values near 0', () {
      final distribution = NormalDistribution(mean: 100.0, variance: 10000.0);
      expect(
        distribution.sampleList(1000).where((e) => e < 1.0),
        isNotEmpty,
      );
    });
  });
}
