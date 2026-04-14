import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/constants/strings.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.showAction = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 🏷 Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        // 👉 "See all"
        if (showAction)
          GestureDetector(
            onTap: () {
              // TODO: navigate later
            },
            child: const Text(
              AppStrings.seeAll,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}