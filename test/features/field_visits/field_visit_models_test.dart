import 'package:checkin_flutter/core/models/field_visit_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses the official visits history envelope and TimeOnly values', () {
    final response = MyVisitsResponse.fromJson({
      'visits': [
        {
          'id': 'visit-1',
          'storeId': 'store-1',
          'storeName': 'Store',
          'storeNameAr': 'المحل',
          'visitNumber': 'V-1',
          'visitDate': '2026-09-15',
          'checkInTime': '09:30:00',
          'status': 1,
          'distanceFromStore': 12,
        },
      ],
      'totalCount': 1,
      'page': 1,
      'pageSize': 20,
    });

    expect(response.items, hasLength(1));
    expect(response.items.single.store.displayName, 'المحل');
    expect(response.items.single.checkInTime.hour, 9);
    expect(response.items.single.checkInTime.minute, 30);
  });
}
