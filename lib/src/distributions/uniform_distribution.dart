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

/// Uniform continuous distribution.
///
/// # Example
/// ```
/// const d = UniformDistribution(1.3)
/// ```
class UniformDistribution extends ContinuousDistribution {
  final double min;
  final double max;

  const UniformDistribution(this.min, this.max)
      : assert(min != double.nan),
        assert(max != double.nan),
        assert(min <= max);

  @override
  int get hashCode => min.hashCode ^ max.hashCode;

  @override
  double cdf(double x) {
    if (x <= min) {
      return 0.0;
    }
    if (x >= max) {
      return 1.0;
    }
    return (x - min) / (max - min);
  }

  @override
  bool operator ==(Object other) =>
      other is UniformDistribution && min == other.min && max == other.max;

  @override
  double pdf(double x) {
    if (x < min) {
      return 0.0;
    }
    if (x > max) {
      return 0.0;
    }
    if (max == min) {
      return 0.0;
    }
    return 1.0 / (max - min);
  }

  @override
  double sample({Random? random}) {
    random ??= Random();
    return min + (max - min) * random.nextDouble();
  }

  @override
  String toString() => 'UniformDistribution(min: $min, max: $max)';
}
