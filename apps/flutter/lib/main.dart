import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/app/app_bootstrap.dart';
import 'package:momentum/core/app/momentum_app.dart';
import 'package:momentum/core/services/crash.dart';

Future<void> main() async {
  await runMomentumApp();
}

Future<void> runMomentumApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Crash.init();
  runApp(const ProviderScope(child: AppBootstrap(child: MomentumApp())));
}
