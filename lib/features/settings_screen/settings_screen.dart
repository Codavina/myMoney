import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/widgets/custom_app_bar.dart';
import 'package:my_money/features/about_screen/about_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_color_extension.dart';
import '../../core/theme/theme_cubit.dart';
import '../../core/utils/app_confirm_signout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("Settings Screen Build");
    final email = Supabase.instance.client.auth.currentUser?.email ?? '';
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: CustomAppBar(title: 'settings'.tr()),

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
                  title: 'theme'.tr(),
                  children: [
                    _SettingsTile(
                      icon: Icons.palette_outlined,
                      title: 'theme'.tr(),
                      subtitle: isDark ? 'dark'.tr() : 'light'.tr(),
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
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            // =========================================================
            // Language
            // =========================================================
            _SettingsSection(
              title: 'language'.tr(),
              children: [
                _SettingsTile(
                  icon: Icons.language_outlined,
                  title: 'language'.tr(),
                  subtitle: context.locale.languageCode == 'fr'
                      ? 'french'.tr()
                      : 'english'.tr(),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLanguageDialog(context),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =========================================================
            // Account
            // =========================================================
            _SettingsSection(
              title: 'account'.tr(),
              children: [
                _SettingsTile(
                  icon: Icons.person_outline,
                  title: 'account'.tr(),
                  subtitle: email,
                  onTap: null,
                ),

                Divider(height: 1, color: context.appColors.border),

                _SettingsTile(
                  icon: Icons.logout_outlined,
                  title: 'sign_out'.tr(),
                  titleColor: context.appColors.error,
                  iconColor: context.appColors.error,
                  onTap: () async{
                    await confirmSignOut(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =========================================================
            // About
            // =========================================================
            _SettingsSection(
              title: 'about'.tr(),
              children: [
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: 'about My Money'.tr(),
                  subtitle: 'Version 1.0.0',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutAppScreen()),
                    );
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
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
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
          child: Column(children: children),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      leading: Icon(icon, color: iconColor ?? context.appColors.primary),

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

Future<void> _showLanguageDialog(BuildContext context) async {
  final currentLocale = context.locale;

  final selectedLocale = await showDialog<Locale>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('select_language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioGroup<Locale>(
              groupValue: currentLocale,
              onChanged: (locale) {
                if (locale != null) {
                  Navigator.pop(context, locale);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<Locale>(
                    value: const Locale('fr'),
                    title: Text('french'.tr()),
                  ),

                  RadioListTile<Locale>(
                    value: const Locale('en'),
                    title: Text('english'.tr()),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );

  if (!context.mounted || selectedLocale == null) {
    return;
  }

  await context.setLocale(selectedLocale);
}
