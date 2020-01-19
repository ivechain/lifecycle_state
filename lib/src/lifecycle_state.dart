import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

/// 生命周期状态：扩展Flutter生命周期
/// @author: grw
abstract class LifecycleState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver, RouteAware {
  String tag = T.toString();

  T get widget => super.widget;

  bool _isTop = false;
  WidgetsBinding _widgetsBinding;
  bool _isMount = false;

  @override
  @mustCallSuper
  void initState() {
    // TODO: implement initState
    super.initState();
    onCreate();
    onResume();
    _widgetsBinding = WidgetsBinding.instance;
    _widgetsBinding.addPostFrameCallback((callback) {
      if (!_isMount) {
        _isMount = true;
        onMount();
      }
    });
    _widgetsBinding.addObserver(this);
  }

  @override
  @mustCallSuper
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
//    log("deactivate");
  }

  @override
  @mustCallSuper
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
        onDetached();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.paused:
        if (_isTop) {
          onBackground();
          onPause();
        }
        break;
      case AppLifecycleState.resumed:
        if (_isTop) {
          onForeground();
          onResume();
        }
        break;
      default:
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  @mustCallSuper
  void dispose() {
    // TODO: implement dispose
    onDestroy();
    _widgetsBinding.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  @mustCallSuper
  void didPush() {
    // TODO: implement didPush
    super.didPush();
//    log("didPush");
    _isTop = true;
  }

  @override
  @mustCallSuper
  void didPushNext() {
    // TODO: implement didPushNext
    super.didPushNext();
//    log("didPushNext");
    onPause();
    _isTop = false;
  }

  @override
  @mustCallSuper
  void didPop() {
    // TODO: implement didPop
    super.didPop();
//    log("didPop");
    onPause();
  }

  @override
  @mustCallSuper
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
//    log("didPopNext");
    onResume();
    _isTop = true;
  }

  /// 应用处于Flutter渲染引擎中，与视图层分离
  void onDetached() {
//    log("onDetached");
  }

  /// 应用处于不活动状态，无法处理用户响应
  void onInactive() {
//    log("onInactive");
  }

  /// 应用处于创建状态，可初始化一些信息，例如：接口调用
  void onCreate() {
//    log("onCreate");
  }

  /// 应用处于不可见变为可见时的状态
  void onResume() {
//    log("onResume");
  }

  /// 应用处于build渲染完毕状态
  void onMount() {
//    log("onMount");
  }

  /// 应用处于不可见且不能响应用户的输入，但在后台继续活动中
  void onPause() {
//    log("onPause");
  }

  /// 应用处于销毁状态
  void onDestroy() {
//    log("onDestroy");
  }

  /// app切回到后台
  void onBackground() {
//    log("onBackground");
  }

  /// app切回到前台
  void onForeground() {
//    log("onForeground");
  }

  log(String log) {
    debugPrint('$tag --> $log');
  }
}
