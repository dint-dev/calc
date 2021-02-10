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

/// Binomial distribution.
class BinomialDistribution extends DiscreteDistribution<int> {
  /// Probability of each trial.
  final double p;

  /// Number of trials.
  final int n;

  const BinomialDistribution({required this.p, required this.n});

  @override
  int get hashCode => p.hashCode ^ n.hashCode;

  @override
  bool operator ==(Object other) =>
      other is BinomialDistribution && p == other.p && n == other.n;

  @override
  double pmf(int k) {
    if (k > n) {
      return 0.0;
    }
    return binomialCoefficient(n, k).toDouble() * pow(p, k) * pow(1 - p, n - k);
  }

  @override
  int sample({Random? random}) {
    var sum = 0;
    while (true) {
      random ??= Random();
      if (random.nextDouble() > p) {
        return sum;
      }
      sum++;
    }
  }

  Distribution<double> toDouble() {
    return map<double>((v) => v.toDouble(), reverse: (v) => v.toInt());
  }

  @override
  String toString() => 'BinomialDistribution(p: $p)';
}
