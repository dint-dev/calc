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

/// Linear regression model for scalar variables.
///
/// # Example
/// ```
/// import 'package:calc/calc.dart';
///
/// void main() {
///   final model = LinearTensorModel(
///     coefficients: VectorF([1,2,3]),
///     constants: VectorF([0,0,0]),
///   );
///   final x = <double>[1,1,1];
///   final y = model.predict(x);
///   print('Predicted Y: $y');
/// }
/// ```
class LinearTensorModel extends PredictiveModel<Tensor<double>, Tensor<double>> {
  final Tensor<double> coefficients;
  final Tensor<double> constants;

  LinearTensorModel({
    required this.coefficients,
    required this.constants,
  }) {
    if (coefficients.tensorShape != constants.tensorShape) {
      throw ArgumentError('Tensor shapes must be equal');
    }
  }

  @override
  int get hashCode => coefficients.hashCode ^ constants.hashCode;

  @override
  bool operator ==(Object other) =>
      other is LinearTensorModel &&
      coefficients == other.coefficients &&
      constants == other.constants;

  @override
  Tensor<double> predict(Tensor<double> x) {
    return coefficients * x + constants;
  }

  @override
  String toString() {
    return 'LinearRegressionTensorModel(\n'
        '  coefficient: $coefficients,\n'
        '  constant: $constants,\n'
        ')';
  }
}
