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

/// Poisson distribution.
class PoissonDistribution extends DiscreteDistribution<int> {
  final double rate;

  const PoissonDistribution({required this.rate});

  @override
  int get hashCode => rate.hashCode;

  @override
  bool operator ==(Object other) =>
      other is PoissonDistribution && rate == other.rate;

  @override
  double pmf(int value) {
    return pow(rate, value) * pow(e, -rate) / factorial(value);
  }

  @override
  int sample({Random? random}) {
    var sum = 0;
    while (true) {
      random ??= Random();
      if (random.nextDouble() > rate) {
        return sum;
      }
      sum++;
    }
  }

  Distribution<double> toDouble() {
    return map<double>((v) => v.toDouble(), reverse: (v) => v.toInt());
  }

  @override
  String toString() => 'PoissonDistribution(rate: $rate)';
}
