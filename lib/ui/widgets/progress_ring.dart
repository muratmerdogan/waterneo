import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Dairesel progress indicator widget'ı
class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final double size;
  final double strokeWidth;
  final Color? color;
  final Widget? centerChild;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 200.0,
    this.strokeWidth = 12.0,
    this.color,
    this.centerChild,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    final clampedProgress = progress.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arka plan dairesi
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(
                effectiveColor.withOpacity(0.1),
              ),
            ),
          ),
          // Progress dairesi
          Transform.rotate(
            angle: -math.pi / 2, // Saat 12'den başlaması için
            child: SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: clampedProgress,
                strokeWidth: strokeWidth,
                strokeCap: StrokeCap.round,
                valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
              ),
            ),
          ),
          // Merkez içerik
          if (centerChild != null) centerChild!,
        ],
      ),
    );
  }
}

