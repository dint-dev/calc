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

/// Abstract superclass for probability distributions.
///
/// # Available distributions
/// ## Discrete
///   * [BinomialDistribution]
///   * [Frequencies]
///   * [PoissonDistribution]
///
/// ## Uniform
///   * [NormalDistribution]
///   * [UniformDistribution]
///
abstract class Distribution<T> {
  const Distribution();

  /// Maps samples of the distribution with the given function.
  ///
  /// # Example
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   // Normally distributed dates around 2020-01-01
  ///   final distribution = NormalDistribution(mean=0.0, variance:1.0).map((x) {
  ///     return DateTime(2020, 01, 01).add(Duration(days: x.toInt()));
  ///   });
  ///
  ///   // Generate a random DateTime
  ///   final dateTime = distribution.sample();
  /// }
  /// ```
  Distribution<R> map<R>(R Function(T value) f) {
    return _MappedDistribution<T, R>(this, f);
  }

  /// Generates a random sample.
  ///
  /// # Example
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   final distribution = NormalDistribution(mean=0.0, variance:1.0);
  ///   final sample = distribution.sample();
  /// }
  /// ```
  T sample({Random? random});

  /// Generates a list of N random samples.
  ///
  /// # Example
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   final distribution = NormalDistribution(mean=0.0, variance:1.0);
  ///   final sampleList = distribution.sampleList(100);
  /// }
  /// ```
  List<T> sampleList(int length, {Random? random}) {
    random ??= Random();
    return List<T>.generate(length, (i) => sample(random: random));
  }
}

class _MappedDistribution<A, B> extends Distribution<B> {
  final Distribution<A> _distribution;
  final B Function(A value) _function;

  _MappedDistribution(this._distribution, this._function);

  @override
  B sample({Random? random}) => _function(_distribution.sample());
}