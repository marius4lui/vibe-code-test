package com.momentum.app.ui.theme

import androidx.compose.runtime.Immutable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color

internal val Pine40 = Color(0xFF2E5D4F)
internal val OnPine40 = Color(0xFFFFFFFF)
internal val Pine90 = Color(0xFFD0E8DE)
internal val OnPine90 = Color(0xFF10372D)
internal val Slate40 = Color(0xFF59635E)
internal val OnSlate40 = Color(0xFFFFFFFF)
internal val Slate90 = Color(0xFFDDE7E0)
internal val OnSlate90 = Color(0xFF17201C)
internal val Ochre40 = Color(0xFF76542B)
internal val OnOchre40 = Color(0xFFFFFFFF)
internal val Ochre90 = Color(0xFFF8DDBA)
internal val OnOchre90 = Color(0xFF2B1700)

internal val BackgroundLight = Color(0xFFF7F8F4)
internal val OnBackgroundLight = Color(0xFF181C19)
internal val SurfaceLight = Color(0xFFFFFFFF)
internal val SurfaceDimLight = Color(0xFFD8DCD7)
internal val SurfaceBrightLight = Color(0xFFF7F8F4)
internal val SurfaceContainerLowestLight = Color(0xFFFFFFFF)
internal val SurfaceContainerLowLight = Color(0xFFF1F3EE)
internal val SurfaceContainerLight = Color(0xFFEBEEE9)
internal val SurfaceContainerHighLight = Color(0xFFE5E8E3)
internal val SurfaceContainerHighestLight = Color(0xFFDFE3DE)
internal val OnSurfaceLight = Color(0xFF181C19)
internal val SurfaceVariantLight = Color(0xFFE9ECE6)
internal val OnSurfaceVariantLight = Color(0xFF414844)
internal val OutlineLight = Color(0xFF747974)
internal val OutlineVariantLight = Color(0xFFC4C9C4)
internal val ErrorLight = Color(0xFFBA1A1A)
internal val OnErrorLight = Color(0xFFFFFFFF)
internal val ErrorContainerLight = Color(0xFFFFDAD6)
internal val OnErrorContainerLight = Color(0xFF410002)

internal val Pine80 = Color(0xFF9AD1BD)
internal val OnPine80 = Color(0xFF00382C)
internal val Pine30 = Color(0xFF174D3E)
internal val OnPine30 = Color(0xFFB6EED9)
internal val Slate80 = Color(0xFFBEC9C2)
internal val OnSlate80 = Color(0xFF29332E)
internal val Slate30 = Color(0xFF3F4944)
internal val OnSlate30 = Color(0xFFDDE7E0)
internal val Ochre80 = Color(0xFFE7BF8C)
internal val OnOchre80 = Color(0xFF432C0B)
internal val Ochre30 = Color(0xFF5B3D17)
internal val OnOchre30 = Color(0xFFF8DDBA)

internal val BackgroundDark = Color(0xFF101412)
internal val OnBackgroundDark = Color(0xFFE0E4E0)
internal val SurfaceDark = Color(0xFF161B18)
internal val SurfaceDimDark = Color(0xFF101412)
internal val SurfaceBrightDark = Color(0xFF363B37)
internal val SurfaceContainerLowestDark = Color(0xFF0B0F0D)
internal val SurfaceContainerLowDark = Color(0xFF181D1A)
internal val SurfaceContainerDark = Color(0xFF1C211E)
internal val SurfaceContainerHighDark = Color(0xFF262B28)
internal val SurfaceContainerHighestDark = Color(0xFF313633)
internal val OnSurfaceDark = Color(0xFFE0E4E0)
internal val SurfaceVariantDark = Color(0xFF252B27)
internal val OnSurfaceVariantDark = Color(0xFFBEC9C2)
internal val OutlineDark = Color(0xFF8D938E)
internal val OutlineVariantDark = Color(0xFF414844)
internal val ErrorDark = Color(0xFFFFB4AB)
internal val OnErrorDark = Color(0xFF690005)
internal val ErrorContainerDark = Color(0xFF93000A)
internal val OnErrorContainerDark = Color(0xFFFFDAD6)

/** Colors whose meaning belongs to Momentum rather than to Material itself. */
@Immutable
data class MomentumSemanticColors(
    val categoryWork: Color,
    val categoryPersonal: Color,
    val categoryHealth: Color,
    val categoryLearning: Color,
    val priorityLow: Color,
    val priorityMedium: Color,
    val priorityHigh: Color,
    val success: Color,
)

internal val LightMomentumSemanticColors =
    MomentumSemanticColors(
        categoryWork = Color(0xFF356A96),
        categoryPersonal = Color(0xFF76558F),
        categoryHealth = Color(0xFF39735B),
        categoryLearning = Color(0xFF805A18),
        priorityLow = Color(0xFF356A96),
        priorityMedium = Color(0xFF805A18),
        priorityHigh = ErrorLight,
        success = Color(0xFF39735B),
    )

internal val DarkMomentumSemanticColors =
    MomentumSemanticColors(
        categoryWork = Color(0xFFA2C9F1),
        categoryPersonal = Color(0xFFD8B9EE),
        categoryHealth = Color(0xFF9BD4B5),
        categoryLearning = Color(0xFFF2C373),
        priorityLow = Color(0xFFA2C9F1),
        priorityMedium = Color(0xFFF2C373),
        priorityHigh = ErrorDark,
        success = Color(0xFF9BD4B5),
    )

internal val LocalMomentumSemanticColors = staticCompositionLocalOf { LightMomentumSemanticColors }
