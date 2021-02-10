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

import 'dart:collection';

import 'package:calc/calc.dart';

/// A vector or scalar.
///
/// # Implementations
///   * [Float32Vector]
///
/// # Example
/// ```
/// import 'package:calc/calc.dart';
///
/// void main() {
///   final vector = Float32Vector([1.0, 2.0, 3.0]);
/// }
/// ```
abstract class Vector<T> extends Tensor<T> with IterableMixin<T> {
  @override
  Iterator<T> get iterator => elements.iterator;

  /// Returns an element of the vector.
  T operator [](int index) => elements[index];

  Matrix<T> toMatrixColumn();

  Matrix<T> toMatrixRow();
}
