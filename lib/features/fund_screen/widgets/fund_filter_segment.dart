import 'package:flutter/material.dart';

enum FundFilter {
  active,
  archived,
  all,
}

class FundFilterSegment extends StatelessWidget {
  const FundFilterSegment({
    super.key,
    required this.selected,
    required this.activeCount,
    required this.archivedCount,
    required this.onChanged,
  });

  final FundFilter selected;
  final int activeCount;
  final int archivedCount;

  final ValueChanged<FundFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final total = activeCount + archivedCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SegmentedButton<FundFilter>(
        showSelectedIcon: false,

        segments: [
          ButtonSegment(
            value: FundFilter.active,
            label: Text('Active ($activeCount)'),
          ),
          ButtonSegment(
            value: FundFilter.archived,
            label: Text('Archived ($archivedCount)'),
          ),
          ButtonSegment(
            value: FundFilter.all,
            label: Text('All ($total)'),
          ),
        ],

        selected: {selected},

        onSelectionChanged: (value) {
          onChanged(value.first);
        },

        style: ButtonStyle(
          backgroundColor:
          WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xff0088CC);
            }

            return const Color(0xffF4F6F8);
          }),

          foregroundColor:
          WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }

            return Colors.black87;
          }),

          side: WidgetStateProperty.all(
            const BorderSide(
              color: Color(0xffD8E2E8),
            ),
          ),

          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 18,
            ),
          ),

          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}