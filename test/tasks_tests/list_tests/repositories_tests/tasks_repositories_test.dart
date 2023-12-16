import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/_common/api/exceptions/api_exception.dart';
import 'package:task_app/_common/api/exceptions/invalid_response_exception.dart';
import 'package:task_app/_common/api/utils/connection_checker.dart';
import 'package:task_app/_common/cache_storage/secure_shred_preference.dart';
import 'package:task_app/tasks/_core/entities/task.dart';
import 'package:task_app/tasks/list/repositories/tasks_repositories.dart';
import 'package:task_app/tasks/list/services/task_list_fetcher.dart';

import '../_mocks/tasks_list_response.dart';

class MockTasksFetcher extends Mock implements TasksFetcher {}

class MockCache extends Mock implements SecureSharedPreference {}

class MockConnection extends Mock implements ConnectionChecker {}

void main() {
  var mockFetcher = MockTasksFetcher();
  var mockCache = MockCache();
  var connection = MockConnection();
  var paginationPerPage = 10;
  var task = Task(id: 1, title: "title", completed: true);

  var repo = TasksRepository.initWith(mockFetcher, mockCache, connection, paginationPerPage);

  void clearInteractionsOnMocks() {
    clearInteractions(mockFetcher);
    clearInteractions(mockCache);
    clearInteractions(connection);
  }

  setUp(() {
    clearInteractionsOnMocks();
    repo = TasksRepository.initWith(mockFetcher, mockCache, connection, paginationPerPage);
  });

  void verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(connection);
    verifyNoMoreInteractions(mockCache);
    verifyNoMoreInteractions(mockFetcher);
  }

  group('case there is Internet | load from api', () {
    test('failure to load from api', () async {
      when(() => connection.hasInternetAccess).thenAnswer((invocation) => Future.value(true));
      var e = InvalidResponseException("in test file task_repository_test");
      when(() => mockFetcher.getNext(any(), any())).thenThrow(e);

      try {
        await repo.getNext();
        fail('Fail to throw InvalidResponseException');
      } catch (e) {
        expect(e is InvalidResponseException, true);
      }

      verifyInOrder([
        () => connection.hasInternetAccess,
        () => mockFetcher.getNext(any(), any()),
      ]);
      verifyNoMoreInteractionsOnAllMocks();
    });

    test('succeed loading from api then saving tasks and current pagination page number to cache', () async {
      when(() => connection.hasInternetAccess).thenAnswer((invocation) => Future.value(true));
      when(() => mockCache.saveMap(any(), any())).thenAnswer((_) => Future.value());
      when(() => mockCache.saveInt(any(), any())).thenAnswer((_) => Future.value());
      when(() => mockFetcher.getNext(any(), any())).thenAnswer((_) => Future.value(tasksListResponse));

      await repo.getNext();

      verifyInOrder([
        () => connection.hasInternetAccess,
        () => mockFetcher.getNext(any(), any()),
        () => mockCache.saveInt(any(), 1),
        () => mockCache.saveMap(any(), any()),
      ]);
      expect(repo.tasks.length, tasksListResponse.length);
      verifyNoMoreInteractionsOnAllMocks();
    });

    test('throws InvalidResponseException when api response is not as expected', () async {
      when(() => connection.hasInternetAccess).thenAnswer((invocation) => Future.value(true));
      when(() => mockCache.saveMap(any(), any())).thenAnswer((_) => Future.value());
      when(() => mockCache.saveInt(any(), any())).thenAnswer((_) => Future.value());
      when(() => mockFetcher.getNext(any(), any())).thenAnswer((_) => Future.value([
            ...tasksListResponse,
            {"_id": ""}
          ]));

      try {
        await repo.getNext();
        fail('Failed to throw Invalid Response Exception');
      } catch (e) {
        expect(e is InvalidResponseException, true);
      }

      verifyInOrder([
        () => connection.hasInternetAccess,
        () => mockFetcher.getNext(any(), any()),
      ]);
      verifyNoMoreInteractionsOnAllMocks();
    });

    test('when pagination reach end then repo do nothing', () async {
      when(() => connection.hasInternetAccess).thenAnswer((invocation) => Future.value(true));
      when(() => mockCache.saveMap(any(), any())).thenAnswer((_) => Future.value());
      when(() => mockCache.saveInt(any(), any())).thenAnswer((_) => Future.value());
      when(() => mockFetcher.getNext(any(), any()))
          .thenAnswer((_) => Future.value(List.generate(paginationPerPage ~/ 2, (_) => tasksListResponse[0])));
      await repo.getNext();
      clearInteractionsOnMocks();

      await repo.getNext();

      expect(repo.didReachListEnd, true);
      verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group('case there is no Internet | load from cache ', () {
    test('case cache is empty', () async {
      when(() => connection.hasInternetAccess).thenAnswer((invocation) => Future.value(false));
      when(() => mockCache.getMap(any())).thenAnswer((_) => Future.value(null));
      when(() => mockCache.getInt(any())).thenAnswer((_) => Future.value(null));
      var e = NetworkFailureException("in test file task_repository_test");
      when(() => mockFetcher.getNext(any(), any())).thenThrow(e);

      try {
        await repo.getNext();
        fail('Fail to throw NetworkFailureException');
      } catch (e) {
        expect(e is NetworkFailureException, true);
      }

      verifyInOrder([
        () => connection.hasInternetAccess,
        () => mockCache.getMap(any()),
        () => mockCache.getInt(any()),
        () => mockFetcher.getNext(any(), any()),
      ]);
      verifyNoMoreInteractionsOnAllMocks();
    });

    test('case cache is not empty', () async {
      when(() => connection.hasInternetAccess).thenAnswer((invocation) => Future.value(false));
      when(() => mockCache.getInt(any())).thenAnswer((_) => Future.value(10));
      when(() => mockCache.getMap(any())).thenAnswer((_) => Future.value({
            "list": [...tasksListResponse, ...tasksListResponse]
          }));
      var e = NetworkFailureException("in test file task_repository_test");
      when(() => mockFetcher.getNext(any(), any())).thenThrow(e);

      try {
        await repo.getNext();
        fail('Fail to throw NetworkFailureException');
      } catch (e) {
        expect(e is NetworkFailureException, true);
      }

      verifyInOrder([
        () => connection.hasInternetAccess,
        () => mockCache.getMap(any()),
        () => mockCache.getInt(any()),
        () => mockFetcher.getNext(any(), any()),
      ]);
      expect(repo.tasks.length, tasksListResponse.length * 2);
      expect(repo.pageNumber, 10);
      verifyNoMoreInteractionsOnAllMocks();
    });

    test('throws InvalidResponseException when cache response is not as expected', () async {
      when(() => connection.hasInternetAccess).thenAnswer((invocation) => Future.value(false));
      when(() => mockCache.getMap(any())).thenAnswer((_) => Future.value({
            "list": [
              ...tasksListResponse,
              ...tasksListResponse,
              {"malformed": "yes"}
            ]
          }));

      try {
        await repo.getNext();
        fail('Fail to throw InvalidResponseException');
      } catch (e) {
        expect(e is InvalidResponseException, true);
      }

      verifyInOrder([
        () => connection.hasInternetAccess,
        () => mockCache.getMap(any()),
      ]);
      verifyNoMoreInteractionsOnAllMocks();
    });

    test('case tasks in memory is not empty it does not load from cache', () async {
      when(() => connection.hasInternetAccess).thenAnswer((invocation) => Future.value(false));
      when(() => mockCache.getInt(any())).thenAnswer((_) => Future.value(10));
      when(() => mockCache.getMap(any()))
          .thenAnswer((_) => Future.value({"list": List.generate(20, (index) => tasksListResponse[0])}));
      try {
        await repo.getNext();
      } catch (_) {}
      clearInteractionsOnMocks();
      var e = InvalidResponseException("in test file task_repository_test");
      when(() => mockFetcher.getNext(any(), any())).thenThrow(e);

      try {
        await repo.getNext();
        fail('Fail to throw InvalidResponseException');
      } catch (e) {
        expect(e is InvalidResponseException, true);
      }

      verifyInOrder([
        () => connection.hasInternetAccess,
        () => mockFetcher.getNext(any(), any()),
      ]);
      verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group("test unctions to update local storage when get/update/delete/add happens on tasks", () {
    test('on task added', () async {
      when(() => mockCache.saveMap(any(), any())).thenAnswer((_) => Future.value());
      var oldListLength = repo.tasks.length;

      await repo.onTaskAdded(task);

      expect(repo.tasks.length, oldListLength + 1);
      verify(() => mockCache.saveMap(any(), any()));
      verifyNoMoreInteractionsOnAllMocks();
    });

    test('on task updated', () async {
      when(() => mockCache.saveMap(any(), any())).thenAnswer((_) => Future.value());
      var oldListLength = repo.tasks.length;

      await repo.onTaskUpdated();

      expect(repo.tasks.length, oldListLength);
      verify(() => mockCache.saveMap(any(), any()));
      verifyNoMoreInteractionsOnAllMocks();
    });

    test('on task deleted', () async {
      when(() => mockCache.saveMap(any(), any())).thenAnswer((_) => Future.value());
      var taskWillBeDeleted = Task(id: 2, title: "title", completed: false);
      await repo.onTaskAdded(taskWillBeDeleted);
      clearInteractionsOnMocks();
      var oldListLength = repo.tasks.length;

      await repo.onTaskDeleted(taskWillBeDeleted);

      expect(repo.tasks.length, oldListLength - 1);
      verify(() => mockCache.saveMap(any(), any()));
      verifyNoMoreInteractionsOnAllMocks();
    });
  });

  test('reset clears the task and pagination data', () async {
    when(() => connection.hasInternetAccess).thenAnswer((invocation) => Future.value(true));
    when(() => mockCache.saveMap(any(), any())).thenAnswer((_) => Future.value());
    when(() => mockCache.saveInt(any(), any())).thenAnswer((_) => Future.value());
    when(() => mockFetcher.getNext(any(), any()))
        .thenAnswer((_) => Future.value(List.generate(paginationPerPage ~/ 2, (_) => tasksListResponse[0])));
    await repo.getNext();
    clearInteractionsOnMocks();

    repo.reset();

    expect(repo.didReachListEnd, false);
    expect(repo.pageNumber, 0);
    expect(repo.tasks.isEmpty, true);
    verifyNoMoreInteractionsOnAllMocks();
  });
}
