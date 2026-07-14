package com.momentum.app.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.ReadOnlyComposable

private val LightColorScheme =
    lightColorScheme(
        primary = Pine40,
        onPrimary = OnPine40,
        primaryContainer = Pine90,
        onPrimaryContainer = OnPine90,
        secondary = Slate40,
        onSecondary = OnSlate40,
        secondaryContainer = Slate90,
        onSecondaryContainer = OnSlate90,
        tertiary = Ochre40,
        onTertiary = OnOchre40,
        tertiaryContainer = Ochre90,
        onTertiaryContainer = OnOchre90,
        background = BackgroundLight,
        onBackground = OnBackgroundLight,
        surface = SurfaceLight,
        surfaceDim = SurfaceDimLight,
        surfaceBright = SurfaceBrightLight,
        surfaceContainerLowest = SurfaceContainerLowestLight,
        surfaceContainerLow = SurfaceContainerLowLight,
        surfaceContainer = SurfaceContainerLight,
        surfaceContainerHigh = SurfaceContainerHighLight,
        surfaceContainerHighest = SurfaceContainerHighestLight,
        onSurface = OnSurfaceLight,
        surfaceVariant = SurfaceVariantLight,
        onSurfaceVariant = OnSurfaceVariantLight,
        outline = OutlineLight,
        outlineVariant = OutlineVariantLight,
        error = ErrorLight,
        onError = OnErrorLight,
        errorContainer = ErrorContainerLight,
        onErrorContainer = OnErrorContainerLight,
        inverseSurface = ColorTokens.inverseSurfaceLight,
        inverseOnSurface = ColorTokens.inverseOnSurfaceLight,
        inversePrimary = Pine80,
        scrim = ColorTokens.scrim,
        surfaceTint = Pine40,
    )

private val DarkColorScheme =
    darkColorScheme(
        primary = Pine80,
        onPrimary = OnPine80,
        primaryContainer = Pine30,
        onPrimaryContainer = OnPine30,
        secondary = Slate80,
        onSecondary = OnSlate80,
        secondaryContainer = Slate30,
        onSecondaryContainer = OnSlate30,
        tertiary = Ochre80,
        onTertiary = OnOchre80,
        tertiaryContainer = Ochre30,
        onTertiaryContainer = OnOchre30,
        background = BackgroundDark,
        onBackground = OnBackgroundDark,
        surface = SurfaceDark,
        surfaceDim = SurfaceDimDark,
        surfaceBright = SurfaceBrightDark,
        surfaceContainerLowest = SurfaceContainerLowestDark,
        surfaceContainerLow = SurfaceContainerLowDark,
        surfaceContainer = SurfaceContainerDark,
        surfaceContainerHigh = SurfaceContainerHighDark,
        surfaceContainerHighest = SurfaceContainerHighestDark,
        onSurface = OnSurfaceDark,
        surfaceVariant = SurfaceVariantDark,
        onSurfaceVariant = OnSurfaceVariantDark,
        outline = OutlineDark,
        outlineVariant = OutlineVariantDark,
        error = ErrorDark,
        onError = OnErrorDark,
        errorContainer = ErrorContainerDark,
        onErrorContainer = OnErrorContainerDark,
        inverseSurface = ColorTokens.inverseSurfaceDark,
        inverseOnSurface = ColorTokens.inverseOnSurfaceDark,
        inversePrimary = Pine40,
        scrim = ColorTokens.scrim,
        surfaceTint = Pine80,
    )

private object ColorTokens {
    val inverseSurfaceLight = androidx.compose.ui.graphics.Color(0xFF2D312E)
    val inverseOnSurfaceLight = androidx.compose.ui.graphics.Color(0xFFF0F1ED)
    val inverseSurfaceDark = androidx.compose.ui.graphics.Color(0xFFE0E4E0)
    val inverseOnSurfaceDark = androidx.compose.ui.graphics.Color(0xFF2D312E)
    val scrim = androidx.compose.ui.graphics.Color.Black
}

/** Applies Momentum's fixed brand palette. Dynamic colors are intentionally not used. */
@Composable
fun MomentumTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit,
) {
    val semanticColors = if (darkTheme) DarkMomentumSemanticColors else LightMomentumSemanticColors

    CompositionLocalProvider(LocalMomentumSemanticColors provides semanticColors) {
        MaterialTheme(
            colorScheme = if (darkTheme) DarkColorScheme else LightColorScheme,
            typography = MomentumTypography,
            shapes = MomentumShapes,
            content = content,
        )
    }
}

val MaterialTheme.momentumColors: MomentumSemanticColors
    @Composable @ReadOnlyComposable get() = LocalMomentumSemanticColors.current
