import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gardener/bloc/complementary_planting_page/plants_list_bloc.dart';
import 'package:gardener/bloc/home_page/in_season_cubit.dart';
import 'package:gardener/bloc/plants_handbook_page/scroll_cubit.dart';
import 'package:gardener/bloc/search_for_companions/potential_companions_bloc.dart';
import 'package:gardener/constants/colors.dart';
import 'package:gardener/home_page.dart';
import 'package:gardener/services/firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/plants_handbook_page/firestore_bloc.dart';
import 'bloc/plants_handbook_page/search_bloc.dart';
import 'constants/enums.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FirestoreBloc(FirestoreService())),
        BlocProvider(create: (context) => SearchBloc()),
        BlocProvider(
          create: (context) => PlantsListBloc(
              "", PlantType.all, [], SortingDirection.ascending, []),
        ),
        BlocProvider(create: (context) => PotentialCompanionsBloc()),
        BlocProvider(create: (context) => InSeasonCubit()),
        BlocProvider(create: (context) => ScrollCubit())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: ColorPalette.backgroundColor,
          radioTheme: RadioThemeData(
              fillColor: WidgetStateProperty.all(ColorPalette.primaryColor)),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
              color: ColorPalette.primaryColor),
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: ColorPalette.primaryColor),
          inputDecorationTheme: const InputDecorationTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: GoogleFonts.merriweather().fontFamily),
      home: const HomePage(),
    );
  }
}
