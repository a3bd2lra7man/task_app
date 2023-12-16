import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../entities/api_request.dart';
import '../entities/api_response.dart';
import '../exceptions/api_exception.dart';
import '../utils/connection_checker.dart';
import '../utils/request_logger.dart';
import 'network_adapter.dart';

class NetworkRequestExecutor implements NetworkAdapter {
  Dio dio = Dio();

  NetworkRequestExecutor() {
    if (kDebugMode) {
      dio.interceptors.add(RequestLogger());
    }
  }

  @override
  Future<APIResponse> get(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'GET');
  }

  @override
  Future<APIResponse> post(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'POST');
  }

  @override
  Future<APIResponse> put(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'PUT');
  }

  @override
  Future<APIResponse> delete(APIRequest apiRequest) async {
    return executeRequest(apiRequest, 'DELETE');
  }

  Future<APIResponse> executeRequest(APIRequest apiRequest, String method) async {
    if (await _isConnected() == false) throw NetworkFailureException("Network Request Executor File");
    try {
      Response<String> response = await dio.request(
        apiRequest.url,
        data: jsonEncode(apiRequest.parameters),
        options: Options(
          method: method,
          headers: apiRequest.headers,
          validateStatus: (status) => status == 200 || status == 201,
        ),
      );
      return _processResponse(response, apiRequest);
    } on DioException catch (error) {
      throw _processError(error);
    }
  }

  Future<bool> _isConnected() {
    return ConnectionChecker().hasInternetAccess;
  }

  APIResponse _processResponse(Response response, APIRequest apiRequest) {
    try {
      var responseData = json.decode(response.data);
      return APIResponse(responseData);
    } catch (e) {
      throw UnexpectedResponseFormatException(e);
    }
  }

  APIException _processError(DioException error) {
    if (error.response == null || error.response!.statusCode == null) {
      return RequestFailureException(error, error.message ?? "");
    } else {
      //
      return ServerSentException(error, error.response?.data.toString());
    }
  }
}
