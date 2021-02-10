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

abstract class Float32Tensor implements Tensor<double> {
  @override
  bool get isZero => elements().every((element) => element == 0.0);

  @override
  Float32TensorBuilder toBuilder({bool copy = true});
}

class Float32TensorBuilder extends TensorBuilder<double> {
  static final Float32List _emptyData = Float32List(0);

  TensorShape _tensorShape = TensorShape.scalar;

  @override
  Float32TensorBuilder toBuilder({bool copy = true}) {
    final builder = Float32TensorBuilder();
    if (copy) {
      builder.tensorShape = tensorShape;
      builder.data.setRange(0, length, data);
    }
    return builder;
  }

  @override
  Float32List data = _emptyData;

  @override
  TensorShape get tensorShape => _tensorShape;

  @override
  set tensorShape(TensorShape value) {
    _tensorShape = value;
    final n = value.numberOfElements;
    if (data.length < n) {
      final newData = Float32List(n);
      newData.setAll(0, data);
      data = newData;
    }
  }

  Float32Tensor? _recycled;
  List<double>? _recycledData;

  @override
  Float32Tensor build({bool recycle = false}) {
    final tensorShape = this.tensorShape;
    var data = this.data;
    final recycled = _recycled;
    if (recycled != null &&
        recycled.tensorShape == tensorShape &&
        identical(_recycledData, data)) {
      if (!recycle) {
        _tensorShape = TensorShape.scalar;
        this.data = _emptyData;
      }
      return recycled;
    }
    if (!recycle) {
      _tensorShape = TensorShape.scalar;
      this.data = _emptyData;
    }
    final length = tensorShape.numberOfElements;
    if (data.length != length) {
      data = data.sublist(0, length);
    }
    switch (tensorShape.numberOfDimensions) {
      case 1:
        final result = Float32Vector.withFloat32List(data);
        if (recycle) {
          _recycled = result;
          _recycledData = data;
        }
        return result;
      case 2:
        final result = Float32Matrix.withFloat32List(
          data,
          width: tensorShape.x,
        );
        if (recycle) {
          _recycled = result;
          _recycledData = data;
        }
        return result;
      default:
        throw UnimplementedError();
    }
  }

  @override
  void add(Tensor<double> right) {
    _checkSameShape(right);
    final data = this.data;
    final rightElements = right.elements();
    final n = length;
    for (var i = 0; i < n; i++) {
      data[i] += rightElements[i];
    }
  }

  @override
  void div(Tensor<double> right) {
    _checkSameShape(right);
    final data = this.data;
    final rightElements = right.elements();
    final n = length;
    for (var i = 0; i < n; i++) {
      data[i] /= rightElements[i];
    }
  }

  @override
  void divScalar(num value) {
    final data = this.data;
    final n = length;
    for (var i = 0; i < n; i++) {
      data[i] /= value;
    }
  }

  @override
  void mul(Tensor<double> right) {
    _checkSameShape(right);
    final data = this.data;
    final rightElements = right.elements();
    final n = length;
    for (var i = 0; i < n; i++) {
      data[i] *= rightElements[i];
    }
  }

  @override
  void mulScalar(num value) {
    final data = this.data;
    final n = length;
    for (var i = 0; i < n; i++) {
      data[i] *= value;
    }
  }

  @override
  void neg() {
    final data = this.data;
    final n = length;
    for (var i = 0; i < n; i++) {
      data[i] = -data[i];
    }
  }


  @override
  void round() {
    final data = this.data;
    final n = length;
    for (var i = 0; i < n; i++) {
      data[i] = data[i].roundToDouble();
    }
  }

  @override
  void sq() {
    final data = this.data;
    final n = length;
    for (var i = 0; i < n; i++) {
      data[i] *= data[i];
    }
  }

  @override
  void sqrt() {
    final data = this.data;
    final n = length;
    for (var i = 0; i < n; i++) {
      data[i] = math.sqrt(data[i]);
    }
  }

  @override
  void sub(Tensor<double> right) {
    _checkSameShape(right);
    final data = this.data;
    final rightElements = right.elements();
    final n = length;
    for (var i = 0; i < n; i++) {
      data[i] -= rightElements[i];
    }
  }

  @override
  void setTensor(Tensor<double> tensor) {
    tensorShape = tensor.tensorShape;
    data.setAll(0, tensor.elements());
  }

  void _checkSameShape(Tensor<double> right) {
    if (tensorShape != right.tensorShape) {
      throw ArgumentError.value(right, 'right',
          'Tensor shapes are different: ${tensorShape} != ${right.tensorShape}');
    }
  }

  @override
  void clamp(double lowerLimit, double upperLimit) {
    final data = this.data;
    final n = length;
    for (var i =0;i<n;i++) {
      data[i].clamp(lowerLimit, upperLimit);
    }
  }
}

class Float32Vector extends Vector<double> with Float32Tensor {
  final Float32List _list;

  @override
  late final TensorShape tensorShape = TensorShape(length);

  factory Float32Vector(Iterable<double> iterable) {
    if (iterable is Float32List) {
      return Float32Vector.withFloat32List(iterable);
    }
    if (iterable is List<double>) {
      return Float32Vector.withFloat32List(Float32List.fromList(iterable));
    }
    return Float32Vector.withFloat32List(Float32List.fromList(
      iterable.toList(growable: false),
    ));
  }

  Float32Vector.withFloat32List(this._list) {
    if (_list.isEmpty) {
      throw ArgumentError.value(_list);
    }
  }

  @override
  bool get isZero => _list.every((element) => element == 0.0);

  @override
  List<double> elements() => _list;

  @override
  Float32TensorBuilder toBuilder({bool copy = true}) {
    final builder = Float32TensorBuilder();
    if (copy) {
      builder.setTensor(this);
    }
    return builder;
  }

  @override
  Float32Matrix toMatrixColumn() => Float32Matrix.fromColumnVector(this);

  @override
  Float32Matrix toMatrixRow() => Float32Matrix.fromRowVector(this);

  @override
  String toString() {
    if (length <= 4) {
      return 'Vectorf([${_list.join(', ')}])';
    }
    return 'Vectorf(${_list.first}, ..., ${_list.last}; length=${_list.length})';
  }
}

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
      return 'Float32Matrix.fromRowVector([${elements().join(', ')}])';
    }
    if (width == 1 && height <= 10) {
      return 'Float32Matrix.fromColumnVector([${elements().join(', ')}])';
    }
    if (width <= 4 && height <= 4) {
      final sb = StringBuffer();
      sb.write('Float32Matrix.fromRows([\n');
      var columnWidth = elements().map((e) => e.toString().length).max() + 3;
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
