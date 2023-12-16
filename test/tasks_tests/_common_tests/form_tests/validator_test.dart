import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_app/tasks/_common/forms/form_validator.dart';

import '../../../_common/mocks/form_keys_mock.dart';

void main() {
  var mockKey = MockGlobalKey();
  var mockStatus = MockStatus();

  when(() => mockKey.currentState).thenReturn(mockStatus);

  var validator = TaskFormValidator.initWith(mockKey);

  test("isTitleValid when title is InValid", () {
    var title = "";

    var isValid = validator.isTitleValid(title);

    expect(isValid, "Please Enter Task Title");
  });

  test("isTitleValid when title is Valid", () {
    var title = "Valid title";

    var isValid = validator.isTitleValid(title);

    expect(isValid, null);
  });

  test("onCompletedChange function", () {
    var isCompleted = !validator.isCompleted;

    validator.onCompletedChanged(isCompleted);

    expect(isCompleted, validator.isCompleted);
  });

  test("validate return false when form key failed to validate", () {
    when(() => mockStatus.validate()).thenReturn(false);

    var isValid = validator.validate();

    expect(isValid, false);
  });

  test("validate return true when form key succeed to validate", () {
    when(() => mockStatus.validate()).thenReturn(true);

    var isValid = validator.validate();

    expect(isValid, true);
  });
}
