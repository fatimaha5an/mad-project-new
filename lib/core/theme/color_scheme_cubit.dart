import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Manages the app's color scheme (Dark Mode vs Light Mode)
/// Dark Mode: Gamboge (#EE9B00) as accent, dark backgrounds
/// Light Mode: Blue (#0093AF) as accent, light backgrounds
class ColorSchemeCubit extends HydratedCubit<ColorSchemeState> {
  ColorSchemeCubit() : super(ColorSchemeState.dark());

  void toggleScheme() {
    if (state.isDark) {
      emit(ColorSchemeState.light());
    } else {
      emit(ColorSchemeState.dark());
    }
  }

  void setDark() => emit(ColorSchemeState.dark());
  void setLight() => emit(ColorSchemeState.light());

  @override
  ColorSchemeState? fromJson(Map<String, dynamic> json) {
    return ColorSchemeState(
      isDark: json['isDark'] as bool? ?? true,
    );
  }

  @override
  Map<String, dynamic>? toJson(ColorSchemeState state) {
    return {'isDark': state.isDark};
  }
}

/// State that holds the current color scheme
class ColorSchemeState {
  final bool isDark;
  
  // Dark Mode Colors
  static const voidBlack = Color(0xFF001219);
  static const richBlack = Color(0xFF010B13);
  static const backgroundDark = Color(0xFF181111);
  static const midnightGreen = Color(0xFF005F73);
  static const darkTeal = Color(0xFF004953);
  static const gamboge = Color(0xFFEE9B00); // Gold accent
  static const champagnePink = Color(0xFFE9D8A6);
  static const cambridgeBlue = Color(0xFF94D2BD);
  static const blueMunsell = Color(0xFF0A9396);
  static const auburnRed = Color(0xFFA52A2A);
  static const rubyRed = Color(0xFF9B2226);
  
  // Light Mode Colors (swapped)
  static const snowWhite = Color(0xFFFDFCFA);
  static const lightCream = Color(0xFFF5EFE6);
  static const softGray = Color(0xFFE7DED8);
  static const paleBlue = Color(0xFFB8D8E8);
  static const lightTeal = Color(0xFFCFE5E8);
  static const azureBlue = Color(0xFF0093AF); // Complementary to Gamboge
  static const darkGray = Color(0xFF2C1810);
  static const mediumGray = Color(0xFF6B5D52);
  static const darkBlue = Color(0xFF003B4D);
  static const coral = Color(0xFFE57373);
  static const rose = Color(0xFFD77B84);

  ColorSchemeState({required this.isDark});
  
  factory ColorSchemeState.dark() => ColorSchemeState(isDark: true);
  factory ColorSchemeState.light() => ColorSchemeState(isDark: false);

  // Dynamic color getters
  Color get background => isDark ? voidBlack : snowWhite;
  Color get backgroundAlt => isDark ? richBlack : lightCream;
  Color get backgroundCard => isDark ? backgroundDark : softGray;
  Color get surface => isDark ? midnightGreen : paleBlue;
  Color get surfaceDark => isDark ? darkTeal : lightTeal;
  
  // Primary accent - swaps between Gamboge and Azure Blue
  Color get primary => isDark ? gamboge : azureBlue;
  Color get primaryVariant => isDark ? Color(0xFFC46210) : Color(0xFF006D85);
  
  // Text colors
  Color get textPrimary => isDark ? champagnePink : darkGray;
  Color get textSecondary => isDark ? cambridgeBlue : mediumGray;
  Color get textAccent => isDark ? blueMunsell : darkBlue;
  
  // Semantic colors
  Color get error => isDark ? rubyRed : coral;
  Color get errorAlt => isDark ? auburnRed : rose;
  
  // UI elements
  Color get iconActive => primary;
  Color get iconInactive => isDark ? cambridgeBlue.withOpacity(0.5) : mediumGray.withOpacity(0.5);
  Color get divider => isDark ? midnightGreen.withOpacity(0.3) : mediumGray.withOpacity(0.2);
  Color get shadow => isDark ? Colors.black : Colors.black26;
}

/// Extension to use in widgets
extension ColorSchemeExtension on BuildContext {
  ColorSchemeState get colors {
    return BlocProvider.of<ColorSchemeCubit>(this).state;
  }
  
  bool get isDarkMode {
    return BlocProvider.of<ColorSchemeCubit>(this).state.isDark;
  }
}
