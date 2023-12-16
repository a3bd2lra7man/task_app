import 'package:task_app/tasks/_core/entities/task.dart';

import '../../../_common/api/exceptions/invalid_response_exception.dart';
import '../../../_common/api/utils/connection_checker.dart';
import '../../../_common/cache_storage/cache_storage.dart';
import '../../../_common/cache_storage/secure_shred_preference.dart';
import '../services/task_list_fetcher.dart';

class TasksRepository {
  static const _key = 'tasks';
  static const _paginationKey = 'tasks_last_page';

  final int _perPage;
  int _pageNumber = 0;
  bool _didReachListEnd = false;

  final TasksFetcher _fetcher;
  final CacheStorage _cache;
  final ConnectionChecker _connection;

  List<Task> tasks = [];

  TasksRepository()
      : _fetcher = TasksFetcher(),
        _cache = SecureSharedPreference(),
        _connection = ConnectionChecker(),
        _perPage = 15;

  TasksRepository.initWith(this._fetcher, this._cache, this._connection, this._perPage);

  // MARK: functions to get tasks from api or local storage

  // it call api in both cases (online,offline) to propagate the error
  Future<void> getNext() async {
    if (didReachListEnd) return;
    if (await _shouldLoadFromCache()) {
      tasks = await _getFromCache();
      _pageNumber = await _cache.getInt(_paginationKey) ?? 0;
    }
    var newList = await _getFromApi();
    tasks.addAll(newList);
    await _updateCache();
  }

  Future<bool> _shouldLoadFromCache() async {
    return !(await _connection.hasInternetAccess) && tasks.isEmpty;
  }

  Future<List<Task>> _getFromCache() async {
    var mapList = await _cache.getMap(_key);
    if (mapList == null) return [];
    var tasks = _readItemsFromResponse(mapList['list']);
    return tasks;
  }

  Future<List<Task>> _getFromApi() async {
    var newListJson = await _fetcher.getNext(_pageNumber, _perPage);
    var newList = _readItemsFromResponse(newListJson);
    await _updatePaginationRelatedData(newList.length);
    return newList;
  }

  List<Task> _readItemsFromResponse(List mapList) {
    try {
      var tasks = <Task>[];
      for (var responseMap in mapList) {
        var item = Task.fromJson(responseMap);
        tasks.add(item);
      }
      return tasks;
    } catch (e) {
      throw InvalidResponseException(e);
    }
  }

  // MARK: functions to update local storage when get/update/delete/add happens on tasks

  Future _updateCache() async {
    await _cache.saveMap(_key, {'list': tasks.map((e) => e.toJson()).toList()});
  }

  Future onTaskDeleted(Task task) async {
    tasks.remove(task);
    await _updateCache();
  }

  Future onTaskAdded(Task newTask) async {
    tasks.insert(0, newTask);
    await _updateCache();
  }

  Future onTaskUpdated() async {
    await _updateCache();
  }

  // MARK: functions to handle pagination

  Future _updatePaginationRelatedData(int noOfItemsReceived) async {
    if (noOfItemsReceived > 0) {
      _pageNumber += 1;
    }
    if (noOfItemsReceived < _perPage) {
      _didReachListEnd = true;
    }
    await _cache.saveInt(_paginationKey, _pageNumber);
  }

  void reset() {
    _didReachListEnd = false;
    _pageNumber = 0;
    tasks = [];
  }

  // MARK: Getters

  int get pageNumber => _pageNumber;

  bool get didReachListEnd => _didReachListEnd;
}
