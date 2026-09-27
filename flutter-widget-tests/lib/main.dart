import 'package:flutter/material.dart';
import 'pages/home_page.dart';


class AppColors {
  static const lightBg               = Color(0xFFF0F1F5);
  static const lightCard             = Color(0xFFFFFFFF);
  static const lightLabel            = Color(0xFF1A1B2E);
  static const lightSecondary        = Color(0xFF5C5F7A);
  static const lightSeparator        = Color(0xFFDCDDE8);
  static const lightFill             = Color(0xFFE8E9F0);
  static const lightAccent           = Color(0xFF3D3A8C);

  static const cardLightStart        = Color(0xFF1A1B2E);
  static const cardLightEnd          = Color(0xFF252640);
  static const cardDarkStart         = Color(0xFF1A1B2E);
  static const cardDarkEnd           = Color(0xFF252640);

  static const red                   = Color(0xFFFF3B30);
  static const orange                = Color(0xFFFF9500);
  static const green                 = Color(0xFF34C759);
  static const blue                  = Color(0xFF007AFF);
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SpendyPro());
}

class SpendyPro extends StatelessWidget {
  const SpendyPro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.lightAccent,
          brightness: Brightness.light,
        ).copyWith(
          surface:                 AppColors.lightCard,
          surfaceContainerHighest: AppColors.lightFill,
          onSurface:               AppColors.lightLabel,
          onSurfaceVariant:        AppColors.lightSecondary,
          outline:                 AppColors.lightSeparator,
          outlineVariant:          AppColors.lightSeparator,
          primary:                 AppColors.lightAccent,
          onPrimary:               Colors.white,
        ),
        dividerColor: AppColors.lightSeparator,
        cardColor: AppColors.lightCard,
      ),
      home: const HomePage(),
    );
  }
}
