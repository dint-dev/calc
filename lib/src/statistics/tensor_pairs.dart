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

/// Holds lists [x] and [y] for calculating properties such as [correlation].
class TensorPairs<T extends Tensor> {
  /// First list of tensors.
  final List<T> x;

  /// Second list of tensors.
  final List<T> y;

  /// Constructs samples for X list and Y list.
  TensorPairs.fromTensorLists(this.x, this.y);

  @override
  int get hashCode =>
      const ListEquality().hash(x) ^ const ListEquality().hash(y);

  @override
  bool operator ==(Object other) =>
      other is TensorPairs &&
      const ListEquality().equals(x, other.x) &&
      const ListEquality().equals(y, other.y);

  /// Calculates correlation of [x] and [y].
  ///
  /// Throws [ArgumentError] when:
  ///   * The arguments have non-equal lengths.
  ///   * The arguments are empty.
  ///   * Either argument has zero variance (all elements are identical).
  ///
  /// # Example
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   final x = [1,2,3];
  ///   final y = [4,3,2];
  ///   final result = SamplesXY<int>(x, y).correlation();
  ///   print('correlation: $result');
  /// }
  /// ```
  T correlation() {
    final n = x.length;
    if (n != y.length) {
      throw ArgumentError(
          'Arguments have different lengths: ${x.length} != ${y.length}');
    }
    if (n == 0) {
      throw ArgumentError('Arguments are empty');
    }
    final xVariance = x.variance();
    if (xVariance.elements.contains(0.0)) {
      if (xVariance.isScalar) {
        throw ArgumentError('Variance of `x` is zero');
      }
      throw ArgumentError('Variance of `x` has a zero element');
    }
    final yVariance = y.variance();
    if (yVariance.elements.contains(0.0)) {
      if (yVariance.isScalar) {
        throw ArgumentError('Variance of `y` is zero');
      }
      throw ArgumentError('Variance of `y` has a zero element');
    }
    return covariance() / (xVariance * yVariance) as T;
  }

  /// Calculates covariance of [x] and [y].
  ///
  /// Throws [ArgumentError] when:
  ///   * The arguments have non-equal lengths.
  ///   * The arguments are empty.
  ///
  /// # Example
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   final x = [1,2,3];
  ///   final y = [4,3,2];
  ///   final result = SamplesXY<int>(x,y).covariance();
  ///   print('covariance: $result');
  /// }
  /// ```
  T covariance() {
    final n = x.length;
    if (n != y.length) {
      throw ArgumentError(
          'Arguments have different lengths: ${x.length} != ${y.length}');
    }
    if (n == 0) {
      throw ArgumentError('Arguments are empty');
    }
    final meanX = x.mean();
    final meanY = y.mean();
    late Tensor sum;
    for (var i = 0; i < n; i++) {
      final term = (x[i] - meanX) * (y[i] - meanY);
      if (i == 0) {
        sum = term;
      } else {
        sum += term;
      }
    }
    return sum.scale(1 / n) as T;
  }

  /// Constructs [TensorPairs] from two lists of [int] or [double] values.
  ///
  /// # Example
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   final pairs = TensorPairs.fromScalars([1,2,3], [2,3,4]);
  ///   final correlation = pairs.correlation().toScalar();
  /// }
  /// ```
  static TensorPairs<Tensor<double>> fromScalarLists<S extends num>(
      Iterable<S> x, Iterable<S> y) {
    return TensorPairs.fromTensorLists(
      x.toTensors().toList(),
      y.toTensors().toList(),
    );
  }

  /// Generates Y values from X values.
  ///
  /// # Example
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   final x = [1,2,3];
  ///   final samples = SamplesXY<int>.generateFromX(x, (x) => 2*x);
  /// }
  /// ```
  static TensorPairs<Tensor<double>> generateFromScalarList(
      Iterable<num> x, num Function(num x) function) {
    final xList = x.toList();
    final yList = List<double>.generate(
        xList.length, (i) => function(xList[i]).toDouble());
    return TensorPairs.fromScalarLists(xList, yList);
  }
}
