import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../services/navigation_service.dart';
import '../../services/shared_preferences_service.dart';
import '../general_functions.dart';

enum LoaderState {
  normal,
  loading,
  failed,
  success,
}

abstract class LoaderViewModel extends ChangeNotifier {
  final NavigationService navigator = NavigationService();
  final SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
  LoaderState _state = LoaderState.normal;
  Exception? error;
  bool _disposed = false;

  bool get disposed => _disposed;

  bool get loading => _state == LoaderState.loading;

  bool get notLoading => !loading;

  bool get success => _state == LoaderState.success;

  bool get failed => _state == LoaderState.failed;

  bool get normal => _state == LoaderState.normal;

  LoaderState get state => _state;

  loadData({BuildContext? context, bool forceReload = false}) {
    if (!normal) {
      markAsLoading();
    }
  }

  @protected
  void updateState(LoaderState state, {bool emitEvent = true}) {
    if (_state == state) {
      return;
    }
    _state = state;
    if (!disposed && emitEvent) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> load(Future<void> Function() loader) async {
    try {
      markAsLoading();
      await loader();
      markAsSuccess();
    } on Exception catch (error) {
      markAsFailed(error: error);
      rethrow;
    }
  }

  void markAsLoading() {
    updateState(LoaderState.loading);
  }

  void markAsSuccess({dynamic arguments}) {
    error = null;
    updateState(LoaderState.success);
  }

  void markAsFailed({Exception? error}) {
    this.error = error;
    updateState(LoaderState.failed);
  }

  void markAsNormal({bool emitEvent = true}) {
    error = null;
    updateState(LoaderState.normal, emitEvent: emitEvent);
  }

  void scheduleLoadService(VoidCallback fn) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      fn();
    });
  }

  void showSnackBarMsg(
      {required BuildContext context, required String msg, Color? color}) {
    scheduleLoadService(() => showSnackBarMsgContext(
        context: context, msg: msg, backgroundColor: color));
  }
}
