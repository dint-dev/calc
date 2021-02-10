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

/// Factorial function.
///
/// Throws [ArgumentError] if the argument is negative.
///
/// Uses double-precision floating-point values in browsers, which means that
/// precision issues may appear when factorial values reach 48 bits.
///
/// # Examples
/// ```
/// import 'package:calc/calc.dart';
///
/// void main() {
///   factorial(0); // --> 1
///   factorial(1); // --> 1
///   factorial(2); // --> 2
///   factorial(3); // --> 6
///   factorial(4); // --> 24
///   factorial(5); // --> 120
///   factorial(20); // --> 2432902008176640000
/// }
/// ```
int factorial(int k) {
  // TODO: Faster algorithm
  if (k < 0) {
    throw ArgumentError.value(k);
  }
  if (k == 0) {
    return 1;
  }
  var result = k;
  k--;
  while (k > 1) {
    result *= k;
    k--;
  }
  return result;
}

/// Binomial coefficient
/// ("given N items, how many combinations have K items?").
///
/// Uses double-precision floating-point values in browsers, which means that
/// precision issues may appear when factorial values reach 48 bits.
///
/// # Examples
/// ```
/// import 'package:calc/calc.dart';
///
/// void main() {
///   // "10 choose 5"
///   binomialCoefficient(10, 5); // --> 252
/// }
/// ```
int binomialCoefficient(int n, int k) {
  // TODO: Faster algorithm
  return factorial(n) ~/ (factorial(k) * factorial(n - k));
}
