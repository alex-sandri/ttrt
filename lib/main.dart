import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttrt/app.dart';
import 'package:ttrt/bloc/player/state.dart';

void main() async {
  GoogleFonts.config.allowRuntimeFetching = false;

  LicenseRegistry.addLicense(() async* {
    final String license =
        await rootBundle.loadString('assets/fonts/Montserrat-OFL.txt');

    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final PlayerState playerState = await PlayerState.restore();

  runApp(App(playerState: playerState));
}
