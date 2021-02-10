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

/// Shape of a tensor. Currently the limit is 4 dimensions.
///
/// # Example
/// ```
/// import 'package:calc/calc.dart';
///
/// void main() {
///   final shape = TensorShape([1,2,3]);
/// }
/// ```
class TensorShape {
  static const TensorShape scalar = TensorShape(1);

  final int x;
  final int y;
  final int z;
  final int w;

  const TensorShape(this.x, [this.y = 0, this.z = 0, this.w = 0])
      : assert(x >= 0),
        assert(y >= 0),
        assert(z >= 0),
        assert(w >= 0);

  @override
  int get hashCode => x ^ (y << 2) ^ (z << 3) ^ (w << 5);

  /// Number of dimensions.
  int get numberOfDimensions {
    if (y == 0) {
      return 1;
    }
    if (z == 0) {
      return 2;
    }
    if (w == 0) {
      return 3;
    }
    return 4;
  }

  /// Returns the number of elements in the tensor.
  int get numberOfElements =>
      x * (y == 0 ? 1 : y) * (z == 0 ? 1 : z) * (w == 0 ? 1 : w);

  @override
  bool operator ==(Object other) {
    return other is TensorShape &&
        x == other.x &&
        y == other.y &&
        z == other.z &&
        w == other.w;
  }

  /// Flattens (x, y, z, w) into a list index.
  int flatten(int x, [int y = -1, int z = -1, int w = -1]) {
    final tx = this.x;
    final ty = this.y;
    final tz = this.z;
    final tw = this.w;
    var i = x;
    if (x < 0 || x >= tx) {
      throw ArgumentError.value(x, 'x');
    }
    if (y == -1) {
      if (ty != 0) {
        throw ArgumentError.value(y, 'y');
      }
      if (z != -1) {
        throw ArgumentError.value(z, 'z');
      }
      if (w != -1) {
        throw ArgumentError.value(w, 'w');
      }
      return i;
    }
    if (y < 0 || y >= ty) {
      throw ArgumentError.value(y, 'y');
    }
    i += tx * y;
    if (z == -1) {
      if (tz != 0) {
        throw ArgumentError.value(z, 'z');
      }
      if (w != -1) {
        throw ArgumentError.value(w, 'w');
      }
      return i;
    }
    if (z < 0 || z >= tz) {
      throw ArgumentError.value(z, 'z');
    }
    i += tx * ty * z;
    if (w == -1) {
      if (tw != 0) {
        throw ArgumentError.value(w, 'w');
      }
      return i;
    }
    if (w < 0 || w >= tw) {
      throw ArgumentError.value(w, 'w');
    }
    i += tx * ty * tz * w;
    return i;
  }

  /// Gets `w` dimension of a flat index (see [flatten]).
  int getW(int i) {
    if (i<0 || i>=numberOfElements) {
      throw ArgumentError.value(i);
    }
    final w = this.w;
    if (w == 0) {
      throw StateError('No `w` index');
    }
    return (i ~/ (x * y * z)) % w;
  }

  /// Gets `x` dimension of a flat index (see [flatten]).
  int getX(int i) {
    if (i<0 || i>=numberOfElements) {
      throw ArgumentError.value(i);
    }
    return i % x;
  }

  /// Gets `y` dimension of a flat index (see [flatten]).
  int getY(int i) {
    if (i<0 || i>=numberOfElements) {
      throw ArgumentError.value(i);
    }
    final y = this.y;
    if (y == 0) {
      throw StateError('No `y` index');
    }
    return (i ~/ x) % y;
  }

  /// Gets `z` dimension of a flat index (see [flatten]).
  int getZ(int i) {
    if (i<0 || i>=numberOfElements) {
      throw ArgumentError.value(i);
    }
    final z = this.z;
    if (z == 0) {
      throw StateError('No `z` index');
    }
    return (i ~/ (x * y)) % z;
  }

  @override
  String toString() {
    if (w == 0) {
      if (z == 0) {
        if (y == 0) {
          return 'TensorShape($x)';
        }
        return 'TensorShape($x, $y)';
      }
      return 'TensorShape($x, $y, $z)';
    }
    return 'TensorShape($x, $y, $z, $w)';
  }
}
