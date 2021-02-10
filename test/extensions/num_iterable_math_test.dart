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
  group('NumIterableMath', () {
    group('Iterable<int>', () {
      test('mean(...)', () {
        expect(<int>[].mean(), 0.0);
        expect(<int>[42].mean(), 42.0);
        expect(<int>[42, 42, 42].mean(), 42.0);
        expect(<int>[1, 3].mean(), 2.0);
        expect(<int>[0, 0, 6].mean(), 2.0);
      });
      test('sum(...)', () {
        expect(<int>[].sum(), 0.0);
        expect(<int>[2].sum(), 2.0);
        expect(<int>[2, 3].sum(), 5.0);
      });
      test('max(...)', () {
        expect(() => <int>[].max(), throwsStateError);
        expect(<int>[4].max(), 4);
        expect(<int>[2, 3, 4].max(), 4);
        expect(<int>[4, 2, 3].max(), 4);
        expect(<int>[4, 3, 2].max(), 4);
      });
      test('min(...)', () {
        expect(() => <int>[].min(), throwsStateError);
        expect(<int>[2].min(), 2);
        expect(<int>[2, 3, 4].min(), 2);
        expect(<int>[4, 2, 3].min(), 2);
        expect(<int>[4, 3, 2].min(), 2);
      });
      test('variance(...)', () {
        expect(() => <int>[].variance(), throwsStateError);
        expect(<int>[2, 2, 2].variance(), 0.0);
        expect(<int>[1, 3].variance(), 1.0);
        expect(<int>[1, 1, 3, 3].variance(), 1.0);
        expect(<int>[1, 1, 5, 5].variance(), 4.0);
      });
    });
    group('Iterable<double>', () {
      test('mean(...)', () {
        expect(<double>[].mean(), 0.0);
        expect(<double>[42.0].mean(), 42.0);
        expect(<double>[42.0, 42.0, 42.0].mean(), 42.0);
        expect(<double>[1.0, 3.0].mean(), 2.0);
        expect(<double>[0.0, 0.0, 6.0].mean(), 2.0);
      });
      test('sum(...)', () {
        expect(<double>[].mean(), 0.0);
        expect(<double>[2.0].sum(), 2.0);
        expect(<double>[2.0, 3.0].sum(), 5.0);
      });
      test('max(...)', () {
        expect(() => <double>[].max(), throwsStateError);
        expect(<double>[4.0].max(), 4.0);
        expect(<double>[2.0, 3.0, 4.0].max(), 4.0);
        expect(<double>[4.0, 2.0, 3.0].max(), 4.0);
        expect(<double>[4.0, 3.0, 2.0].max(), 4.0);
      });
      test('min(...)', () {
        expect(() => <double>[].min(), throwsStateError);
        expect(<double>[2.0].min(), 2.0);
        expect(<double>[2.0, 3.0, 4.0].min(), 2.0);
        expect(<double>[4.0, 2.0, 3.0].min(), 2.0);
        expect(<double>[4.0, 3.0, 2.0].min(), 2.0);
      });
      test('variance(...)', () {
        expect(() => <double>[].variance(), throwsStateError);
        expect(<double>[2.0, 2.0, 2.0].variance(), 0.0);
        expect(<double>[1.0, 3.0].variance(), 1.0);
        expect(<double>[1.0, 1.0, 3.0, 3.0].variance(), 1.0);
        expect(<double>[1.0, 1.0, 5.0, 5.0].variance(), 4.0);
      });
    });
  });
}
