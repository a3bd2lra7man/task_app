import 'dart:core';

class APIRequest {
  String url;
  Map<String, dynamic> parameters = <String, dynamic>{};
  Map<String, String> headers = <String, String>{};

  APIRequest(this.url);

  addParameter(String key, dynamic value) {
    parameters[key] = value;
  }

  addParameters(Map<String, dynamic> params) {
    parameters.addAll(params);
  }

  addHeader(String key, String value) {
    headers[key] = value;
  }

  addHeaders(Map<String, String> headers) {
    this.headers.addAll(headers);
  }
}
