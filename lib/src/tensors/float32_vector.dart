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
  List<double> get elements => _list;

  @override
  bool get isZero => _list.every((element) => element == 0.0);

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
