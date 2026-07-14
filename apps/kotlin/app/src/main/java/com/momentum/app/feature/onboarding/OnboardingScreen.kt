package com.momentum.app.feature.onboarding

import androidx.activity.compose.BackHandler
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.animateDpAsState
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.derivedStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.StrokeJoin
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.ProgressBarRangeInfo
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.progressBarRangeInfo
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.semantics.stateDescription
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.momentum.app.ui.theme.momentumColors
import kotlinx.coroutines.launch

private const val OnboardingPageCount = 3

private data class OnboardingPage(
    val eyebrow: String,
    val title: String,
    val description: String,
    val illustration: Illustration,
)

private enum class Illustration {
    PLAN,
    STREAK,
    PERSONALIZE,
}

private val OnboardingPages =
    listOf(
        OnboardingPage(
            eyebrow = "DEIN TAG",
            title = "Dein Tag. Klar im Blick.",
            description = "Plane Aufgaben, priorisiere das Wesentliche und behalte heute im Blick.",
            illustration = Illustration.PLAN,
        ),
        OnboardingPage(
            eyebrow = "DEINE SERIE",
            title = "Kleine Schritte, echte Serie.",
            description =
                "Jeder erledigte Tag stärkt deinen Streak – ohne Druck und ohne Ablenkung.",
            illustration = Illustration.STREAK,
        ),
        OnboardingPage(
            eyebrow = "DEIN RHYTHMUS",
            title = "Dein Rhythmus, deine Regeln.",
            description =
                "Ordne Aufgaben passend zu deinem Alltag und nutze Momentum so, wie es für dich funktioniert.",
            illustration = Illustration.PERSONALIZE,
        ),
    )

/**
 * Self-contained onboarding UI. Persistence and navigation stay with the caller through callbacks.
 */
@Composable
fun OnboardingScreen(
    onFinish: () -> Unit,
    modifier: Modifier = Modifier,
    onSkip: () -> Unit = onFinish,
) {
    val pagerState = rememberPagerState(pageCount = { OnboardingPageCount })
    val scope = rememberCoroutineScope()
    val currentPage by remember { derivedStateOf { pagerState.currentPage } }

    BackHandler(enabled = currentPage > 0) {
        scope.launch { pagerState.animateScrollToPage(currentPage - 1) }
    }

    Column(
        modifier =
            modifier
                .fillMaxSize()
                .background(MaterialTheme.colorScheme.background)
                .windowInsetsPadding(WindowInsets.safeDrawing)
    ) {
        OnboardingHeader(
            showSkip = currentPage < OnboardingPageCount - 1,
            onSkip = onSkip,
        )

        HorizontalPager(
            state = pagerState,
            key = { OnboardingPages[it].title },
            beyondViewportPageCount = 1,
            modifier = Modifier.weight(1f),
        ) { page ->
            OnboardingPageContent(
                page = OnboardingPages[page],
                modifier = Modifier.fillMaxSize(),
            )
        }

        OnboardingFooter(
            currentPage = currentPage,
            isPagerMoving = pagerState.isScrollInProgress,
            onBack = {
                scope.launch { pagerState.animateScrollToPage(currentPage - 1) }
            },
            onNext = {
                scope.launch { pagerState.animateScrollToPage(currentPage + 1) }
            },
            onFinish = onFinish,
        )
    }
}

@Composable
private fun OnboardingHeader(
    showSkip: Boolean,
    onSkip: () -> Unit,
) {
    Row(
        modifier = Modifier.fillMaxWidth().heightIn(min = 64.dp).padding(horizontal = 16.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        MomentumWordmark(modifier = Modifier.weight(1f))
        if (showSkip) {
            TextButton(
                onClick = onSkip,
                modifier = Modifier.heightIn(min = 48.dp).testTag("onboarding_skip"),
            ) {
                Text("Überspringen")
            }
        }
    }
}

@Composable
private fun MomentumWordmark(modifier: Modifier = Modifier) {
    val primary = MaterialTheme.colorScheme.primary
    Row(
        modifier = modifier,
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(10.dp),
    ) {
        Canvas(modifier = Modifier.size(width = 28.dp, height = 16.dp)) {
            val stroke = 3.dp.toPx()
            drawLine(
                color = primary,
                start = Offset(stroke / 2, size.height * 0.72f),
                end = Offset(size.width - stroke / 2, size.height * 0.28f),
                strokeWidth = stroke,
                cap = StrokeCap.Round,
            )
            drawCircle(
                color = primary,
                radius = 3.dp.toPx(),
                center = Offset(size.width - stroke / 2, size.height * 0.28f),
            )
        }
        Text(
            text = "MOMENTUM",
            style = MaterialTheme.typography.labelLarge,
            color = MaterialTheme.colorScheme.onBackground,
        )
    }
}

@Composable
private fun OnboardingPageContent(
    page: OnboardingPage,
    modifier: Modifier = Modifier,
) {
    BoxWithConstraints(modifier = modifier) {
        val useTwoColumns = maxWidth >= 600.dp && maxHeight >= 360.dp

        if (useTwoColumns) {
            Row(
                modifier = Modifier.fillMaxSize().padding(horizontal = 32.dp, vertical = 16.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Box(
                    modifier = Modifier.weight(0.46f).fillMaxHeight(),
                    contentAlignment = Alignment.Center,
                ) {
                    MomentumIllustration(
                        illustration = page.illustration,
                        modifier = Modifier.widthIn(max = 320.dp).fillMaxWidth().aspectRatio(1.12f),
                    )
                }
                OnboardingCopy(
                    page = page,
                    centered = false,
                    modifier =
                        Modifier.weight(0.54f)
                            .padding(start = 40.dp)
                            .verticalScroll(rememberScrollState()),
                )
            }
        } else {
            Column(
                modifier =
                    Modifier.fillMaxSize()
                        .verticalScroll(rememberScrollState())
                        .padding(horizontal = 24.dp, vertical = 12.dp),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center,
            ) {
                MomentumIllustration(
                    illustration = page.illustration,
                    modifier = Modifier.widthIn(max = 320.dp).fillMaxWidth().aspectRatio(1.12f),
                )
                Spacer(modifier = Modifier.height(28.dp))
                OnboardingCopy(
                    page = page,
                    centered = true,
                    modifier = Modifier.widthIn(max = 520.dp),
                )
            }
        }
    }
}

@Composable
private fun OnboardingCopy(
    page: OnboardingPage,
    centered: Boolean,
    modifier: Modifier = Modifier,
) {
    val textAlignment = if (centered) TextAlign.Center else TextAlign.Start
    val horizontalAlignment = if (centered) Alignment.CenterHorizontally else Alignment.Start

    Column(
        modifier = modifier,
        horizontalAlignment = horizontalAlignment,
    ) {
        Text(
            text = page.eyebrow,
            style = MaterialTheme.typography.labelLarge,
            color = MaterialTheme.colorScheme.primary,
            textAlign = textAlignment,
        )
        Spacer(modifier = Modifier.height(12.dp))
        Text(
            text = page.title,
            style = MaterialTheme.typography.headlineLarge,
            color = MaterialTheme.colorScheme.onBackground,
            textAlign = textAlignment,
        )
        Spacer(modifier = Modifier.height(12.dp))
        Text(
            text = page.description,
            style = MaterialTheme.typography.bodyLarge,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            textAlign = textAlignment,
        )
    }
}

@Composable
private fun MomentumIllustration(
    illustration: Illustration,
    modifier: Modifier = Modifier,
) {
    val colorScheme = MaterialTheme.colorScheme
    val semanticColors = MaterialTheme.momentumColors
    val illustrationBackground =
        when (illustration) {
            Illustration.PLAN -> colorScheme.primaryContainer
            Illustration.STREAK -> colorScheme.tertiaryContainer
            Illustration.PERSONALIZE -> colorScheme.secondaryContainer
        }

    Surface(
        modifier = modifier.clearAndSetSemantics {},
        shape = RoundedCornerShape(32.dp),
        color = illustrationBackground,
    ) {
        Box(modifier = Modifier.fillMaxSize()) {
            Canvas(modifier = Modifier.matchParentSize().padding(20.dp)) {
                when (illustration) {
                    Illustration.PLAN ->
                        drawPlanIllustration(
                            primary = colorScheme.primary,
                            surface = colorScheme.surface,
                            onSurface = colorScheme.onSurface,
                        )

                    Illustration.STREAK ->
                        drawStreakIllustration(
                            primary = colorScheme.tertiary,
                            surface = colorScheme.surface,
                            onSurface = colorScheme.onSurface,
                        )

                    Illustration.PERSONALIZE ->
                        drawPersonalizeIllustration(
                            colors =
                                listOf(
                                    semanticColors.categoryWork,
                                    semanticColors.categoryPersonal,
                                    semanticColors.categoryHealth,
                                    semanticColors.categoryLearning,
                                ),
                            primary = colorScheme.primary,
                            onSurface = colorScheme.onSurface,
                            surface = colorScheme.surface,
                        )
                }
            }

            if (illustration == Illustration.STREAK) {
                Column(
                    modifier = Modifier.align(Alignment.Center),
                    horizontalAlignment = Alignment.CenterHorizontally,
                ) {
                    Text(
                        text = "7",
                        style = MaterialTheme.typography.displayLarge,
                        color = colorScheme.onTertiaryContainer,
                    )
                    Text(
                        text = "TAGE",
                        style = MaterialTheme.typography.labelMedium,
                        color = colorScheme.onTertiaryContainer,
                    )
                }
            }
        }
    }
}

private fun DrawScope.drawPlanIllustration(
    primary: Color,
    surface: Color,
    onSurface: Color,
) {
    val points =
        listOf(
            Offset(size.width * 0.13f, size.height * 0.68f),
            Offset(size.width * 0.38f, size.height * 0.50f),
            Offset(size.width * 0.64f, size.height * 0.56f),
            Offset(size.width * 0.86f, size.height * 0.29f),
        )
    val path =
        Path().apply {
            moveTo(points[0].x, points[0].y)
            cubicTo(
                size.width * 0.23f,
                size.height * 0.67f,
                size.width * 0.27f,
                size.height * 0.50f,
                points[1].x,
                points[1].y,
            )
            cubicTo(
                size.width * 0.49f,
                size.height * 0.47f,
                size.width * 0.54f,
                size.height * 0.60f,
                points[2].x,
                points[2].y,
            )
            cubicTo(
                size.width * 0.74f,
                size.height * 0.51f,
                size.width * 0.78f,
                size.height * 0.33f,
                points[3].x,
                points[3].y,
            )
        }

    drawPath(
        path = path,
        color = primary.copy(alpha = 0.24f),
        style = Stroke(width = 12.dp.toPx(), cap = StrokeCap.Round, join = StrokeJoin.Round),
    )
    drawPath(
        path = path,
        color = primary,
        style = Stroke(width = 5.dp.toPx(), cap = StrokeCap.Round, join = StrokeJoin.Round),
    )

    points.forEachIndexed { index, point ->
        drawCircle(color = surface, radius = 18.dp.toPx(), center = point)
        drawCircle(
            color = if (index < points.lastIndex) primary else surface,
            radius = 11.dp.toPx(),
            center = point,
            style =
                if (index < points.lastIndex) androidx.compose.ui.graphics.drawscope.Fill
                else Stroke(3.dp.toPx()),
        )
        if (index < points.lastIndex) {
            val check =
                Path().apply {
                    moveTo(point.x - 5.dp.toPx(), point.y)
                    lineTo(point.x - 1.dp.toPx(), point.y + 4.dp.toPx())
                    lineTo(point.x + 6.dp.toPx(), point.y - 5.dp.toPx())
                }
            drawPath(
                path = check,
                color = surface,
                style = Stroke(2.dp.toPx(), cap = StrokeCap.Round, join = StrokeJoin.Round),
            )
        } else {
            drawCircle(color = onSurface.copy(alpha = 0.18f), radius = 4.dp.toPx(), center = point)
        }
    }
}

private fun DrawScope.drawStreakIllustration(
    primary: Color,
    surface: Color,
    onSurface: Color,
) {
    val diameter = size.minDimension * 0.62f
    val arcTopLeft = Offset((size.width - diameter) / 2f, size.height * 0.08f)

    drawArc(
        color = onSurface.copy(alpha = 0.10f),
        startAngle = -210f,
        sweepAngle = 240f,
        useCenter = false,
        topLeft = arcTopLeft,
        size = Size(diameter, diameter),
        style = Stroke(width = 14.dp.toPx(), cap = StrokeCap.Round),
    )
    drawArc(
        color = primary,
        startAngle = -210f,
        sweepAngle = 240f,
        useCenter = false,
        topLeft = arcTopLeft,
        size = Size(diameter, diameter),
        style = Stroke(width = 7.dp.toPx(), cap = StrokeCap.Round),
    )
    drawCircle(
        color = surface.copy(alpha = 0.88f),
        radius = size.minDimension * 0.20f,
        center = Offset(size.width / 2f, size.height * 0.40f),
    )

    val nodeY = size.height * 0.82f
    repeat(7) { index ->
        val x = size.width * (0.14f + index * 0.12f)
        drawCircle(
            color = primary,
            radius = if (index == 6) 7.dp.toPx() else 5.dp.toPx(),
            center = Offset(x, nodeY),
        )
        if (index < 6) {
            drawLine(
                color = primary.copy(alpha = 0.42f),
                start = Offset(x + 7.dp.toPx(), nodeY),
                end = Offset(size.width * (0.14f + (index + 1) * 0.12f) - 7.dp.toPx(), nodeY),
                strokeWidth = 2.dp.toPx(),
                cap = StrokeCap.Round,
            )
        }
    }
}

private fun DrawScope.drawPersonalizeIllustration(
    colors: List<Color>,
    primary: Color,
    onSurface: Color,
    surface: Color,
) {
    val centers =
        listOf(
            Offset(size.width * 0.28f, size.height * 0.29f),
            Offset(size.width * 0.72f, size.height * 0.29f),
            Offset(size.width * 0.28f, size.height * 0.62f),
            Offset(size.width * 0.72f, size.height * 0.62f),
        )
    val tileSize = Size(size.width * 0.34f, size.height * 0.24f)
    val corner = CornerRadius(18.dp.toPx(), 18.dp.toPx())

    centers.forEachIndexed { index, center ->
        val topLeft = Offset(center.x - tileSize.width / 2f, center.y - tileSize.height / 2f)
        drawRoundRect(
            color = surface.copy(alpha = 0.88f),
            topLeft = topLeft,
            size = tileSize,
            cornerRadius = corner,
        )
        drawCircle(
            color = colors[index].copy(alpha = 0.22f),
            radius = 18.dp.toPx(),
            center = center,
        )
        when (index) {
            0 -> {
                drawRoundRect(
                    color = colors[index],
                    topLeft = Offset(center.x - 8.dp.toPx(), center.y - 5.dp.toPx()),
                    size = Size(16.dp.toPx(), 12.dp.toPx()),
                    cornerRadius = CornerRadius(2.dp.toPx()),
                    style = Stroke(2.dp.toPx()),
                )
                drawLine(
                    color = colors[index],
                    start = Offset(center.x - 4.dp.toPx(), center.y - 7.dp.toPx()),
                    end = Offset(center.x + 4.dp.toPx(), center.y - 7.dp.toPx()),
                    strokeWidth = 2.dp.toPx(),
                )
            }

            1 -> {
                drawCircle(
                    color = colors[index],
                    radius = 5.dp.toPx(),
                    center = Offset(center.x, center.y - 5.dp.toPx()),
                )
                drawArc(
                    color = colors[index],
                    startAngle = 190f,
                    sweepAngle = 160f,
                    useCenter = false,
                    topLeft = Offset(center.x - 9.dp.toPx(), center.y + 1.dp.toPx()),
                    size = Size(18.dp.toPx(), 13.dp.toPx()),
                    style = Stroke(3.dp.toPx(), cap = StrokeCap.Round),
                )
            }

            2 -> {
                val leaf =
                    Path().apply {
                        moveTo(center.x, center.y + 10.dp.toPx())
                        cubicTo(
                            center.x - 13.dp.toPx(),
                            center.y + 2.dp.toPx(),
                            center.x - 8.dp.toPx(),
                            center.y - 10.dp.toPx(),
                            center.x + 9.dp.toPx(),
                            center.y - 10.dp.toPx(),
                        )
                        cubicTo(
                            center.x + 11.dp.toPx(),
                            center.y,
                            center.x + 7.dp.toPx(),
                            center.y + 7.dp.toPx(),
                            center.x,
                            center.y + 10.dp.toPx(),
                        )
                    }
                drawPath(path = leaf, color = colors[index])
                drawLine(
                    color = surface,
                    start = Offset(center.x - 4.dp.toPx(), center.y + 4.dp.toPx()),
                    end = Offset(center.x + 5.dp.toPx(), center.y - 5.dp.toPx()),
                    strokeWidth = 2.dp.toPx(),
                    cap = StrokeCap.Round,
                )
            }

            else -> {
                drawLine(
                    color = colors[index],
                    start = Offset(center.x, center.y - 10.dp.toPx()),
                    end = Offset(center.x, center.y + 10.dp.toPx()),
                    strokeWidth = 3.dp.toPx(),
                    cap = StrokeCap.Round,
                )
                drawLine(
                    color = colors[index],
                    start = Offset(center.x - 8.dp.toPx(), center.y - 6.dp.toPx()),
                    end = Offset(center.x + 8.dp.toPx(), center.y - 6.dp.toPx()),
                    strokeWidth = 3.dp.toPx(),
                    cap = StrokeCap.Round,
                )
                drawLine(
                    color = colors[index],
                    start = Offset(center.x - 8.dp.toPx(), center.y + 1.dp.toPx()),
                    end = Offset(center.x + 8.dp.toPx(), center.y + 1.dp.toPx()),
                    strokeWidth = 3.dp.toPx(),
                    cap = StrokeCap.Round,
                )
            }
        }
    }

    val toggleSize = Size(size.width * 0.32f, 30.dp.toPx())
    val toggleTopLeft = Offset((size.width - toggleSize.width) / 2f, size.height * 0.86f)
    drawRoundRect(
        color = onSurface.copy(alpha = 0.16f),
        topLeft = toggleTopLeft,
        size = toggleSize,
        cornerRadius = CornerRadius(toggleSize.height / 2f),
    )
    drawCircle(
        color = primary,
        radius = 11.dp.toPx(),
        center =
            Offset(
                toggleTopLeft.x + toggleSize.width - 15.dp.toPx(),
                toggleTopLeft.y + toggleSize.height / 2f,
            ),
    )
}

@Composable
private fun OnboardingFooter(
    currentPage: Int,
    isPagerMoving: Boolean,
    onBack: () -> Unit,
    onNext: () -> Unit,
    onFinish: () -> Unit,
) {
    Column(
        modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        PageIndicator(
            currentPage = currentPage,
            pageCount = OnboardingPageCount,
        )
        Spacer(modifier = Modifier.height(20.dp))
        Row(
            modifier = Modifier.widthIn(max = 560.dp).fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            if (currentPage > 0) {
                OutlinedButton(
                    onClick = onBack,
                    enabled = !isPagerMoving,
                    modifier = Modifier.weight(1f).heightIn(min = 52.dp).testTag("onboarding_back"),
                    contentPadding = PaddingValues(horizontal = 20.dp, vertical = 14.dp),
                ) {
                    Text("Zurück")
                }
            }

            if (currentPage == OnboardingPageCount - 1) {
                Button(
                    onClick = onFinish,
                    enabled = !isPagerMoving,
                    modifier =
                        Modifier.weight(1f).heightIn(min = 52.dp).testTag("onboarding_finish"),
                    contentPadding = PaddingValues(horizontal = 20.dp, vertical = 14.dp),
                ) {
                    Text("Momentum starten")
                }
            } else {
                Button(
                    onClick = onNext,
                    enabled = !isPagerMoving,
                    modifier = Modifier.weight(1f).heightIn(min = 52.dp).testTag("onboarding_next"),
                    contentPadding = PaddingValues(horizontal = 20.dp, vertical = 14.dp),
                    colors = ButtonDefaults.buttonColors(),
                ) {
                    Text("Weiter")
                }
            }
        }
    }
}

@Composable
private fun PageIndicator(
    currentPage: Int,
    pageCount: Int,
) {
    Row(
        modifier =
            Modifier.height(24.dp).semantics(mergeDescendants = true) {
                contentDescription = "Onboarding-Fortschritt"
                stateDescription = "Seite ${currentPage + 1} von $pageCount"
                progressBarRangeInfo =
                    ProgressBarRangeInfo(
                        current = currentPage.toFloat(),
                        range = 0f..(pageCount - 1).toFloat(),
                        steps = (pageCount - 2).coerceAtLeast(0),
                    )
            },
        horizontalArrangement = Arrangement.spacedBy(8.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        repeat(pageCount) { index ->
            val width by
                animateDpAsState(
                    targetValue = if (index == currentPage) 24.dp else 8.dp,
                    label = "Onboarding indicator width",
                )
            val color by
                animateColorAsState(
                    targetValue =
                        if (index == currentPage) {
                            MaterialTheme.colorScheme.primary
                        } else {
                            MaterialTheme.colorScheme.outlineVariant
                        },
                    label = "Onboarding indicator color",
                )
            Box(
                modifier =
                    Modifier.width(width)
                        .height(8.dp)
                        .background(color = color, shape = RoundedCornerShape(50))
            )
        }
    }
}
