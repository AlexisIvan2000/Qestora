import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_end/screen/home.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color.fromARGB(248, 59, 3, 244), 
  surface: const Color.fromARGB(255, 250, 250, 250),  
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.surface,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.latoTextTheme().copyWith(
    titleSmall: GoogleFonts.lato(fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.lato(fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.lato(fontWeight: FontWeight.bold),
  ),
);
void main() async{
 WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: theme,
      home: Scaffold(
        body: HomeScreen()
      ),
    );
  }
}
