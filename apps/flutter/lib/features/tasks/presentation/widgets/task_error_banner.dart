import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/widgets/error_banner.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';
import 'package:momentum/features/momentum/presentation/state/app_operation.dart';

class TaskErrorBanner extends ConsumerWidget {
  const TaskErrorBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final failure = ref.watch(
      momentumProvider.select((state) => (error: state.error, operation: state.failedOperation)),
    );
    final isTaskFailure = switch (failure.operation) {
      AppOperation.create ||
      AppOperation.update ||
      AppOperation.toggle ||
      AppOperation.delete => true,
      _ => false,
    };
    if (failure.error == null || !isTaskFailure) return const SizedBox.shrink();

    return ErrorBanner(
      title: l10n.startupErrorTitle,
      message: failure.operation == AppOperation.delete ? l10n.taskDeleteError : l10n.taskSaveError,
      dismissLabel: l10n.dismiss,
      onDismiss: () => ref.read(momentumProvider.notifier).clearError(),
    );
  }
}
