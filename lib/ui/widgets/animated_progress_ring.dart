import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animasyonlu Progress Ring Widget
class AnimatedProgressRing extends StatefulWidget {
  final double progress; // 0.0 - 1.0
  final double size;
  final double strokeWidth;
  final Color? color;
  final Widget? centerChild;
  final Duration animationDuration;

  const AnimatedProgressRing({
    super.key,
    required this.progress,
    this.size = 200.0,
    this.strokeWidth = 12.0,
    this.color,
    this.centerChild,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  State<AnimatedProgressRing> createState() => _AnimatedProgressRingState();
}

class _AnimatedProgressRingState extends State<AnimatedProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _previousProgress = widget.progress;
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _previousProgress = _animation.value;
      _animation = Tween<double>(
        begin: _previousProgress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? Theme.of(context).colorScheme.primary;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final clampedProgress = _animation.value.clamp(0.0, 1.0);
        
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Arka plan dairesi
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: widget.strokeWidth,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    effectiveColor.withOpacity(0.1),
                  ),
                ),
              ),
              // Progress dairesi
              Transform.rotate(
                angle: -math.pi / 2, // Saat 12'den başlaması için
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: CircularProgressIndicator(
                    value: clampedProgress,
                    strokeWidth: widget.strokeWidth,
                    strokeCap: StrokeCap.round,
                    valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
                  ),
                ),
              ),
              // Merkez içerik
              if (widget.centerChild != null) widget.centerChild!,
            ],
          ),
        );
      },
    );
  }
}

