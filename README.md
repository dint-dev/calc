# Overview
[![Pub Package](https://img.shields.io/pub/v/calc.svg)](https://pub.dartlang.org/packages/calc)
[![Github Actions CI](https://github.com/dint-dev/calc/workflows/Dart%20CI/badge.svg)](https://github.com/dint-dev/calc/actions?query=workflow%3A%22Dart+CI%22)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/dint-dev/calc)

Mathematical and statistical functions and classes for Dart and Flutter developers.
Tensors / vectors / matrices, probability distributions, and more.

Licensed under the [Apache License 2.0](LICENSE). Want to improve the package? Please send a pull
request [in Github](https://github.com/dint-dev/math).

## Links
  * [Github project](https://github.com/dint-dev/math)
  * [Issue tracker](https://github.com/dint-dev/math/issues)
  * [Pub package](https://pub.dev/packages/math)
  * [API reference](https://pub.dev/documentation/calc/latest/)

# Getting started
## 1.Add dependency
In _pubspec.yaml_:
```yaml
dependencies:
  calc: ^0.1.0
```

## 2.Use it
Read [documentation of APIs](https://pub.dev/documentation/calc/latest/).

A simple example:
```dart
import 'package:calc/calc.dart';

void main() {
  final numbers = [1,2,3,4];
  final mean = numbers.mean();
  final variance = numbers.variance();
  print('mean: $mean, variance: $variance');
}
```

# Content
## dart:math
The package re-exports everything in [dart:math](https://api.flutter.dev/flutter/dart-math/dart-math-library.html)
(basic mathematical functions/constants like `log` and `pi`) for convenience of developers. We don't
expect _dart:math_ to have drastic changes that would break semantic versioning of this package.

## Tensors, vectors, and matrices
  * [Tensor](https://pub.dev/documentation/calc/latest/calc/Tensor-class.html)
    * [Matrix](https://pub.dev/documentation/calc/latest/calc/Matrix-class.html)
    * [Vector](https://pub.dev/documentation/calc/latest/calc/Vector-class.html)
  * [TensorBuilder](https://pub.dev/documentation/calc/latest/calc/TensorBuilder-class.html)

## Probability and statistics
Classes:
  * [Distribution](https://pub.dev/documentation/calc/latest/calc/Distribution-class.html)
    * [DiscreteDistribution](https://pub.dev/documentation/calc/latest/calc/DiscreteDistribution-class.html)
      * [BinomialDistribution](https://pub.dev/documentation/calc/latest/calc/BinomialDistribution-class.html)
      * [Frequencies](https://pub.dev/documentation/calc/latest/calc/Frequencies-class.html)
      * [PoissonDistribution](https://pub.dev/documentation/calc/latest/calc/PoissonDistribution-class.html)
    * [ContinuousDistribution](https://pub.dev/documentation/calc/latest/calc/ContinuousDistribution-class.html)
      * [NormalDistribution](https://pub.dev/documentation/calc/latest/calc/NormalDistribution-class.html)
      * [UniformDistribution](https://pub.dev/documentation/calc/latest/calc/UniformDistribution-class.html)
    * [TensorDistribution](https://pub.dev/documentation/calc/latest/calc/TensorDistribution-class.html)
  * [LinearTensorModel](https://pub.dev/documentation/calc/latest/calc/LinearTensorModel-class.html)
  * [PredictiveModel](https://pub.dev/documentation/calc/latest/calc/PredictiveModel-class.html)
  * [TensorPairs](https://pub.dev/documentation/calc/latest/calc/TensorPairs-class.html)

Functions:
  * [binomialCoefficient](https://pub.dev/documentation/calc/latest/calc/binomialCoefficient.html)
  * [factorial](https://pub.dev/documentation/calc/latest/calc/factorial.html)

## Extensions for Iterable<T>
The following extension classes add methods such as `max()`, `mean()` and `variance()`:
 * [NumIterableCalc](https://pub.dev/documentation/calc/latest/calc/NumIterableCalc-class.html) (for _Iterable<num>_ / _Iterable<int>_ / _Iterable<double>_)
 * [DateTimeIterableCalc](https://pub.dev/documentation/calc/latest/calc/DateTimeIterableCalc-class.html) (for _Iterable<DateTime>_)
 * [IterableCalc](https://pub.dev/documentation/calc/latest/calc/IterableCalc-class.html) (for _Iterable_<T>_)
 * [TensorIterableCalc](https://pub.dev/documentation/calc/latest/calc/TensorIterableCalc-class.html) (for _Iterable<Tensor<T>>_)