import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_app/modules/transactions/transactions_controller.dart';
import 'package:money_app/router.dart';

const kPrimaryAccent = Color(0xffc0028b);
const kAppBarTitle = 'MoneyApp';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mainTextTheme = GoogleFonts.montserratTextTheme();
    final mainTextStyle =
        GoogleFonts.montserratTextTheme().bodyMedium ?? const TextStyle();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '$kAppBarTitle (By Iaido)',
      initialRoute: PageRoutes.transactions,
      getPages: getAppPageRoutes(),
      initialBinding: TransactionsBinding(),
      theme: ThemeData(
        useMaterial3: true,
        textTheme: mainTextTheme,
        cardColor: Colors.white,
        cardTheme: const CardTheme(surfaceTintColor: Colors.white),
        appBarTheme: AppBarTheme(
            color: kPrimaryAccent,
            centerTitle: true,
            titleTextStyle: mainTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        scaffoldBackgroundColor: const Color(0xfff7f7f7),
        colorScheme: const ColorScheme.light().copyWith(
            primary: Colors.black,
            secondary: kPrimaryAccent,
            onSecondary: Colors.white),
      ),
    );
  }
}
