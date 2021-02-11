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
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

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
  /// Returns elements as a list.
  List<T> get elements;

  @override
  int get hashCode =>
      tensorShape.hashCode ^ const ListEquality().hash(elements);

  /// Tells whether the tensor is a scalar.
  bool get isScalar => tensorShape == TensorShape.scalar;

  /// Tells whether all elements are zero.
  bool get isZero;

  /// Returns number of elements in the tensor.
  int get length => elements.length;

  /// Returns shape of the tensor.
  TensorShape get tensorShape;

  /// Calculates element-wise product.
  ///
  /// The formula for result element `i` is:
  /// ```
  /// elements[i] * right.elements[i];
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  Tensor<T> operator *(Tensor<T> right) {
    final builder = toBuilder();
    builder.mul(right);
    return builder.build();
  }

  /// Calculates element-wise sum.
  ///
  /// The formula for result element `i` is:
  /// ```
  /// elements[i] + right.elements[i];
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  Tensor<T> operator +(Tensor<T> right) {
    final builder = toBuilder();
    builder.add(right);
    return builder.build();
  }

  /// Calculates element-wise difference.
  ///
  /// The formula for result element `i` is:
  /// ```
  /// elements[i] - right.elements[i];
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  Tensor<T> operator -(Tensor<T> right) {
    final builder = toBuilder();
    builder.sub(right);
    return builder.build();
  }

  /// Calculates `scale(-1.0)`.
  ///
  /// The formula for result element `i` is:
  /// ```
  /// -elements[i];
  /// ```
  ///
  /// The returned tensor will have identical type and [tensorShape].
  Tensor<T> operator -() {
    final builder = toBuilder();
    builder.neg();
    return builder.build();
  }

  /// A shorthand for [div].
  @nonVirtual
  Tensor<T> operator /(Tensor<T> right) => div(right);

  @override
  bool operator ==(Object other) {
    return other is Tensor<T> &&
        tensorShape == other.tensorShape &&
        const ListEquality().equals(elements, other.elements);
  }

  /// Calculates `x.ceil()` for each element.
  Tensor<T> ceil() => (toBuilder()..ceil()).build();

  /// Calculates `x.clamp(lowerLimit, upperLimit)` for each element.
  Tensor<T> clamp(T lowerLimit, T upperLimit) =>
      (toBuilder()..clamp(lowerLimit, upperLimit)).build();

  /// Calculates `cos(x)` for each element.
  Tensor<T> cos() => (toBuilder()..cos()).build();

  /// Calculates element-wise fraction.
  ///
  /// The formula for result element `i` is:
  /// ```
  /// elements[i] / right.elements[i];
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  Tensor<T> div(
    Tensor<T> right, {
    bool noNan = false,
  }) {
    final builder = toBuilder();
    builder.div(right, noNan: noNan);
    return builder.build();
  }

  /// Calculates element-wise fraction.
  ///
  /// The formula for result element `i` is:
  /// ```
  /// elements[i] / scalar;
  /// ```
  ///
  /// If [swapArguments] is true, the formula is:
  /// ```
  /// scalar / this[i];
  /// ```
  ///
  /// If denominator is 0.0, the result is [double.nan] when using
  /// floating-point numbers and 0 when using integers. If [noNan] is true,
  /// the result is 0 when using floating-point numbers.
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  ///
  /// # Example
  /// ```
  /// // Element i will be:
  /// //     1/x[i];
  /// tensor.divScalar(1, swapArguments:true);
  /// ```
  Tensor<T> divScalar(
    num right, {
    bool noNan = false,
    bool swapArguments = false,
  }) {
    final builder = toBuilder();
    builder.divScalar(right, noNan: noNan, swapArguments: swapArguments);
    return builder.build();
  }

  /// Calculates `exp(x)` for each element.
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  Tensor<T> exp() => (toBuilder()..exp()).build();

  /// Calculates `x.floor()` for each element.
  Tensor<T> floor() => (toBuilder()..floor()).build();

  @Deprecated('Use `elements`')
  T getFlat(int index) {
    return elements[index];
  }

  /// Calculates `log(x)` for each element.
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  Tensor<T> log() => (toBuilder()..log()).build();

  /// Calculates element-wise maximum.
  ///
  /// The formula for result element `i` is:
  /// ```
  /// result[i] = max(elements[i], right.elements[i]);
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  Tensor<T> max(Tensor<T> right) {
    final builder = toBuilder();
    builder.max(right);
    return builder.build();
  }

  /// Calculates element-wise minimum.
  ///
  /// The formula for result element `i` is:
  /// ```
  /// min(elements[i], right.elements[i]);
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  Tensor<T> min(Tensor<T> right) {
    final builder = toBuilder();
    builder.min(right);
    return builder.build();
  }

  /// Multiplies tensor elements with a scalar.
  ///
  /// The formula for result element `i` is:
  /// ```
  /// s * elements[i];
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  Tensor mulScalar(num s) {
    final builder = toBuilder();
    builder.mulScalar(s);
    return builder.build();
  }

  /// Calculates element-wise power.
  ///
  /// The formula for result element `i` is:
  /// ```
  /// pow(elements[i], right.elements[i]);
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  Tensor<T> pow(Tensor<T> right) {
    final builder = toBuilder();
    builder.pow(right);
    return builder.build();
  }

  @Deprecated('Use `mulScalar`')
  Tensor scale(num s) => mulScalar(s);

  @Deprecated('Use `divScalar`')
  Tensor scaleInverse(num s) => divScalar(s);

  /// Calculates `sin(x)` for each element.
  Tensor<T> sin() => (toBuilder()..sin()).build();

  /// Calculates `x * x` (square) for each element.
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  Tensor<T> sq() => (toBuilder()..sq()).build();

  /// Calculates `sqrt(x)` (square root) for each element.
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  Tensor<T> sqrt() => (toBuilder()..sqrt()).build();

  /// Calculates `tan(x)` for each element.
  Tensor<T> tan() => (toBuilder()..tan()).build();

  /// Constructs a [TensorBuilder] that has this tensor.
  ///
  /// If [copy] is `false`, this is tensor is not copied to the builder.
  TensorBuilder<T> toBuilder({bool copy = true});

  /// Returns a scalar when the tensor has only a single element;
  ///
  /// Throws [StateError] the shape is not a scalar.
  T toScalar() {
    final tensorShape = this.tensorShape;
    if (tensorShape == TensorShape.scalar) {
      return elements.single;
    }
    throw UnsupportedError('Shape of the tensor is not a scalar: $tensorShape');
  }

  static Tensor<double> filled(TensorShape shape, [double value = 0.0]) {
    final builder = Float32TensorBuilder();
    builder.tensorShape = shape;
    final data = builder.elements;
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
    for (var i = 0; i < n; i++) {
      builder.elements[i] = generator(shape, i);
    }
    return builder.build();
  }

  static Vector<double> scalar(double value) {
    return filled(TensorShape.scalar, value) as Vector<double>;
  }
}
