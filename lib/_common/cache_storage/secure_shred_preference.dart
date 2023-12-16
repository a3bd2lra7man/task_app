import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:task_app/_common/cache_storage/cache_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureSharedPreference extends CacheStorage {
  final encryptionKey = 'PeShVmYq3t6w9z@C';
  final initializationVector = IV.fromLength(16);

  @override
  Future<void> saveMap(String key, Map data) async {
    var mapString = json.encode(data);
    var encryptedMapString = _encryptString(mapString);
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, encryptedMapString);
  }

  @override
  Future<Map<String, dynamic>?> getMap(String key) async {
    var preferences = await SharedPreferences.getInstance();

    if (preferences.containsKey(key) == false) {
      return null;
    }

    var encryptedMapString = preferences.getString(key);
    if (encryptedMapString == null) {
      return null;
    }

    var mapString = _decryptString(encryptedMapString);
    var map = json.decode(mapString);
    return map;
  }

  @override
  Future<void> saveInt(String key, int data) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setInt(key, data);
  }

  @override
  Future<int?> getInt(String key) async {
    var preferences = await SharedPreferences.getInstance();

    if (preferences.containsKey(key) == false) {
      return null;
    }

    var value = preferences.getInt(key);
    return value;
  }

  String _encryptString(String aString) {
    final key = Key.fromUtf8(encryptionKey);
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(aString, iv: initializationVector).base64;
  }

  String _decryptString(String base64String) {
    final key = Key.fromUtf8(encryptionKey);
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt(Encrypted.from64(base64String), iv: initializationVector);
  }
}
