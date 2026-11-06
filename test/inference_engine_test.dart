import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/services/inference_engine.dart';

void main() {
  group('Forward Chaining regression', () {
    test('empty input yields no result', () {
      final hasil = diagnosa(<String>{});
      expect(hasil['hasil'], isEmpty);
    });

    test('single-symptom rule B36 matches K08 at 100%', () {
      final hasil = diagnosa({'B36'});
      final list = (hasil['hasil'] as List).cast<Map<String, dynamic>>();
      expect(list, isNotEmpty);
      final first = list.first;
      expect(first['kerusakan'].kode, 'K08');
      expect(first['persen'], 100);
    });

    test('B10 matches K10 at 100%', () {
      final hasil = diagnosa({'B10'});
      final list = (hasil['hasil'] as List).cast<Map<String, dynamic>>();
      expect(list.first['kerusakan'].kode, 'K10');
      expect(list.first['persen'], 100);
    });

    test('K01 rule ranks first for B01+B02+B24', () {
      final hasil = diagnosa({'B01', 'B02', 'B24'});
      final list = (hasil['hasil'] as List).cast<Map<String, dynamic>>();
      expect(list.first['kerusakan'].kode, 'K01');
      expect(list.first['persen'], 100);
    });

    test('results are sorted descending by percentage', () {
      final hasil = diagnosa({'B01', 'B02', 'B24'});
      final list = (hasil['hasil'] as List).cast<Map<String, dynamic>>();
      for (var i = 1; i < list.length; i++) {
        final prev = list[i - 1]['persen'] as int;
        final curr = list[i]['persen'] as int;
        expect(prev, greaterThanOrEqualTo(curr));
      }
    });

    test('duplicate damage codes are collapsed', () {
      final hasil = diagnosa({'B01', 'B02', 'B24'});
      final list = (hasil['hasil'] as List).cast<Map<String, dynamic>>();
      final codes = list.map((e) => e['kerusakan'].kode).toList();
      expect(codes.length, codes.toSet().length);
    });
  });
}
