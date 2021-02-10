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

/// Mathematical/statistical extension methods for [num] iterables.
extension NumIterableCalc<T extends num> on Iterable<T> {
  /// Calculates mean of items.
  ///
  /// Returns 0 if the iterable is empty.
  double mean() {
    if (isEmpty) {
      return 0.0;
    }
    return sum() / length;
  }

  /// Calculates sum of items.
  ///
  /// Returns 0 if the iterable is empty.
  T sum() {
    var result = 0.0;
    for (var item in this) {
      result += item;
    }
    if (result is T) {
      return result as T;
    }
    final resultAsInt = result.toInt();
    if (resultAsInt is T) {
      return resultAsInt as T;
    }
    throw UnsupportedError('Unsupported subtype');
  }

  /// Calculates variance of items.
  ///
  /// Throws [StateError] if the iterable is empty.
  double variance() {
    if (isEmpty) {
      throw StateError('Iterable is empty');
    }
    // TODO: Optimize?
    final mean = this.mean();
    return map((e) {
      final v = e - mean;
      return v * v;
    }).mean();
  }

  /// Calculates standard deviation of items.
  double standardDeviation() => sqrt(variance());

  /// Constructs an iterable of tensors.
  Iterable<Vector<double>> toTensors() =>
      map((e) => Float32Vector([e.toDouble()]));
}
