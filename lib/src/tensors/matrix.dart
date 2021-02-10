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

/// A matrix.
///
/// # Implementations
///   * [Float32Matrix]
///
/// # Example
/// ```
/// import 'package:calc/calc.dart';
///
/// void main() {
///   final matrix = Float32Matrix.fromRows([
///     [1.0, 2.0],
///     [3.0, 4.0],
///   ]);
/// }
/// ```
abstract class Matrix<T> extends Tensor<T> {
  @override
  final TensorShape tensorShape;
  final List<T> _data;

  Matrix(this.tensorShape, this._data);

  int get height => tensorShape.y;

  bool get isSquare => width == height;

  int get width => tensorShape.x;

  @override
  Matrix<T> operator *(Tensor<T> right) => super * right as Matrix<T>;

  @override
  Matrix<T> operator +(Tensor<T> right) => super + right as Matrix<T>;

  @override
  Matrix<T> operator -(Tensor<T> right) => super - right as Matrix<T>;

  @override
  Matrix<T> operator /(Tensor<T> right) => super / right as Matrix<T>;

  /// Gets diagonal vector.
  Float32Vector diagonalVector() {
    if (isSquare) {
      throw UnsupportedError('Not a square matrix');
    }
    final builder = toBuilder();
    final width = this.width;
    builder.tensorShape = TensorShape(1, width);
    for (var i=0;i<width;i++) {
      builder.setXY(0,i, getXY(i,i));
    }
    builder.tensorShape = TensorShape(width);
    return builder.build() as Float32Vector;
  }

  @override
  List<T> elements() => _data;

  /// Gets matrix element.
  T getXY(int x, int y) {
    if (x >= width) {
      throw ArgumentError.value(x, 'x');
    }
    if (y >= height) {
      throw ArgumentError.value(y, 'y');
    }
    return elements()[y * width + x];
  }

  /// Computes matrix product.
  Matrix<T> matrixMul(Matrix<T> right);

  /// Computes transpose.
  Matrix<T> transpose() {
    final builder = toBuilder();
    builder.tensorShape = TensorShape(tensorShape.y, tensorShape.x);
    for (var y=0;y<height;y++) {
      for (var x = 0; x < width; x++) {
        builder.setXY(y, x, getXY(x, y));
      }
    }
    return builder.build() as Matrix<T>;
  }
}