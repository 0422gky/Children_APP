import 'dart:async';

/// 屏幕使用时间状态（仅用于前端 Demo）
class ScreenTimeState {
  final Duration used; // 今日已使用
  final Duration limit; // 每日上限
  final bool limitReached; // 是否已达到上限

  const ScreenTimeState({
    required this.used,
    required this.limit,
    required this.limitReached,
  });

  ScreenTimeState copyWith({
    Duration? used,
    Duration? limit,
    bool? limitReached,
  }) {
    return ScreenTimeState(
      used: used ?? this.used,
      limit: limit ?? this.limit,
      limitReached: limitReached ?? this.limitReached,
    );
  }
}

/// 简单的屏幕时间管理（纯前端 Demo，非系统级锁屏）
class ScreenTimeManager {
  // 为了演示方便，这里的“1 分钟”会被压缩成若干秒。
  // demoTickDuration 控制累加节奏，例如 1 秒钟视为 1 分钟。
  static const Duration _demoTickDuration = Duration(seconds: 5);

  // 每日上限（Demo：30 分钟）
  static const Duration _dailyLimit = Duration(minutes: 30);

  static final ScreenTimeManager instance = ScreenTimeManager._internal();

  ScreenTimeManager._internal();

  factory ScreenTimeManager() => instance;

  final StreamController<ScreenTimeState> _controller =
      StreamController<ScreenTimeState>.broadcast();

  Stream<ScreenTimeState> get stream => _controller.stream;

  ScreenTimeState _state = const ScreenTimeState(
    used: Duration.zero,
    limit: _dailyLimit,
    limitReached: false,
  );

  Timer? _timer;
  bool _limitPageShown = false;

  ScreenTimeState get currentState => _state;

  bool get limitPageShown => _limitPageShown;

  void markLimitPageShown() {
    _limitPageShown = true;
  }

  /// 启动 demo 计时器（幂等，多次调用只会启动一次）
  void start() {
    if (_timer != null) return;
    _timer = Timer.periodic(_demoTickDuration, (timer) {
      // 已经到达上限则停止累加
      if (_state.limitReached) {
        timer.cancel();
        _timer = null;
        return;
      }
      final newUsed = _state.used + const Duration(minutes: 1);
      final reached = newUsed >= _state.limit;
      _state = _state.copyWith(
        used: newUsed,
        limitReached: reached,
      );
      _controller.add(_state);
    });
  }

  /// 重置当日使用时间（仅 Demo 场景下可能会用到）
  void reset() {
    _timer?.cancel();
    _timer = null;
    _state = const ScreenTimeState(
      used: Duration.zero,
      limit: _dailyLimit,
      limitReached: false,
    );
    _limitPageShown = false;
    _controller.add(_state);
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}

