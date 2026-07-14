import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_clock.g.dart';

abstract interface class IAppClock {
  DateTime nowLocal();
}

final class SystemAppClock implements IAppClock {
  const SystemAppClock();

  @override
  DateTime nowLocal() => DateTime.now().toLocal();
}

@Riverpod(keepAlive: true)
IAppClock appClock(Ref ref) => const SystemAppClock();
