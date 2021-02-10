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

import 'package:collection/collection.dart';
import 'package:calc/calc.dart';

/// A distribution that samples tensor element values from independent
/// distributions.
///
/// # Example
/// ```
/// import 'package:calc/calc.dart';
///
/// void main() {
///   // Construct a distribution for matrices 2 rows and 3 columns.
///   // Each element is sampled from unit normal distribution.
///   const distribution = TensorDistribution.filled(
///     TensorShape([2,3]),
///     NormalDistribution(mean: 0.0, variance:1.0),
///   );
///
///   // Sample the distribution.
///   final tensor = distribution.sample();
/// }
/// ```
abstract class TensorDistribution<T> extends Distribution<Tensor<T>> {
  /// Constructing a distribution where all indices have identical scalar
  /// distribution.
  factory TensorDistribution.filled(
    TensorShape shape,
    Distribution<T> distribution,
  ) {
    return TensorDistribution<T>.generate(
      shape,
      (shape, i) => distribution,
    );
  }

  /// Constructs a distribution by fitting a distribution to each index
  /// independently.
  factory TensorDistribution.fitScalarsIndependently(
    Iterable<Tensor<double>> iterable,
    Distribution<T> Function(Iterable<double> iterable) scalarFitter,
  ) {
    final shape = iterable.first.tensorShape;
    assert(iterable.skip(1).every((element) => element.tensorShape == shape));
    return TensorDistribution.generate(shape, (shape, index) {
      return scalarFitter(iterable.map((e) => e.elements[index]));
    });
  }

  /// Generates distribution for each index independently.
  factory TensorDistribution.generate(
    TensorShape shape,
    Distribution<T> Function(TensorShape shape, int index) generator,
  ) {
    final distributions =
        List<Distribution<T>>.generate(shape.numberOfElements, (index) {
      return generator(shape, index);
    });
    return _TensorDistribution<T>(shape, distributions);
  }

  /// Distribution for each (flat) index of the tensor.
  List<Distribution<T>> get distributions;

  /// Shape of the tensor.
  TensorShape get shape;
}

class _TensorDistribution<T> extends Distribution<Tensor<T>>
    implements TensorDistribution<T> {
  @override
  final TensorShape shape;

  @override
  final List<Distribution<T>> distributions;

  _TensorDistribution(
    this.shape,
    this.distributions,
  );

  @override
  int get hashCode =>
      shape.hashCode ^ const ListEquality<Distribution>().hash(distributions);

  @override
  bool operator ==(Object other) {
    return other is _TensorDistribution<T> &&
        shape == other.shape &&
        const ListEquality<Distribution>()
            .equals(distributions, other.distributions);
  }

  @override
  Tensor<T> sample({Random? random}) {
    final distributions = this.distributions;
    return Tensor.generate(
      shape,
      (b, i) =>
          distributions[i].sample(random: random) as double, // <-- Could fail
    ) as Tensor<T>; // <-- Could  fail
    // TODO: Decide how to support integer tensor distributions
  }

  @override
  String toString() => 'TensorDistribution(...)';
}
