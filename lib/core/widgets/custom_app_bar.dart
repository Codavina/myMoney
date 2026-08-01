import 'package:flutter/material.dart';

import '../theme/app_color_extension.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: context.appColors.surface,
      foregroundColor: context.appColors.text,
      centerTitle: true,
      elevation: 1,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: context.appColors.border,),
      ),
      leading: leading,
      actions: actions,
    );
  }
}
