import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';

class AppBootstrap extends ConsumerWidget {
  const AppBootstrap({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(momentumProvider.select((state) => state.isLoading));
    return child;
  }
}
