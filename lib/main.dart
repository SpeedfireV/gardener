import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gardener/bloc/plantsHandbookPage/firestore_bloc.dart';
import 'package:gardener/bloc/plantsHandbookPage/search_bloc.dart';
import 'package:gardener/constants/colors.dart';
import 'package:gardener/home_page.dart';
import 'package:gardener/models/plant_data.dart';
import 'package:gardener/services/firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirestoreService().getPlants();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FirestoreBloc(FirestoreService())),
        BlocProvider(
            create: (context) =>
                SearchBloc("", PlantType.all, [], SortingDirection.ascending))
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: ColorPalette.backgroundColor,
          radioTheme: RadioThemeData(
              fillColor: WidgetStateProperty.all(ColorPalette.primaryColor)),
          progressIndicatorTheme:
              ProgressIndicatorThemeData(color: ColorPalette.primaryColor),
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: ColorPalette.primaryColor),
          inputDecorationTheme: InputDecorationTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: GoogleFonts.merriweather().fontFamily),
      home: const HomePage(),
    );
  }
}
