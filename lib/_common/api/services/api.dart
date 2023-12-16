import '../entities/api_request.dart';
import '../entities/api_response.dart';
import 'network_adapter.dart';
import 'network_request_executor.dart';

class API implements NetworkAdapter {
  final NetworkAdapter _networkAdapter;

  API() : _networkAdapter = NetworkRequestExecutor();

  @override
  Future<APIResponse> get(APIRequest apiRequest) async {
    apiRequest.addHeaders(_buildHeaders());
    return await _networkAdapter.get(apiRequest);
  }

  @override
  Future<APIResponse> put(APIRequest apiRequest) async {
    apiRequest.addHeaders(_buildHeaders());
    return await _networkAdapter.put(apiRequest);
  }

  @override
  Future<APIResponse> post(APIRequest apiRequest) async {
    apiRequest.addHeaders(_buildHeaders());
    return await _networkAdapter.post(apiRequest);
  }

  @override
  Future<APIResponse> delete(APIRequest apiRequest) async {
    apiRequest.addHeaders(_buildHeaders());
    return await _networkAdapter.delete(apiRequest);
  }

  Map<String, String> _buildHeaders() {
    var headers = <String, String>{};
    headers['Content-Type'] = 'application/json';
    return headers;
  }
}
