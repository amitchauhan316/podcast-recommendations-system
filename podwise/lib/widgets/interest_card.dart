import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../models/category_model.dart';

class InterestCard extends StatelessWidget {
  final Category category;
  final bool selected;

  const InterestCard({
    super.key,
    required this.category,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),

        // ✨ Border highlight when selected
        border: Border.all(
          color: selected ? category.iconColor ?? AppColors.selectedBorder : AppColors.border,
          width: selected ? 2 : 1,
        ),

        // 🌟 Subtle glow effect
        boxShadow: selected
            ? [
                BoxShadow(
                  color: (category.iconColor ?? AppColors.primary).withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (category.iconData != null) ...[
                Icon(
                  category.iconData,
                  color: category.iconColor,
                  size: 32,
                ),
                const SizedBox(height: 12),
              ],
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (category.subtitle.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  category.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}