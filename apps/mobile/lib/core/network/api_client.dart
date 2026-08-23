import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_exception.dart';
import 'dio_client.dart';
import 'error_mapper.dart';

/// Thin convenience wrapper around [Dio] that every repository uses instead
/// of calling Dio directly. Its only job is to funnel every failure through
/// [ErrorMapper] so repositories/controllers only ever have to catch
/// [AppException].
class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<dynamic>(path, queryParameters: queryParameters);
      return _asMap(response.data);
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return _asMap(response.data);
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Object? data,
  }) async {
    try {
      final response = await _dio.patch<dynamic>(path, data: data);
      return _asMap(response.data);
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  Future<void> delete(
    String path, {
    Object? data,
  }) async {
    try {
      await _dio.delete<dynamic>(path, data: data);
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data == null) return const {};
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return data.cast<String, dynamic>();
    // Some endpoints (e.g. list ones) return a bare JSON array; callers that
    // expect that should use `getRaw` instead.
    return {'data': data};
  }

  /// For endpoints whose top-level JSON is a bare array rather than an
  /// object, or callers that need the untouched decoded body.
  Future<dynamic> getRaw(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<dynamic>(path, queryParameters: queryParameters);
      return response.data;
    } catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});
