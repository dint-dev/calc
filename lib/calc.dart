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

/// Mathematical and statistical functions and classes.
library calc;

// Export everything from 'dart:math'.
export 'dart:math';

export 'src/distributions/beta_distribution.dart';
export 'src/distributions/binomial_distribution.dart';
export 'src/distributions/continuous_distribution.dart';
export 'src/distributions/discrete_distribution.dart';
export 'src/distributions/distribution.dart';
export 'src/distributions/frequencies.dart';
export 'src/distributions/normal_distribution.dart';
export 'src/distributions/poisson_distribution.dart';
export 'src/distributions/tensor_distribution.dart';
export 'src/distributions/uniform_distribution.dart';
export 'src/extensions/comparable_iterable_calc.dart';
export 'src/extensions/date_time_iterable_calc.dart';
export 'src/extensions/iterable_calc.dart';
export 'src/extensions/num_iterable_calc.dart';
export 'src/extensions/tensor_iterable_calc.dart';
export 'src/statistics/combinatorics.dart';
export 'src/statistics/linear_tensor_model.dart';
export 'src/statistics/predictive_model.dart';
export 'src/statistics/tensor_pairs.dart';
export 'src/tensors/matrix.dart';
export 'src/tensors/tensor.dart';
export 'src/tensors/tensor_builder.dart';
export 'src/tensors/float_tensor_builder.dart';
export 'src/tensors/tensor_shape.dart';
export 'src/tensors/vector.dart';
