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

/// Mathematical/statistical extension methods for iterables where elements
/// implement [Comparable].
extension ComparableCalc<T extends Comparable> on Iterable<T> {
  /// Returns an unmodifiable list of sorted values.
  ///
  /// # Example
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   final iterable = <int>{3, 1, 2, 4, 5};
  ///   final x = iterable.sorted().fractionalRange(0.0, 0.3).mean();
  ///   print('Mean of the lowest 30 percent: $x');
  /// }
  /// ```
  List<T> sorted() {
    final sorted = toList(growable: false);
    sorted.sort();
    return List<T>.unmodifiable(sorted);
  }

  /// Finds maximum value.
  ///
  /// Throws [StateError] if the iterable is empty.
  T max() {
    T? result;
    for (var item in this) {
      if (result == null || item.compareTo(result) > 0) {
        result = item;
      }
    }
    if (result == null) {
      throw StateError('Iterable is empty');
    }
    return result;
  }

  /// Finds minimum value.
  ///
  /// Throws [StateError] if the iterable is empty.
  T min() {
    T? result;
    for (var item in this) {
      if (result == null || item.compareTo(result) < 0) {
        result = item;
      }
    }
    if (result == null) {
      throw StateError('Iterable is empty');
    }
    return result;
  }
}
