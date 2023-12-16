// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:dio/dio.dart';

class RequestLogger extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _printRequestHeader(options);
    _printMapAsTable(options.queryParameters, header: 'Query Parameters');
    final requestHeaders = <String, dynamic>{};
    requestHeaders.addAll(options.headers);
    requestHeaders['contentType'] = options.contentType?.toString();
    requestHeaders['responseType'] = options.responseType.toString();
    requestHeaders['followRedirects'] = options.followRedirects;
    requestHeaders['connectTimeout'] = options.connectTimeout?.toString();
    requestHeaders['receiveTimeout'] = options.receiveTimeout?.toString();
    _printMapAsTable(requestHeaders, header: 'Headers');
    _printMapAsTable(options.extra, header: 'Extras');
    if (options.method != 'GET') {
      final dynamic data = options.data;
      if (data != null) {
        if (data is Map) _printMapAsTable(options.data as Map?, header: 'Body');
        if (data is FormData) {
          final formDataMap = <String, dynamic>{}
            ..addEntries(data.fields)
            ..addEntries(data.files);
          _printMapAsTable(formDataMap, header: 'Form data | ${data.boundary}');
        } else {
          _printBlock(data.toString());
        }
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.badResponse) {
      final uri = err.response?.requestOptions.uri;
      _printBoxed(
          header: 'DioError ║ Status: ${err.response?.statusCode} ${err.response?.statusMessage}',
          text: uri.toString());
      if (err.response != null && err.response?.data != null) {
        print('╔ ${err.type.toString()}');
        print(err.response!);
      }
      _printLine('╚');
      print('');
    } else {
      _printBoxed(header: 'DioError ║ ${err.type}', text: err.message);
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _printResponseHeader(response);

    print('╔ Body');
    print('║');
    _printResponse(response);
    print('║');
    _printLine('╚');
    super.onResponse(response, handler);
  }

  void _printResponse(Response response) {
    if (response.data != null) {
      if (response.data is Map) {
        for (var entry in (response.data as Map).entries) {
          print("${entry.key} : ${entry.value}");
        }
      } else if (response.data is Uint8List) {
        print(response.data);
      } else if (response.data is List) {
        for (var item in (response.data as List)) {
          print("\n $item \n");
        }
      } else {
        _printBlock(response.data.toString());
      }
    }
  }

  void _printBoxed({String? header, String? text}) {
    print('');
    print('╔╣ $header');
    print('║  $text');
    _printLine('╚');
  }

  void _printResponseHeader(Response response) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    _printBoxed(
        header: 'Response ║ $method ║ Status: ${response.statusCode} ${response.statusMessage}', text: uri.toString());
  }

  void _printRequestHeader(RequestOptions options) {
    final uri = options.uri;
    final method = options.method;
    _printBoxed(header: 'Request ║ $method ', text: uri.toString());
  }

  void _printLine([String pre = '', String suf = '╝']) => print('$pre${'═' * 120}$suf');

  void _printKV(String? key, Object? v) {
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > 120) {
      print(pre);
      _printBlock(msg);
    } else {
      print('$pre$msg');
    }
  }

  void _printBlock(String msg) {
    final lines = msg.split('\n');
    for (var i = 0; i < lines.length; ++i) {
      print((i >= 0 ? '║ ' : '') + lines[i]);
    }
  }

  void _printMapAsTable(Map? map, {String? header}) {
    if (map == null || map.isEmpty) return;
    print('╔ $header ');
    map.forEach((dynamic key, dynamic value) => _printKV(key.toString(), value));
    _printLine('╚');
  }
}
