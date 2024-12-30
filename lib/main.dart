
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:literate_app/go_route_config.dart';
import 'package:literate_app/presentations/theme_cubit/theme_cubit.dart';
import 'package:literate_app/veriables/global_veraibles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // easy_localization başlatılıyor

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'), // İngilizce
        Locale('tr'), // Türkçe
      ],
      path: 'assets/translations', // JSON dosyalarının yolu
      fallbackLocale: const Locale('en'), // Varsayılan dil
      child: BlocProvider(
        create: (_) => ThemeCubit(), // ThemeCubit burada tanımlanıyor
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    setScreenSize(context);
    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'Dictionary',
      debugShowCheckedModeBanner: false,
      theme: context.watch<ThemeCubit>().state, // ThemeCubit kullanımı
      locale: context.locale, // Dil ayarı
      supportedLocales: context.supportedLocales, // Desteklenen diller
      localizationsDelegates: context.localizationDelegates, // Çeviri delegeleri
    );
  }
}
