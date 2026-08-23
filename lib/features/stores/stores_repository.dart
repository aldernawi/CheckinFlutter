import 'package:checkin_flutter/core/models/store_models.dart';
import 'package:checkin_flutter/core/network/api_client.dart';
import 'package:checkin_flutter/core/network/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoresRepository {
  StoresRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResponse<MyStoresResponse>> getMyStores({
    double? latitude,
    double? longitude,
    String? search,
    bool orderByDistance = false,
    int page = 1,
    int pageSize = 20,
  }) {
    final params = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };
    if (latitude != null) params['latitude'] = latitude.toString();
    if (longitude != null) params['longitude'] = longitude.toString();
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (orderByDistance) params['orderByDistance'] = 'true';

    return _apiClient.get<MyStoresResponse>(
      'api/v1/stores/my',
      queryParameters: params,
      converter: (value) => value is Map<String, dynamic>
          ? MyStoresResponse.fromJson(value)
          : null,
    );
  }

  Future<ApiResponse<StoreDto>> getStore(String storeId) {
    return _apiClient.get<StoreDto>(
      'api/v1/stores/$storeId',
      converter: (value) =>
          value is Map<String, dynamic> ? StoreDto.fromJson(value) : null,
    );
  }

  Future<ApiResponse<CreateStoreResponse>> createStore(CreateStoreRequest request) {
    return _apiClient.post<CreateStoreResponse>(
      'api/v1/stores',
      data: request.toJson(),
      converter: (value) => value is Map<String, dynamic>
          ? CreateStoreResponse.fromJson(value)
          : null,
    );
  }

  Future<ApiResponse<StoreDto>> updateStore(
      String storeId, CreateStoreRequest request) {
    return _apiClient.put<StoreDto>(
      'api/v1/stores/$storeId',
      data: request.toJson(),
      converter: (value) =>
          value is Map<String, dynamic> ? StoreDto.fromJson(value) : null,
    );
  }

  Future<ApiResponse<UnvisitedStoresResponse>> getUnvisitedStores({
    int page = 1,
    int pageSize = 20,
  }) {
    return _apiClient.get<UnvisitedStoresResponse>(
      'api/v1/stores/unvisited',
      queryParameters: {'page': page, 'pageSize': pageSize},
      converter: (value) => value is Map<String, dynamic>
          ? UnvisitedStoresResponse.fromJson(value)
          : null,
    );
  }

  Future<ApiResponse<StoreVisitsResponse>> getStoreVisits(String storeId) {
    return _apiClient.get<StoreVisitsResponse>(
      'api/v1/stores/$storeId/visits',
      converter: (value) => value is Map<String, dynamic>
          ? StoreVisitsResponse.fromJson(value)
          : null,
    );
  }
}

final storesRepositoryProvider = Provider<StoresRepository>(
  (ref) => StoresRepository(ref.watch(apiClientProvider)),
);
