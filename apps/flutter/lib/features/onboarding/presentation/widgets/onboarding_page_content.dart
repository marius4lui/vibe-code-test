import 'package:flutter/material.dart';
import 'package:momentum/core/extensions/context_extensions.dart';
import 'package:momentum/core/theme/app_icon_sizes.dart';
import 'package:momentum/core/theme/app_layout.dart';
import 'package:momentum/core/theme/app_radii.dart';
import 'package:momentum/core/theme/app_spacing.dart';

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    required this.icon,
    required this.title,
    required this.body,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: AppSpacing.page,
        child: ConstrainedBox(
          constraints: AppLayout.readingConstraints,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExcludeSemantics(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.s32),
                  decoration: BoxDecoration(
                    color: context.colors.primaryContainer,
                    borderRadius: AppRadii.extraLarge,
                  ),
                  child: Icon(
                    icon,
                    size: AppIconSizes.hero,
                    color: context.colors.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s40),
              Semantics(
                header: true,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(
                body,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
