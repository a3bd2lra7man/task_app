import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalKey extends Mock implements GlobalKey<FormState> {}

class MockStatus extends Mock implements FormState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

