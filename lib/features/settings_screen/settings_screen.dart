import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/widgets/custom_app_bar.dart';
import '../../core/theme/app_color_extension.dart';
import '../../core/theme/theme_cubit.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: const CustomAppBar(title: 'Settings'),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // =========================================================
            // Appearance
            // =========================================================

            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                final isDark = themeMode == ThemeMode.dark;

                return _SettingsSection(
                 title: 'Theme',
                 children: [ _SettingsTile(
                    icon: Icons.palette_outlined,
                    title: 'Theme',
                    subtitle: isDark ? 'Dark' : 'Light',
                    trailing: Switch(
                      value: isDark,
                      onChanged: (_) {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    ),
                    onTap: () {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                ]);
              },
            ),

            const SizedBox(height: 20),

            // =========================================================
            // Language
            // =========================================================

            _SettingsSection(
              title: 'Language',
              children: [
                _SettingsTile(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  subtitle: 'English',
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    // Language selection logic later
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =========================================================
            // Account
            // =========================================================

            _SettingsSection(
              title: 'Account',
              children: [
                const _SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Account',
                  subtitle: 'admin@gmail.com',
                  onTap: null,
                ),

                Divider(
                  height: 1,
                  color: context.appColors.border,
                ),

                _SettingsTile(
                  icon: Icons.logout_outlined,
                  title: 'Sign Out',
                  titleColor: context.appColors.error,
                  iconColor: context.appColors.error,
                  onTap: () {
                    // Sign out logic later
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =========================================================
            // About
            // =========================================================

            _SettingsSection(
              title: 'About',
              children: [
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: 'About My Money',
                  subtitle: 'Version 1.0.0',
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    // About dialog/screen later
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// Settings Section
// =====================================================================

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 4,
            bottom: 8,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: context.appColors.text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// Settings Tile
// =====================================================================

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      leading: Icon(
        icon,
        color: iconColor ?? context.appColors.primary,
      ),

      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: titleColor ?? context.appColors.text,
          fontWeight: FontWeight.w600,
        ),
      ),

      subtitle: subtitle == null
          ? null
          : Text(
        subtitle!,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: context.appColors.subtitle,
        ),
      ),

      trailing: trailing,

      onTap: onTap,
    );
  }
}