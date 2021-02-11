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

abstract class TensorBuilder<T> {
  @deprecated
  List<T> get data => elements;

  /// Elements of the tensor.
  List<T> get elements;

  /// Length of the tensor.
  int get length => tensorShape.numberOfElements;

  /// Shape of the tensor.
  TensorShape get tensorShape;
  set tensorShape(TensorShape value);

  /// Calculates absolute value for each element.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = x[i].abs();
  /// ```
  void abs();

  /// Calculates sum of two tensors.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = x[i] + right[i];
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  void add(Tensor<T> right);

  /// Builds tensor and resets [elements] to empty list.
  ///
  /// If [recycle] is `true`, [elements] is not reset and the tensor will be
  /// recycled the next [build] is called (only if [tensorShape] is equal and
  /// [elements] is identical).
  Tensor<T> build({bool recycle = false});

  /// Calculates `ceil` for each element.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = x[i].ceil();
  /// ```
  void ceil();

  /// Clamps elements of this tensor.
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  void clamp(T lowerLimit, T upperLimit);

  /// Calculates `cos` for each element.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = cos(x[i]);
  /// ```
  void cos();

  /// Calculates fraction of two tensors.
  ///
  /// The formula for result element `i` is:
  /// ```
  /// x[i] = x[i] / scalar;
  /// ```
  ///
  /// If [swapArguments] is true, the formula is:
  /// ```
  /// x[i] = scalar / x[i];
  /// ```
  ///
  /// If denominator is 0.0, the result is [double.nan] when using
  /// floating-point numbers and 0 when using integers. If [noNan] is true,
  /// the result is 0 when using floating-point numbers.
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  void div(Tensor<T> right, {bool noNan = false, bool swapArguments = false});

  /// Divides elements.
  ///
  /// # Example
  /// ```
  /// // Element i will be:
  /// //     y[i]=1/x[i]
  /// tensor.divScalar(1, swapArguments:true);
  /// ```
  void divScalar(num value, {bool noNan = false, bool swapArguments = false});

  /// Calculates exponent for each element.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// exp(x[i]);
  /// ```
  void exp();

  /// Fills each element with the argument.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = value;
  /// ```
  void fill(T value);

  /// Calculates `floor` for each element.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = x[i].floor();
  /// ```
  void floor();

  /// Gets element value.
  T getXY(int x, int y) {
    final tensorShape = this.tensorShape;
    if (tensorShape.numberOfDimensions != 2) {
      throw ArgumentError('Shape of the tensor is: $tensorShape');
    }
    if (x < 0 || x >= tensorShape.x) {
      throw ArgumentError.value(x, 'x');
    }
    if (y < 0 || y >= tensorShape.y) {
      throw ArgumentError.value(y, 'y');
    }
    return elements[x + tensorShape.x * y];
  }

  /// Calculates logarithm for each element.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = log(x[i]);
  /// ```
  void log();

  /// Calculates element-wise maximum of the two tensors.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = max(x[i], right[i]);
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  void max(Tensor<T> right);

  /// Calculates element-wise minimum of the two tensors.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = min(x[i], right[i]);
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  void min(Tensor<T> right);

  /// Multiplies elements.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = x[i] * right[i];
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  void mul(Tensor<T> right);

  /// Multiplies elements by a scalar.
  void mulScalar(num value);

  /// Negates elements.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = -x[i];
  /// ```
  void neg();

  /// Calculates `pow(a,b)` for each element.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = pow(x[i], right[i]);
  /// ```
  ///
  /// If [swapArguments] is `true`, base and power arguments will be swapped.
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  void pow(Tensor<T> right, {bool swapArguments = false});

  /// Rounds elements.
  void round();

  /// Initializes shape and element values with the tensor.
  void setTensor(Tensor<T> tensor);

  /// Sets element value.
  void setXY(int x, int y, T value) {
    final tensorShape = this.tensorShape;
    if (tensorShape.numberOfDimensions != 2) {
      throw ArgumentError('Shape of the tensor is: $tensorShape');
    }
    if (x < 0 || x >= tensorShape.x) {
      throw ArgumentError.value(x, 'x');
    }
    if (y < 0 || y >= tensorShape.y) {
      throw ArgumentError.value(y, 'y');
    }
    elements[x + tensorShape.x * y] = value;
  }

  /// Calculates `sin` for each element.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = sin(x[i]);
  /// ```
  void sin();

  /// Calculates `a*a` for each element.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = x[i] * x[i];
  /// ```
  void sq();

  /// Calculates [sqrt] for each element.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = sqrt(x[i]);
  /// ```
  void sqrt();

  /// Subtracts elements of the arguments.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = x[i] - right[i];
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes are not equal.
  void sub(Tensor<T> right);

  /// Calculates `tan` for each element.
  ///
  /// Element `i` is calculated with the formula:
  /// ```
  /// x[i] = tan(x[i]);
  /// ```
  void tan();

  /// Constructs a new [TensorBuilder] that has this tensor.
  ///
  /// If `copy` is `false`, this tensor is not copied to the tensor builder.
  TensorBuilder<T> toBuilder({bool copy = true});
}
