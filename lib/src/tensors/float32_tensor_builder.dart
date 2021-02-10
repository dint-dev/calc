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

abstract class Float32Tensor implements Tensor<double> {
  @override
  bool get isZero => elements.every((element) => element == 0.0);

  @override
  Float32TensorBuilder toBuilder({bool copy = true});
}

class Float32TensorBuilder extends FloatTensorBuilder {
  static final Float32List _emptyData = Float32List(0);

  TensorShape _tensorShape = TensorShape.scalar;

  @override
  Float32List elements = _emptyData;

  Float32Tensor? _recycled;

  List<double>? _recycledData;

  @override
  TensorShape get tensorShape => _tensorShape;

  @override
  set tensorShape(TensorShape value) {
    _tensorShape = value;
    final n = value.numberOfElements;
    if (elements.length < n) {
      final newData = Float32List(n);
      newData.setAll(0, elements);
      elements = newData;
    }
  }

  @override
  Float32Tensor build({bool recycle = false}) {
    final tensorShape = this.tensorShape;
    var elements = this.elements;
    final recycled = _recycled;
    if (recycled != null &&
        recycled.tensorShape == tensorShape &&
        identical(_recycledData, elements)) {
      if (!recycle) {
        _tensorShape = TensorShape.scalar;
        this.elements = _emptyData;
      }
      return recycled;
    }
    if (!recycle) {
      _tensorShape = TensorShape.scalar;
      this.elements = _emptyData;
    }
    final length = tensorShape.numberOfElements;
    if (elements.length != length) {
      elements = elements.sublist(0, length);
    }
    switch (tensorShape.numberOfDimensions) {
      case 1:
        final result = Float32Vector.withFloat32List(elements);
        if (recycle) {
          _recycled = result;
          _recycledData = elements;
        }
        return result;
      case 2:
        final result = Float32Matrix.withFloat32List(
          elements,
          width: tensorShape.x,
        );
        if (recycle) {
          _recycled = result;
          _recycledData = elements;
        }
        return result;
      default:
        throw UnimplementedError();
    }
  }

  @override
  Float32TensorBuilder toBuilder({bool copy = true}) {
    final builder = Float32TensorBuilder();
    if (copy) {
      builder.tensorShape = tensorShape;
      builder.elements.setRange(0, length, elements);
    }
    return builder;
  }
}
