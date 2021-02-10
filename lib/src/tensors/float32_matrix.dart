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

import 'dart:typed_data';

import 'package:calc/calc.dart';
import 'package:calc/calc.dart' as math;

/// Floating-point matrix that stores elements in [Float32List].
///
/// # Example
/// ```
/// import 'package:calc/calc.dart';
///
/// void main() {
///   final matrix = Matrixf.fromRows([
///     [1.0, 2.0],
///     [3.0, 4.0],
///   ]);
/// }
/// ```
class Float32Matrix extends Matrix<double> with Float32Tensor {
  /// Constructs matrix with the given width and height.
  factory Float32Matrix.filled(int width, int height, [double value = 0.0]) {
    final data = Float32List(width * height);
    if (value != 0.0) {
      data.fillRange(0, data.length, value);
    }
    return Float32Matrix.withFloat32List(data, width: width);
  }

  /// Constructs a matrix from columns.
  ///
  /// # Example
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   final matrix = Matrixf.fromColumns([
  ///     [1.0, 2.0],
  ///     [3.0, 4.0],
  ///     [5.0, 6.0],
  ///   ]);
  /// }
  /// ```
  factory Float32Matrix.fromColumns(Iterable<List<double>> columns) {
    final builder = Float32TensorBuilder();
    builder.tensorShape = TensorShape(columns.length, columns.first.length);
    var x = 0;
    for (var column in columns) {
      for (var y = 0; y < column.length; y++) {
        builder.setXY(x, y, column[y]);
      }
      x++;
    }
    return builder.build() as Float32Matrix;
  }

  /// Constructs a matrix from a column vector.
  factory Float32Matrix.fromColumnVector(Iterable<double> elements) {
    return Float32Matrix.fromColumns([elements.toList()]);
  }

  /// Constructs a matrix from the diagonal value.
  factory Float32Matrix.fromDiagonal(Iterable<double> diagonal) {
    final width = diagonal.length;
    final data = Float32List(width * width);
    var i = 0;
    for (var item in diagonal) {
      data[i * width + i] = item;
      i++;
    }
    return Float32Matrix.withFloat32List(data, width: width);
  }

  /// Constructs a matrix from rows.
  ///
  /// # Example
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   final matrix = Matrixf.fromRows([
  ///     [1.0, 2.0],
  ///     [3.0, 4.0],
  ///     [5.0, 6.0],
  ///   ]);
  /// }
  /// ```
  factory Float32Matrix.fromRows(Iterable<List<double>> rows) {
    final builder = Float32TensorBuilder();
    builder.tensorShape = TensorShape(rows.first.length, rows.length);
    var y = 0;
    for (var row in rows) {
      for (var x = 0; x < row.length; x++) {
        builder.setXY(x, y, row[x]);
      }
      y++;
    }
    return builder.build() as Float32Matrix;
  }

  /// Constructs a matrix from a row vector.
  factory Float32Matrix.fromRowVector(Iterable<double> elements) {
    return Float32Matrix.fromRows([elements.toList()]);
  }

  /// Constructs a matrix that uses the given [Float32List] for storing rows.
  factory Float32Matrix.withFloat32List(
    Float32List rows, {
    required int width,
  }) {
    final length = rows.length;
    final height = length ~/ width;
    if (width * height != length) {
      throw ArgumentError.value(
          width, 'width', 'Invalid dimensions ($width * $height != $length)');
    }
    return Float32Matrix._(TensorShape(width, height), rows);
  }

  Float32Matrix._(TensorShape tensorShape, List<double> data)
      : super(tensorShape, data) {
    final height = data.length ~/ width;
    if (height == 0 || width * height != tensorShape.numberOfElements) {
      throw ArgumentError.value(data, 'data');
    }
  }

  @override
  Float32Matrix matrixMul(Matrix<double> right) {
    final n = width;
    if (right.height != n) {
      throw ArgumentError.value(
        right,
        'right',
        'Left matrix width does not equal right matrix height: $n != ${right.height}',
      );
    }
    final dataWidth = right.width;
    final dataHeight = height;
    final builder = toBuilder();
    builder.tensorShape = TensorShape(right.width, height);
    for (var y = 0; y < dataHeight; y++) {
      for (var x = 0; x < dataWidth; x++) {
        var sum = 0.0;
        for (var i = 0; i < n; i++) {
          sum += getXY(i, y) * right.getXY(x, i);
        }
        builder.setXY(x, y, sum);
      }
    }
    return builder.build() as Float32Matrix;
  }

  @override
  Float32TensorBuilder toBuilder({bool copy = true}) {
    final builder = Float32TensorBuilder();
    if (copy) {
      builder.setTensor(this);
    }
    return builder;
  }

  @override
  String toString() {
    if (height == 1 && width <= 10) {
      return 'Float32Matrix.fromRowVector([${elements.join(', ')}])';
    }
    if (width == 1 && height <= 10) {
      return 'Float32Matrix.fromColumnVector([${elements.join(', ')}])';
    }
    if (width <= 4 && height <= 4) {
      final sb = StringBuffer();
      sb.write('Float32Matrix.fromRows([\n');
      var columnWidth = elements.map((e) => e.toString().length).max() + 3;
      for (var y = 0; y < height; y++) {
        sb.write('  [ ');
        final numbersStartIndex = sb.length;
        for (var x = 0; x < width; x++) {
          // Write comma
          if (x != 0) {
            sb.write(',  ');
          }

          // Write enough whitespace
          while (sb.length - numbersStartIndex < x * columnWidth) {
            sb.write(' ');
          }

          // Write number
          sb.write(getXY(x, y));
        }
        sb.write(' ],\n');
      }
      sb.write('])');
      return sb.toString();
    }
    return 'Float32Matrix(...; width=$width, height=$height)';
  }
}
