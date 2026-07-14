import 'package:go_router/go_router.dart';
import 'package:momentum/core/router/app_routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(initialLocation: const BootstrapRoute().location, routes: $appRoutes);
}
