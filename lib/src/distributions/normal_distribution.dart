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

/// Normal distribution (also known as Gaussian distribution).
///
/// # Example
/// ```
/// import 'package:calc/calc.dart';
///
/// void main() {
///   final distribution = NormalDistribution(mean: 2.0, variance:1.0);
///
///   // Print 100 samples
///   final samples = distribution.sampleList(100);
///   print(samples);
/// }
/// ```
class NormalDistribution extends ContinuousDistribution {
  /// Mean of the distribution.
  final double mean;

  /// Variance of the distribution.
  final double variance;

  /// Constructs a normal distribution with the given mean and variance.
  NormalDistribution({
    required this.mean,
    required this.variance,
  });

  /// Fits normal distribution to the scalars.
  ///
  /// If you are fitting normal distribution to tensors, use [fitTensors].
  factory NormalDistribution.fit(Iterable<num> iterable) {
    return NormalDistribution(
      mean: iterable.mean(),
      variance: iterable.variance(),
    );
  }

  @override
  int get hashCode => mean.hashCode ^ variance.hashCode;

  /// Standard deviation.
  double get standardDeviation => sqrt(variance);

  @override
  bool operator ==(Object other) =>
      other is NormalDistribution &&
      mean == other.mean &&
      variance == other.variance;

  @override
  double cdf(double x) {
    return 0.5 * _erfc(-(x - mean) / (standardDeviation * sqrt(2)));
  }

  @override
  double pdf(double x) {
    if (x.isNaN) {
      throw ArgumentError.value(x);
    }
    if (x == double.negativeInfinity) {
      return 0.0;
    }
    if (x == double.infinity) {
      return 1.0;
    }
    final mean = this.mean;
    final variance = this.variance;
    if (variance == 0.0) {
      return x < mean ? 0.0 : 1.0;
    }
    final t = (x - mean) / variance;
    return (1 / (variance * sqrt(2 * pi))) * pow(e, -0.5 * t * t);
  }

  @override
  double sample({Random? random}) {
    random ??= Random();

    // Box-Muller polar form algorithm
    var x1 = 0.0;
    var x2 = 0.0;
    var w = 0.0;
    do {
      x1 = (2.0 * random.nextDouble()) - 1.0;
      x2 = (2.0 * random.nextDouble()) - 1.0;
      w = (x1 * x1) + (x2 * x2);
    } while (w >= 1.0);
    final r = x1 * sqrt((-2.0 * log(w)) / w);

    return r * standardDeviation + mean;
  }

  @override
  String toString() {
    return 'NormalDistribution(mean: $mean, variance: $variance)';
  }

  /// Constructs a distribution for the tensors.
  ///
  /// Each tensor index is assumed to have independent normal distribution.
  ///
  /// If you are fitting normal distribution to scalars, use [fitScalars].
  static TensorDistribution fitTensors(Iterable<Tensor<double>> iterable) {
    return TensorDistribution.fitScalarsIndependently(
      iterable,
      (iterable) => NormalDistribution.fit(iterable),
    );
  }

  // ERFC function.
  static double _erfc(double x) {
    var z = x.abs();
    var t = 1 / (1 + z / 2);
    final r9 = -0.82215223 + t * 0.17087277;
    final r8 = 1.48851587 + t * r9;
    final r7 = -1.13520398 + t * r8;
    final r6 = 0.27886807 + t * r7;
    final r5 = -0.18628806 + t * r6;
    final r4 = 0.09678418 + t * r5;
    final r3 = 0.37409196 + t * r4;
    final r2 = 1.00002368 + t * r3;
    var r1 = t * exp(-z * z - 1.26551223 + t * r2);
    return x >= 0 ? r1 : 2 - r1;
  }
}
