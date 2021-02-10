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

/// Abstract superclass for continuous distributions such as
/// [NormalDistribution].
abstract class ContinuousDistribution extends Distribution<double> {
  const ContinuousDistribution();

  /// Cumulative Distribution Function (CDF).
  ///
  /// If you want to know probability for a range of values, you can use
  /// [probabilityForRange].
  double cdf(double x);

  /// Probability Density Function (PDF).
  double pdf(double x);

  /// Calculates probability that the value is in the range.
  double probabilityForRange(double min, double max) {
    if (min.isNaN) {
      throw ArgumentError.value(min, 'min');
    }
    if (max.isNaN) {
      throw ArgumentError.value(min, 'min');
    }
    if (max < min) {
      throw ArgumentError.value(max, 'max', 'Must be >= min');
    }
    return cdf(max) - cdf(min);
  }

  /// Returns a slice of the distribution.
  ///
  /// Parameter [attempts] is a hint for the number of iterations in rejection
  /// sampling. The default value is unspecified.
  ///
  /// # Example
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   final normalDistribution = NormalDistribution(0.0, 1.0);
  ///   final allPositiveNormalDistribution = distribution.slice(min:0.0);
  /// }
  /// ```
  ContinuousDistribution slice({
    double min = double.negativeInfinity,
    double max = double.infinity,
    int? attempts,
  }) {
    if (min.isNaN || min > max) {
      throw ArgumentError.value(min, 'min');
    }
    if (max.isNaN) {
      throw ArgumentError.value(max, 'max');
    }
    if (min == double.negativeInfinity && max == double.infinity) {
      return this;
    }
    return _SlicedContinuousDistribution(this, min, max, attempts ?? 100);
  }
}

class _SlicedContinuousDistribution extends ContinuousDistribution {
  final ContinuousDistribution _distribution;
  final double _min;
  final double _max;
  final int _n;

  _SlicedContinuousDistribution(
      this._distribution, this._min, this._max, this._n);

  @override
  double cdf(double x) {
    final min = _min;
    final max = _max;
    assert(!min.isNaN);
    assert(!max.isNaN);
    if (min != double.negativeInfinity && x <= min) {
      return 0.0;
    }
    if (max != double.infinity && x >= max) {
      return 1.0;
    }
    final distribution = _distribution;
    final minMass = distribution.cdf(min);
    final massInTheRange = distribution.cdf(max) - minMass;
    return (distribution.cdf(x) - minMass) / massInTheRange;
  }

  @override
  double pdf(double x) {
    if (x < _min) {
      return 0.0;
    }
    if (x > _max) {
      return 0.0;
    }
    final distribution = _distribution;
    final minMass = distribution.cdf(_min);
    final massInTheRange = distribution.cdf(_max) - minMass;
    return _distribution.pdf(x) / massInTheRange;
  }

  @override
  double sample({Random? random}) {
    // N attempts to sample valid value
    for (var i = 0; i < _n; i++) {
      final x = _distribution.sample(random: random);
      if (x >= _min && x <= _max) {
        return x;
      }
    }

    // Otherwise just clamp the result
    return _distribution.sample(random: random).clamp(_min, _max);
  }
}
