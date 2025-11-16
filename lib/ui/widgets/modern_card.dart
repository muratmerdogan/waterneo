import 'package:flutter/material.dart';
import '../../config/design_system.dart';

/// Modern Card Widget - Rounded corners, clean design
class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final VoidCallback? onTap;
  final double? borderRadius;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Theme.of(context).cardColor;
    final borderRadiusValue = borderRadius ?? DesignSystem.radiusLarge;

    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(DesignSystem.spacingL),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        boxShadow: DesignSystem.lightShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child: cardContent,
      );
    }

    return cardContent;
  }
}

