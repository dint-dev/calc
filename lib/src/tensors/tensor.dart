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

/// Superclass for tensors where elements may be integers, real numbers, or
/// complex numbers.
///
/// # Implementations
/// ## 32-bit floating points
///   * [Float32Tensor]
///   * [Float32TensorBuilder]
///   * [Float32Matrix]
///   * [Float32Vector]
///
abstract class Tensor<T> {
  @override
  int get hashCode =>
      tensorShape.hashCode ^ const ListEquality().hash(elements());

  /// Tells whether the tensor is a scalar.
  bool get isScalar => tensorShape == TensorShape.scalar;

  /// Tells whether all elements are zero.
  bool get isZero;

  /// Returns number of elements in the tensor.
  int get length => elements().length;

  /// Returns shape of the tensor.
  TensorShape get tensorShape;

  /// Calculates element-wise product.
  ///
  /// The formula for result element `i` is `result[i] = left[i] * right[i]`.
  ///
  /// The returned tensor will have identical type and [tensorShape].
  Tensor<T> operator *(Tensor<T> right) {
    final builder = toBuilder();
    builder.mul(right);
    return builder.build();
  }

  /// Calculates element-wise sum.
  ///
  /// The formula for result element `i` is `result[i] = left[i] + right[i]`.
  ///
  /// The returned tensor will have identical type and [tensorShape].
  Tensor<T> operator +(Tensor<T> right) {
    final builder = toBuilder();
    builder.add(right);
    return builder.build();
  }

  /// Calculates element-wise difference.
  ///
  /// The formula for result element `i` is `result[i] = left[i] - right[i]`.
  ///
  /// The returned tensor will have identical type and [tensorShape].
  Tensor<T> operator -(Tensor<T> right) {
    final builder = toBuilder();
    builder.sub(right);
    return builder.build();
  }

  /// Calculates `scale(-1.0)`.
  ///
  /// The formula for result element `i` is `result[i] = -this[i]`.
  ///
  /// The returned tensor will have identical type and [tensorShape].
  Tensor<T> operator -() {
    final builder = toBuilder();
    builder.neg();
    return builder.build();
  }

  /// Calculates element-wise fraction.
  ///
  /// The formula for result element `i` is `result[i] = left[i] / right[i]`.
  ///
  /// The returned tensor will have identical type and [tensorShape].
  Tensor<T> operator /(Tensor<T> right) {
    final builder = toBuilder();
    builder.div(right);
    return builder.build();
  }

  @override
  bool operator ==(Object other) {
    return other is Tensor<T> &&
        tensorShape == other.tensorShape &&
        const ListEquality().equals(elements(), other.elements());
  }

  /// Returns elements as a list.
  List<T> elements();

  /// Returns element using flat indexing.
  T getFlat(int index) {
    return elements()[index];
  }

  /// Multiplies every element by scalar `s`.
  ///
  /// The returned tensor will have identical type and [tensorShape].
  Tensor scale(num s) {
    final builder = toBuilder();
    builder.mulScalar(s);
    return builder.build();
  }

  /// Divides every element is divided by scalar `s`. This may be numerically
  /// more accurate than multiplying by `1/s`.
  ///
  /// The returned tensor will have identical type and [tensorShape].
  Tensor scaleInverse(num s) {
    final builder = toBuilder();
    builder.divScalar(s);
    return builder.build();
  }

  /// Calculates square of each element.
  Tensor<T> clamp(T lowerLimit, T upperLimit) => (toBuilder()..clamp(lowerLimit, upperLimit)).build();

  /// Calculates square of each element.
  Tensor<T> sq() => (toBuilder()..sq()).build();

  /// Calculates square root of each element.
  Tensor<T> sqrt() => (toBuilder()..sqrt()).build();

  /// Constructs a [TensorBuilder] that has this tensor.
  ///
  /// If [copy] is `false`, this is tensor is not copied to the builder.
  TensorBuilder<T> toBuilder({bool copy=true});

  /// Returns a scalar when the tensor has only a single element;
  ///
  /// Throws [StateError] the shape is not a scalar.
  T toScalar() {
    final tensorShape = this.tensorShape;
    if (tensorShape == TensorShape.scalar) {
      return elements().single;
    }
    throw UnsupportedError('Shape of the tensor is not a scalar: $tensorShape');
  }

  static Tensor<double> filled(TensorShape shape, [double value = 0.0]) {
    final builder = Float32TensorBuilder();
    builder.tensorShape = shape;
    final data =builder.data;
    data.fillRange(0, data.length, value);
    return builder.build();
  }

  static Tensor<double> generate(
      TensorShape shape,
      double Function(TensorShape shape, int i) generator,
      ) {
    final builder = Float32TensorBuilder();
    builder.tensorShape = shape;
    final n = shape.numberOfElements;
    for (var i=0;i<n;i++) {
      builder.data[i] = generator(shape, i);
    }
    return builder.build();
  }

  static Vector<double> scalar(double value) {
    return filled(TensorShape.scalar, value) as Vector<double>;
  }
}
