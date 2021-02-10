import 'package:calc/calc.dart';

/// Beta distribution.
class BetaDistribution extends ContinuousDistribution {
  final double a;
  final double b;

  BetaDistribution({required this.a, required this.b}) {
    if (a.isNaN || a < 0) {
      throw ArgumentError.value(a, 'a');
    }
    if (b.isNaN || b < 0) {
      throw ArgumentError.value(b, 'b');
    }
  }

  @override
  int get hashCode => a.hashCode ^ b.hashCode;

  @override
  bool operator ==(Object other) =>
      other is BetaDistribution &&
          a == other.a &&
          b == other.b;

  @override
  double cdf(double x) {
    if (x.isNaN) {
      throw ArgumentError.value(x, 'x');
    }
    if (x <= 0.0) {
      return 0.0;
    }
    if (x >= 1.0) {
      return 1.0;
    }
    throw UnimplementedError();
  }

  @override
  double pdf(double x) {
    if (x.isNaN) {
      throw ArgumentError.value(x, 'x');
    }
    if (x < 0 || x > 1) {
      return 0;
    }
    throw UnimplementedError();
  }

  @override
  double sample({Random? random}) {
    throw UnimplementedError();
  }

  @override
  String toString() => 'BetaDistribution(a: $a, b: $b)';
}
