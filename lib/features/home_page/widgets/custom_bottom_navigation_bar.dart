import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double _height = 68;
  static const double _radius = 12;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: _height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),

          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(0, -1),
              color: Color(0x22000000),
            ),
          ],
        ),

        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / 3;

            return Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,

                  left: currentIndex * itemWidth,

                  top: 8,
                  bottom: 8,

                  child: Container(
                    width: itemWidth,

                    alignment: Alignment.center,

                    child: Container(
                      width: itemWidth - 18,
                      decoration: BoxDecoration(
                        color: _selectedColor(currentIndex),

                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: _buildItem(
                        index: 0,
                        icon: Icons.home_rounded,
                        label: 'Home',
                      ),
                    ),

                    Expanded(
                      child: _buildItem(
                        index: 1,
                        icon: Icons.note_alt_rounded,
                        label: 'Notes',
                      ),
                    ),

                    Expanded(
                      child: _buildItem(
                        index: 2,
                        icon: Icons.settings_rounded,
                        label: 'Settings',
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool selected = currentIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => onTap(index),

      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: selected ? 30 : 26,
              color: selected ? Colors.black : Colors.grey,
            ),

            const SizedBox(height: 4),

            Visibility(
              visible: selected,

              maintainAnimation: true,
              maintainState: true,
              maintainSize: false,

              child: Text(
                label,

                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _selectedColor(int index) {
  switch (index) {
    case 0:
      return const Color(0xff5B4CF0);

    case 1:
      return const Color(0xff0F9D58);

    case 2:
      return const Color(0xffFF9800);

    default:
      return const Color(0xff5B4CF0);
  }
}
