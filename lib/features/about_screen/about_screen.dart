import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_money/core/constants/app_assets.dart';
import 'package:my_money/core/theme/app_color_extension.dart';
import 'package:my_money/core/widgets/custom_app_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
   String _version = '';
  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

   Future<void> _loadAppInfo() async {
     try {
       final packageInfo = await PackageInfo.fromPlatform();



       if (!mounted) return;

       setState(() {
         _version = packageInfo.version;
       });
     } catch (e) {
       debugPrint('ERROR LOADING APP VERSION = $e');
     }
   }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    debugPrint("About Screen Build");
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: CustomAppBar(title: 'about'.tr()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 12),

            // App Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: theme.colorScheme.primaryContainer,
              ),
              child: Image.asset(AppAssets.logoAbout),
            ),

            const SizedBox(height: 20),

            // App Name
            Text(
              'My Money',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.appColors.primary
              ),
            ),

            const SizedBox(height: 8),

            // Version
            Text(
              '${'version'.tr()} $_version',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 28),

            // Short Description
            Text(
              'personal_money_management_app'.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),

            const SizedBox(height: 32),

            // About Section
            _AboutSection(
              title: 'about'.tr(),
              child: Text(
                'about_my_money_description'.tr(),
                style: theme.textTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 20),

            // Licenses
            Card(
              elevation: 0,
              child: ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text('licenses'.tr()),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: 'My Money',
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // Copyright
            Text(
              '© 2026 My Money',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}



class _AboutSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _AboutSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    debugPrint("_AboutSection Build");
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}