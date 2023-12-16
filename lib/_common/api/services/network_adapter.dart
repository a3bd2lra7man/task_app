
import '../entities/api_request.dart';
import '../entities/api_response.dart';

abstract class NetworkAdapter {
  Future<APIResponse> get(APIRequest apiRequest);

  Future<APIResponse> post(APIRequest apiRequest);

  Future<APIResponse> put(APIRequest apiRequest);

  Future<APIResponse> delete(APIRequest apiRequest);
}
