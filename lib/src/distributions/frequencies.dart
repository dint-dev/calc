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

import 'package:collection/collection.dart';
import 'package:calc/calc.dart';

/// Frequencies of discrete items.
///
/// # Example
/// ```
/// import 'package:calc/calc.dart';
///
/// void main() {
///   // Two cats and two other animals
///   final frequencies = Frequencies<String>.from([
///     'dog',
///     'cat',
///     'rabbit',
///     'cat',
///   ]);
///
///   final catPmf = frequencies.pmf('cat'); // --> 0.5
///   print('Likelihood of cats based on the seen data: $catPmf');
/// }
/// ```
class Frequencies<T> extends DiscreteDistribution<T> {
  final Map<T, double> _masses;

  /// Calculates frequencies of discrete items.
  ///
  /// Uses `==` and `hashCode` for counting values.
  ///
  /// # Example
  /// ```
  /// // Four samples, two cats.
  /// final frequencies = Frequencies.from(['dog', 'cat', 'sheep', 'cat']);
  ///
  /// print("Probability of cat: ${frequencies.pdf('cat')"); // --> 0.5
  /// ```
  factory Frequencies.from(Iterable<T> iterable) {
    final result = <T, double>{};

    // Count relative frequencies of items and sum of relative frequencies
    var n = 0;
    for (var item in iterable) {
      result[item] = (result[item] ?? 0.0) + 1.0;
      n++;
    }

    // Normalize values (so the sum is 1.0).
    for (var entry in result.entries) {
      result[entry.key] = entry.value / n.toDouble();
    }

    return Frequencies._(result);
  }

  /// Clones the map, normalizes the map values, and interprets the result as a
  /// distribution of observed values.
  factory Frequencies.fromMap(Map<T, num> masses) {
    if (masses.isEmpty) {
      return Frequencies._(<T, double>{});
    }
    var sum = 0.0;
    for (var m in masses.values) {
      if (m < 0.0) {
        throw ArgumentError.value(
            masses, 'masses', 'Found a negative probability');
      }
      sum += m;
    }
    if (sum == 0.0) {
      throw ArgumentError.value(
          masses, 'masses', 'Probabilities can not be all zero');
    }
    final result = <T, double>{};
    for (var entry in masses.entries) {
      result[entry.key] = entry.value / sum;
    }
    return Frequencies._(result);
  }

  Frequencies._(this._masses);

  @override
  int get hashCode => const MapEquality().hash(_masses);

  /// Values in the distribution.
  Iterable<T> get values => _masses.keys;

  Iterable<MapEntry<T, double>> get entries => _masses.entries;

  Map<T, double> toMap() => _masses;

  @override
  bool operator ==(Object other) =>
      other is Frequencies<T> &&
      const MapEquality().equals(toMap(), other.toMap());

  @override
  double pmf(T value) {
    return _masses[value] ?? 0.0;
  }

  @override
  T sample({Random? random}) {
    final masses = _masses;
    if (masses.isEmpty) {
      throw StateError('Frequencies is empty');
    }
    random ??= Random();

    // Choose a random threshold
    final x = random.nextDouble();

    // Iterate until the sum exceeds threshold
    var sum = 0.0;
    for (var entry in masses.entries) {
      sum += entry.value;
      if (sum > x) {
        return entry.key;
      }
    }

    // Fallback
    return masses.keys.first;
  }

  @override
  String toString() => 'Frequencies(...)';
}
