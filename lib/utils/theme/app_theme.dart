import 'package:demo25/utils/misc.dart';
import 'package:demo25/utils/theme/text_theme.dart';
import 'package:flutter/material.dart';

class FCTheme {
  FCTheme._();

  static const int primaryColor = 0xff17154c;
  static const int secondaryColor = 0xff93d500;
  static const int errorColor = 0xff78251b;
  static const int surfaceColor = 0xfff8f9fa;
  static const int onSurfaceVariant = 0xff6c757d;
  static const int outline = 0xffdee2e6;
  static const int shadow = 0x1f000000;
  static const int successColor = 0xff28a745;
  static const int warningColor = 0xffffc107;
  static const int infoColor = 0xff17a2b8;

  static ThemeData light(BuildContext context) {
    final textTheme = FCTextTheme.getLightTheme(context);
    final scaleFactor = Misc.getScaleFactor(context);

    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(primaryColor),
      scaffoldBackgroundColor: Colors.white,

      // Text theme
      textTheme: textTheme,

      colorScheme: const ColorScheme(
        primary: Color(primaryColor),
        secondary: Color(secondaryColor),
        surface: Colors.white,
        surfaceContainerHighest: Color(surfaceColor),
        error: Color(errorColor),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onSurfaceVariant: Color(onSurfaceVariant),
        onError: Colors.white,
        outline: Color(outline),
        shadow: Color(shadow),
        brightness: Brightness.light,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: const Color(primaryColor),
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: const Color(primaryColor),
          fontWeight: FontWeight.w600,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(primaryColor),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(
            primaryColor,
          ).withValues(alpha: 0.4),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: const Color(shadow),
          textStyle: FCTextTheme.getButtonTextStyle(
            context,
          ).copyWith(color: Colors.white),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(primaryColor),
          side: const BorderSide(color: Color(primaryColor), width: 1.5),
          disabledForegroundColor: const Color(
            primaryColor,
          ).withValues(alpha: 0.4),
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: FCTextTheme.getButtonTextStyle(
            context,
          ).copyWith(color: const Color(primaryColor)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(primaryColor),
          textStyle: FCTextTheme.getButtonTextStyle(
            context,
          ).copyWith(color: const Color(primaryColor)),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(surfaceColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(outline)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(outline)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(primaryColor), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(errorColor)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(errorColor), width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(outline).withValues(alpha: 0.5),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: const Color(onSurfaceVariant),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: const Color(onSurfaceVariant),
        ),
        errorStyle: FCTextTheme.getErrorTextStyle(context),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shadowColor: Color(shadow),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(color: Color(outline), thickness: 1),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: const Color(primaryColor),
        ),
        unselectedLabelStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: const Color(onSurfaceVariant),
        ),
        dividerColor: Colors.white,
        tabAlignment: TabAlignment.start,
        indicatorColor: Colors.white,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Data Table Theme
      dataTableTheme: DataTableThemeData(
        dataTextStyle: textTheme.bodyMedium,
        headingTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        backgroundColor: const Color(primaryColor),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        size: 24 * scaleFactor,
        color: const Color(primaryColor),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: const Color(onSurfaceVariant),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: Colors.white,
        ),
        backgroundColor: const Color(surfaceColor),
        selectedColor: const Color(primaryColor),
        disabledColor: const Color(outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Dropdown Menu Theme
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: textTheme.bodyMedium,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(surfaceColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(outline)),
          ),
        ),
      ),
    );
  }
}
