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

import 'dart:math' as math;

import 'package:calc/calc.dart';

abstract class FloatTensorBuilder extends TensorBuilder<double> {
  @override
  void abs() {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] = elements[i].abs();
    }
  }

  @override
  void add(Tensor<double> right) {
    _checkSameShape(right);
    final elements = this.elements;
    final rightElements = right.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] += rightElements[i];
    }
  }

  @override
  void ceil() {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] = elements[i].ceilToDouble();
    }
  }

  @override
  void clamp(double lowerLimit, double upperLimit) {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i].clamp(lowerLimit, upperLimit);
    }
  }

  @override
  void cos() {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] = math.cos(elements[i]);
    }
  }

  @override
  void div(Tensor<double> right,
      {bool noNan = false, bool swapArguments = false}) {
    _checkSameShape(right);
    final elements = this.elements;
    final rightElements = right.elements;
    final n = length;
    final nan = noNan ? 0.0 : double.nan;
    if (swapArguments) {
      for (var i = 0; i < n; i++) {
        final nominator = rightElements[i];
        final denominator = elements[i];
        elements[i] = denominator == 0.0 ? nan : nominator / denominator;
      }
    } else {
      for (var i = 0; i < n; i++) {
        final nominator = elements[i];
        final denominator = rightElements[i];
        elements[i] = denominator == 0.0 ? nan : nominator / denominator;
      }
    }
  }

  @override
  void divScalar(num value, {bool noNan = false, bool swapArguments = false}) {
    value = value.toDouble();
    final elements = this.elements;
    final n = length;
    final nan = noNan ? 0.0 : double.nan;
    if (swapArguments) {
      for (var i = 0; i < n; i++) {
        final denominator = elements[i];
        elements[i] = denominator == 0.0 ? nan : value / denominator;
      }
    } else {
      if (value == 0.0) {
        fill(noNan ? 0.0 : double.nan);
      } else {
        for (var i = 0; i < n; i++) {
          elements[i] /= value;
        }
      }
    }
  }

  @override
  void exp() {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] = math.exp(elements[i]);
    }
  }

  @override
  void fill(double value) {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] = value;
    }
  }

  @override
  void floor() {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] = elements[i].floorToDouble();
    }
  }

  @override
  void log() {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] = math.log(elements[i]);
    }
  }

  @override
  void max(Tensor<double> right) {
    _checkSameShape(right);
    final elements = this.elements;
    final rightElements = right.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] = math.max(elements[i], rightElements[i]);
    }
  }

  @override
  void min(Tensor<double> right) {
    _checkSameShape(right);
    final elements = this.elements;
    final rightElements = right.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] = math.min(elements[i], rightElements[i]);
    }
  }

  @override
  void mul(Tensor<double> right) {
    _checkSameShape(right);
    final elements = this.elements;
    final rightElements = right.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] *= rightElements[i];
    }
  }

  @override
  void mulScalar(num value) {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] *= value;
    }
  }

  @override
  void neg() {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] = -elements[i];
    }
  }

  @override
  void pow(Tensor<double> right, {bool swapArguments = false}) {
    final elements = this.elements;
    final rightElements = right.elements;
    final n = length;
    if (swapArguments) {
      for (var i = 0; i < n; i++) {
        elements[i] = math.pow(rightElements[i], elements[i]).toDouble();
      }
    } else {
      for (var i = 0; i < n; i++) {
        elements[i] = math.pow(elements[i], rightElements[i]).toDouble();
      }
    }
  }

  @override
  void round() {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] = elements[i].roundToDouble();
    }
  }

  @override
  void setTensor(Tensor<double> tensor) {
    tensorShape = tensor.tensorShape;
    elements.setAll(0, tensor.elements);
  }

  @override
  void sin() {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] = math.sin(elements[i]);
    }
  }

  @override
  void sq() {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] *= elements[i];
    }
  }

  @override
  void sqrt() {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] = math.sqrt(elements[i]);
    }
  }

  @override
  void sub(Tensor<double> right) {
    _checkSameShape(right);
    final elements = this.elements;
    final rightElements = right.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] -= rightElements[i];
    }
  }

  @override
  void tan() {
    final elements = this.elements;
    final n = length;
    for (var i = 0; i < n; i++) {
      elements[i] = math.tan(elements[i]);
    }
  }

  void _checkSameShape(Tensor<double> right) {
    if (tensorShape != right.tensorShape) {
      throw ArgumentError.value(
        right,
        'right',
        'Tensor shapes are different: ${tensorShape} != ${right.tensorShape}',
      );
    }
  }
}
