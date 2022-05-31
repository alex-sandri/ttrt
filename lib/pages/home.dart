import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ttrt/bloc/game/bloc.dart';
import 'package:ttrt/pages/game.dart';
import 'package:ttrt/pages/settings.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TTRT'),
        actions: [
          FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final PackageInfo? packageInfo = snapshot.data;

                if (packageInfo == null) {
                  return const SizedBox();
                }

                return IconButton(
                  onPressed: () => showAboutDialog(
                    context: context,
                    applicationName: packageInfo.appName,
                    applicationVersion: packageInfo.version,
                    children: [
                      ListTile(
                        title: const Text('View on GitHub'),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () async {
                          final Uri url =
                              Uri.parse('https://github.com/alex-sandri/ttrt');

                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  tooltip: 'Info',
                  icon: const Icon(Icons.info),
                );
              }),
          IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const SettingsPage())),
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: const [
          Spacer(),
          _BottomBar(),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            context.read<GameBloc>().start();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const GamePage()),
              (_) => false,
            );
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('Play'),
        ),
      ),
    );
  }
}
