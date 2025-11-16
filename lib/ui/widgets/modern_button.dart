import 'package:flutter/material.dart';
import '../../config/design_system.dart';

/// Modern Button Widget with animations
class ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final bool isOutlined;
  final bool isLoading;
  final double? width;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.isOutlined = false,
    this.isLoading = false,
    this.width,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: DesignSystem.animationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: DesignSystem.defaultCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        else if (widget.icon != null) ...[
          Icon(widget.icon, size: 20),
          const SizedBox(width: DesignSystem.spacingS),
        ],
        Text(widget.text),
      ],
    );

    Widget button;
    if (widget.isOutlined) {
      button = OutlinedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: widget.width != null
              ? Size(widget.width!, 48)
              : const Size(double.infinity, 48),
        ),
        child: buttonContent,
      );
    } else if (widget.isPrimary) {
      button = FilledButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: FilledButton.styleFrom(
          minimumSize: widget.width != null
              ? Size(widget.width!, 48)
              : const Size(double.infinity, 48),
        ),
        child: buttonContent,
      );
    } else {
      button = ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: widget.width != null
              ? Size(widget.width!, 48)
              : const Size(double.infinity, 48),
        ),
        child: buttonContent,
      );
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: button,
      ),
    );
  }
}

