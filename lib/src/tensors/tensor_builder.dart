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
  /// Data, which may contain more elements than `length`.
  List<T> get data;

  /// Length of the tensor.
  int get length => tensorShape.numberOfElements;

  /// Shape of the tensor.
  TensorShape get tensorShape;
  set tensorShape(TensorShape value);

  /// Adds elements of the argument (`x = x + argument`).
  ///
  /// The value of element `i` will be:
  /// ```
  /// elements[i] = elements[i] + right[i]
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes is non-equal.
  void add(Tensor<T> right);

  /// Builds tensor and resets [data] to empty list.
  ///
  /// If [recycle] is `true`, [data] is not reset and the tensor will be
  /// recycled the next [build] is called (only if [tensorShape] is equal and
  /// [data] is identical).
  Tensor<T> build({bool recycle=false});

  /// Clamps elements of this tensor.
  ///
  /// Throws [ArgumentError] if tensor shapes is non-equal.
  void clamp(T lowerLimit, T upperLimit);

  /// Divides elements by elements of the argument.
  ///
  /// The value of element `i` will be:
  /// ```
  /// elements[i] = elements[i] / right[i]
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes is non-equal.
  void div(Tensor<T> right);

  /// Divides elements by a scalar.
  void divScalar(num value);

  /// Rounds elements.
  void round();

  /// Gets element value.
  T getXY(int x, int y) {
    final tensorShape = this.tensorShape;
    if (tensorShape.numberOfDimensions!=2) {
      throw ArgumentError('Shape of the tensor is: $tensorShape');
    }
    if (x<0 || x>=tensorShape.x) {
      throw ArgumentError.value(x, 'x');
    }
    if (y<0 || y>=tensorShape.y) {
      throw ArgumentError.value(y, 'y');
    }
    return data[x+tensorShape.x*y];
  }

  /// Multiplies elements by elements of the argument.
  ///
  /// The value of element `i` will be:
  /// ```
  /// elements[i] = elements[i] * right[i]
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes is non-equal.
  void mul(Tensor<T> right);

  /// Multiplies elements by a scalar.
  void mulScalar(num value);

  /// Negates elements.
  void neg();

  /// Initializes shape and element values with the tensor.
  void setTensor(Tensor<T> tensor);

  /// Sets element value.
  void setXY(int x, int y, T value) {
    final tensorShape = this.tensorShape;
    if (tensorShape.numberOfDimensions!=2) {
      throw ArgumentError('Shape of the tensor is: $tensorShape');
    }
    if (x<0 || x>=tensorShape.x) {
      throw ArgumentError.value(x, 'x');
    }
    if (y<0 || y>=tensorShape.y) {
      throw ArgumentError.value(y, 'y');
    }
    data[x+tensorShape.x*y] = value;
  }

  /// Squares elements (`x = x*x`).
  void sq();

  /// Square roots elements (`x = x*x`).
  void sqrt();

  /// Subtracts elements of the arguments.
  ///
  /// The value of element `i` will be:
  /// ```
  /// elements[i] = elements[i] - right[i]
  /// ```
  ///
  /// Throws [ArgumentError] if tensor shapes is non-equal.
  void sub(Tensor<T> right);

  /// Constructs a new [TensorBuilder] that has this tensor.
  ///
  /// If `copy` is `false`, this tensor is not copied to the tensor builder.
  TensorBuilder<T> toBuilder({bool copy=true});
}