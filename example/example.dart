import 'package:calc/calc.dart';

void main() {
  final numbers = [1, 2, 3, 4];
  final mean = numbers.mean();
  final variance = numbers.variance();
  print('mean: $mean, variance: $variance');
}
