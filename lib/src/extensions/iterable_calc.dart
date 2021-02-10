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

/// Mathematical/statistical extension methods for [Iterable] types.
extension IterableCalc<T> on Iterable<T> {
  /// Returns value closest to the fractional index (between 0.0 and 1.0).
  ///
  /// Throws [ArgumentError] if argument is out of range.
  ///
  /// Throws [StateError] if the list is empty.
  ///
  /// # Example
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   final list = [1,2,3,4,5];
  ///
  ///   // Print median (assuming odd number of values)
  ///   final median = list.fractionalIndex(0.5);
  ///   print('median: $median');
  ///
  ///
  ///   // Print 95th percentile
  ///   final percentile95 = list.fractionalIndex(0.95);
  ///   print('95th percentile: $percentile95');
  /// }
  /// ```
  T fractionalIndex(double fraction) {
    if (fraction.isNaN || fraction < 0.0 || fraction > 1.0) {
      throw ArgumentError.value(fraction, 'fraction');
    }
    if (isEmpty) {
      throw StateError('Empty iterable');
    }
    final length = this.length;
    if (length == 0) {
      throw StateError('The iterable is empty');
    }
    var n = (fraction * (length - 1)).round();
    T? last;
    final tail = skip(n);
    if (tail.isEmpty) {
      return last as T;
    }
    return tail.first;
  }

  /// Returns values in the fractional index range (between 0.0 and 1.0).
  ///
  /// Throws [ArgumentError] if argument is out of range.
  ///
  /// Throws [StateError] if the list is empty.
  ///
  /// # Examples
  /// ```
  /// import 'package:calc/calc.dart';
  ///
  /// void main() {
  ///   final list = [1,2,3,4,5];
  ///
  ///   // Sort values
  ///   list.sort();
  ///
  ///   // Print top 50% of values (4,5).
  ///   final top50percent = list.fractionallyGetRange(0.5, 1.0);
  ///   print('top 50%: $top50percent');
  ///
  ///   // Print top 25% of values (5).
  ///   final top25percent = list.fractionallyGetRange(0.75, 1.0);
  ///   print('top 25%: $top25percent');
  /// }
  /// ```
  Iterable<T> fractionalRange(double from, double to) {
    if (from.isNaN || from < 0.0 || from > 1.0) {
      throw ArgumentError.value(from, 'from');
    }
    if (to.isNaN || to < 0.0 || to > 1.0) {
      throw ArgumentError.value(from, 'to');
    }
    if (to < from) {
      throw ArgumentError('to < from');
    }
    if (isEmpty) {
      throw StateError('The iterable is empty');
    }
    if (to == from) {
      return take(0);
    }
    final fromIndex = (from * (length - 1)).toInt();
    final toIndex = (to * length).toInt();
    return skip(fromIndex).take(toIndex - fromIndex);
  }
}
