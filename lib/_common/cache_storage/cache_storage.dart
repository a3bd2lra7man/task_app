abstract class CacheStorage {
  Future saveMap(String key, Map data);
  Future<Map<String, dynamic>?> getMap(String key);
  Future saveInt(String key, int data);
  Future<int?> getInt(String key);
}
