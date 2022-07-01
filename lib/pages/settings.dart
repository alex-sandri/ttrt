import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final PackageInfo? packageInfo = snapshot.data;

              if (packageInfo == null) {
                return const SizedBox();
              }

              return ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Open source licenses'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: packageInfo.appName,
                  applicationVersion: packageInfo.version,
                  applicationIcon: const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      foregroundImage: AssetImage(
                        'assets/images/flutter_launcher_icons/icon.png',
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('View on GitHub'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () async {
              final Uri url = Uri.parse('https://github.com/alex-sandri/ttrt');

              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final PackageInfo? packageInfo = snapshot.data;

              if (packageInfo == null) {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  '${snapshot.data!.appName} ${snapshot.data!.version}',
                  style: Theme.of(context).textTheme.caption,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
