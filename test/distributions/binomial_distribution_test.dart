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
  group('BinomialDistribution', () {
    test('== / hashCode', () {
      final value = BinomialDistribution(n: 10, p: 0.25);
      final clone = BinomialDistribution(n: 10, p: 0.25);
      final other0 = BinomialDistribution(n: 9999, p: 0.25);
      final other1 = BinomialDistribution(n: 10, p: 0.9999);

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
    });
    test('when p=0', () {
      final distribution = BinomialDistribution(p: 0.0, n: 3);
      expect(distribution.pmf(0), 1.0);
      expect(distribution.pmf(1), 0.0);
    });
    test('when n=0', () {
      final distribution = BinomialDistribution(p: 0.4, n: 0);
      expect(distribution.pmf(0), 1.0);
      expect(distribution.pmf(1), 0.0);
    });
    test('pmf', () {
      final distribution = BinomialDistribution(p: 0.4, n: 3);
      expect(distribution.pmf(0), anyOf(0.216, 0.21599999999999997));
      expect(distribution.pmf(1), 0.43200000000000005);
      expect(distribution.pmf(2), 0.28800000000000003);
      expect(distribution.pmf(3), 0.06400000000000002);
      expect(distribution.pmf(4), 0.0);
    });
    test('sample() when p=0.0000000001, n=100', () {
      final distribution = BinomialDistribution(p: 0.0000000001, n: 10);
      final x = distribution.sampleList(100);
      expect(x, everyElement(0));
    });
    test('sample() when p=0.4, n=100', () {
      final distribution = BinomialDistribution(p: 0.4, n: 10);
      final x = distribution.sampleList(100);
      expect(x, contains(0));
      expect(x, contains(1));
    });
  });
}
