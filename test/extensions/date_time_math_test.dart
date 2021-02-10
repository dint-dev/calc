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
import 'package:test/test.dart';

void main() {
  group('DateTimeIterableMath', () {
    final a = DateTime(2020, 01, 01);
    final b = DateTime(2020, 01, 02);
    final c = DateTime(2020, 01, 03);
    test('mean(...)', () {
      expect(() => <DateTime>[].mean(), throwsStateError);
      expect(<DateTime>[a].mean(), a);
      expect(<DateTime>[a, b, c].mean(), b);
      expect(
        <DateTime>[a, b].mean().microsecondsSinceEpoch,
        [a.microsecondsSinceEpoch, b.microsecondsSinceEpoch].mean(),
      );
    });
    test('max(...)', () {
      expect(() => <DateTime>[].max(), throwsStateError);
      expect(<DateTime>[a].max(), a);
      expect(<DateTime>[a, b].max(), b);
      expect(<DateTime>[a, b, c].max(), c);
      expect(<DateTime>[a, c, b].max(), c);
    });
    test('min(...)', () {
      expect(() => <DateTime>[].min(), throwsStateError);
      expect(<DateTime>[a].min(), a);
      expect(<DateTime>[a, b].min(), a);
      expect(<DateTime>[a, b, c].min(), a);
      expect(<DateTime>[b, a, c].min(), a);
      expect(<DateTime>[b, c, a].min(), a);
    });
  });
}
