import 'package:checkin_flutter/core/models/field_visit_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FieldVisitsRepository {
  FieldVisitsRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResponse<TodayVisitsSummaryDto>> getTodayVisits() {
    return _apiClient.get<TodayVisitsSummaryDto>(
      'api/v1/field-visits/today',
      converter: (value) => value is Map<String, dynamic>
          ? TodayVisitsSummaryDto.fromJson(value)
          : null,
    );
  }

  Future<ApiResponse<RecordVisitResponse>> recordVisit(RecordVisitRequest request) {
    return _apiClient.post<RecordVisitResponse>(
      'api/v1/field-visits/checkin',
      data: request.toJson(),
      converter: (value) => value is Map<String, dynamic>
          ? RecordVisitResponse.fromJson(value)
          : null,
    );
  }

  Future<ApiResponse<MyVisitsResponse>> getMyVisits({int page = 1, int pageSize = 20}) {
    return _apiClient.get<MyVisitsResponse>(
      'api/v1/field-visits/my',
      queryParameters: {'page': page, 'pageSize': pageSize},
      converter: (value) => value is Map<String, dynamic>
          ? MyVisitsResponse.fromJson(value)
          : null,
    );
  }
}

final fieldVisitsRepositoryProvider = Provider<FieldVisitsRepository>(
  (ref) => FieldVisitsRepository(ref.watch(apiClientProvider)),
);
