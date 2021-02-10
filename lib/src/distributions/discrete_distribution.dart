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

/// Abstract superclass for discrete distributions.
abstract class DiscreteDistribution<T> extends Distribution<T> {
  const DiscreteDistribution();

  /// Maps the distribution with the given function.
  ///
  /// # Reverse function
  /// You can optionally define a reverse function.
  /// If you don't define `reverse` function, [pmf] will throw
  /// [UnsupportedError].
  @override
  DiscreteDistribution<R> map<R>(R Function(T value) f,
      {T Function(R value)? reverse}) {
    return _MappedDiscreteDistribution<T, R>(this, f, reverse);
  }

  /// Probability mass function (PMF) tells probability of specific event.
  ///
  /// # Example
  /// In this example, we use [Frequencies].
  ///
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   // Two cats and two other animals
  ///   final frequencies = Frequencies<String>.from([
  ///     'dog',
  ///     'cat',
  ///     'rabbit',
  ///     'cat',
  ///   ]);
  ///
  ///   final catPmf = frequencies.pmf('cat'); // --> 0.5
  ///   print('Likelihood of cats based on the seen data: $catPmf');
  /// }
  /// ```
  double pmf(T value);
}


class _MappedDiscreteDistribution<A, B> extends DiscreteDistribution<B> {
  final DiscreteDistribution<A> _distribution;
  final B Function(A value) _function;
  final A Function(B value)? _reverse;

  _MappedDiscreteDistribution(
      this._distribution, this._function, this._reverse);

  @override
  double pmf(B value) {
    final reverse = _reverse;
    if (reverse == null) {
      throw StateError(
          'You did not define reverse function when you called `$_distribution.map(...)`.');
    }
    return _distribution.pmf(reverse(value));
  }

  @override
  B sample({Random? random}) => _function(_distribution.sample());
}