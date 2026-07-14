import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/router/app_routes.dart';
import 'package:momentum/core/testing/app_widget_keys.dart';
import 'package:momentum/core/theme/app_motion.dart';
import 'package:momentum/core/theme/app_radii.dart';
import 'package:momentum/core/theme/app_spacing.dart';
import 'package:momentum/core/widgets/error_banner.dart';
import 'package:momentum/features/momentum/presentation/notifiers/momentum_notifier.dart';
import 'package:momentum/features/momentum/presentation/state/app_operation.dart';
import 'package:momentum/features/onboarding/presentation/widgets/onboarding_page_content.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const int _pageCount = 3;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(
      momentumProvider.select(
        (value) => (
          activeOperation: value.activeOperation,
          error: value.error,
          failedOperation: value.failedOperation,
        ),
      ),
    );
    final isSaving = state.activeOperation == AppOperation.onboarding;

    ref.listen(momentumProvider.select((value) => value.preferences.onboardingCompleted), (
      previous,
      next,
    ) {
      if (next && previous != next) const TodayRoute().go(context);
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
                child: TextButton(
                  key: const ValueKey(AppWidgetKeys.onboardingSkipButton),
                  onPressed: isSaving ? null : _completeOnboarding,
                  child: Text(l10n.onboardingSkip),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  OnboardingPageContent(
                    icon: Icons.center_focus_strong_rounded,
                    title: l10n.onboardingOneTitle,
                    body: l10n.onboardingOneBody,
                  ),
                  OnboardingPageContent(
                    icon: Icons.local_fire_department_rounded,
                    title: l10n.onboardingTwoTitle,
                    body: l10n.onboardingTwoBody,
                  ),
                  OnboardingPageContent(
                    icon: Icons.lock_outline_rounded,
                    title: l10n.onboardingThreeTitle,
                    body: l10n.onboardingThreeBody,
                  ),
                ],
              ),
            ),
            if (state.error != null && state.failedOperation == AppOperation.onboarding)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
                child: ErrorBanner(
                  title: l10n.startupErrorTitle,
                  message: l10n.onboardingSaveError,
                  dismissLabel: l10n.dismiss,
                  onDismiss: () => ref.read(momentumProvider.notifier).clearError(),
                ),
              ),
            Padding(
              padding: AppSpacing.page,
              child: Column(
                children: [
                  Semantics(
                    label: l10n.onboardingPageSemantics(_currentPage + 1, _pageCount),
                    child: ExcludeSemantics(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(
                          _pageCount,
                          (index) => AnimatedContainer(
                            duration: AppMotion.instant,
                            curve: AppMotion.standardCurve,
                            width: index == _currentPage ? AppSpacing.s24 : AppSpacing.s8,
                            height: AppSpacing.s8,
                            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                            decoration: BoxDecoration(
                              color: index == _currentPage
                                  ? context.colors.primary
                                  : context.colors.surfaceContainerHighest,
                              borderRadius: AppRadii.full,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: ValueKey(
                        _currentPage == _pageCount - 1
                            ? AppWidgetKeys.onboardingStartButton
                            : AppWidgetKeys.onboardingNextButton,
                      ),
                      onPressed: isSaving ? null : _handlePrimaryAction,
                      icon: Icon(
                        _currentPage == _pageCount - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.navigate_next_rounded,
                      ),
                      label: Text(
                        _currentPage == _pageCount - 1 ? l10n.onboardingStart : l10n.onboardingNext,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completeOnboarding() {
    unawaited(ref.read(momentumProvider.notifier).completeOnboarding());
  }

  void _handlePrimaryAction() {
    if (_currentPage == _pageCount - 1) {
      _completeOnboarding();
      return;
    }
    if (MediaQuery.disableAnimationsOf(context)) {
      _pageController.jumpToPage(_currentPage + 1);
      return;
    }
    unawaited(
      _pageController.animateToPage(
        _currentPage + 1,
        duration: AppMotion.instant,
        curve: AppMotion.enter,
      ),
    );
  }
}
