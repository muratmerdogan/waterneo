import 'package:flutter/material.dart';
import '../../config/app_constants.dart';
import '../../config/app_strings.dart';

/// Hızlı ekleme butonları widget'ı
class QuickAddButtons extends StatelessWidget {
  final Function(int amount) onAdd;

  const QuickAddButtons({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            AppStrings.quickAdd,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _QuickAddButton(
                amount: AppConstants.quickAdd200,
                label: '200 ml',
                onTap: () => onAdd(AppConstants.quickAdd200),
              ),
              const SizedBox(width: 12),
              _QuickAddButton(
                amount: AppConstants.quickAdd250,
                label: '250 ml',
                onTap: () => onAdd(AppConstants.quickAdd250),
              ),
              const SizedBox(width: 12),
              _QuickAddButton(
                amount: AppConstants.quickAdd300,
                label: '300 ml',
                onTap: () => onAdd(AppConstants.quickAdd300),
              ),
              const SizedBox(width: 12),
              _CustomAddButton(
                onTap: () => _showCustomAmountDialog(context, onAdd),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCustomAmountDialog(BuildContext context, Function(int) onAdd) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.customAmount),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount (ml)',
            hintText: 'e.g.: 500',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(controller.text);
              if (amount != null && amount > 0) {
                onAdd(amount);
                Navigator.of(context).pop();
              }
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final int amount;
  final String label;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.amount,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '💧',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CustomAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.customAmount,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

