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

/// Mathematical/statistical methods for `Tensor<double>` iterables.
extension TensorIterableCalc<T extends Tensor> on Iterable<T> {
  /// Calculates element-wise mean of tensors.
  ///
  /// Throws [StateError] if the iterable is empty.
  ///
  /// # Example
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   final a = Vector
  /// }
  /// ```
  T mean() {
    if (isEmpty) {
      throw StateError('Iterable is empty');
    }
    final builder = first.toBuilder();
    for (var item in skip(1)) {
      builder.add(item);
    }
    builder.divScalar(length);
    return builder.build() as T;
  }

  /// Calculates element-wise sum of tensors.
  ///
  /// Throws [StateError] if the iterable is empty.
  T sum() {
    if (isEmpty) {
      throw StateError('Iterable is empty');
    }
    final builder = first.toBuilder();
    for (var item in skip(1)) {
      builder.add(item);
    }
    return builder.build() as T;
  }

  /// Calculates element-wise variance of tensors.
  ///
  /// Throws [StateError] if the iterable is empty.
  T variance() {
    if (isEmpty) {
      throw StateError('Iterable is empty');
    }
    final mean = this.mean();
    final resultBuilder = mean.toBuilder(copy: false);
    resultBuilder.tensorShape = mean.tensorShape;
    final squaredBuilder = resultBuilder.toBuilder(copy: false);
    var n = 0;
    for (var item in this) {
      squaredBuilder.setTensor(item);
      squaredBuilder.sub(mean);
      squaredBuilder.sq();
      resultBuilder.add(squaredBuilder.build(recycle: true));
      n++;
    }
    resultBuilder.divScalar(n);
    return resultBuilder.build() as T;
  }

  T standardDeviation() => variance().sqrt() as T;

  /// Maps tensors to scalars.
  ///
  /// Throws [StateError] if any tensor is not a vector of length 1.
  Iterable<double> toScalars() => map((e) => e.toScalar());
}
