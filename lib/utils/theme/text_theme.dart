import 'package:demo25/utils/misc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FCTextTheme {
  FCTextTheme._();

  static TextTheme getLightTheme(BuildContext context) {
    final adjustedScaleFactor = Misc.getScaleFactor(context);

    const defaultTextColor = Colors.black;
    const secondaryTextColor = Color(0xff6c757d);

    return GoogleFonts.latoTextTheme().copyWith(
      displayLarge: GoogleFonts.lato(
        fontSize: 32 * adjustedScaleFactor,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        color: defaultTextColor,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.lato(
        fontSize: 28 * adjustedScaleFactor,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        color: defaultTextColor,
        height: 1.2,
        letterSpacing: -0.25,
      ),
      displaySmall: GoogleFonts.lato(
        fontSize: 24 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        color: defaultTextColor,
        height: 1.3,
      ),

      // Headline styles - for section headers
      headlineLarge: GoogleFonts.lato(
        fontSize: 22 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        color: defaultTextColor,
        height: 1.3,
      ),
      headlineMedium: GoogleFonts.lato(
        fontSize: 18 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        color: defaultTextColor,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.lato(
        fontSize: 16 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        color: defaultTextColor,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),

      // Title styles - for component titles
      titleLarge: GoogleFonts.lato(
        fontSize: 20 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        color: defaultTextColor,
        height: 1.3,
      ),
      titleMedium: GoogleFonts.lato(
        fontSize: 16 * adjustedScaleFactor,
        fontWeight: FontWeight.w500,
        color: defaultTextColor,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.lato(
        fontSize: 14 * adjustedScaleFactor,
        fontWeight: FontWeight.w500,
        color: defaultTextColor,
        height: 1.4,
      ),

      // Body styles - for main content
      bodyLarge: GoogleFonts.lato(
        fontSize: 16 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        color: defaultTextColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.lato(
        fontSize: 14 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        color: defaultTextColor,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.lato(
        fontSize: 12 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        height: 1.5,
      ),

      // Label styles - for UI elements
      labelLarge: GoogleFonts.lato(
        fontSize: 14 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: defaultTextColor,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.lato(
        fontSize: 12 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: defaultTextColor,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.lato(
        fontSize: 11 * adjustedScaleFactor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        height: 1.4,
      ),
    );
  }

  // Utility methods for special text styles
  static TextStyle getErrorTextStyle(BuildContext context) {
    final adjustedScaleFactor = Misc.getScaleFactor(context);
    return GoogleFonts.lato(
      fontSize: 12 * adjustedScaleFactor,
      fontWeight: FontWeight.w500,
      color: const Color(0xff78251b),
      height: 1.4,
    );
  }

  static TextStyle getSuccessTextStyle(BuildContext context) {
    final adjustedScaleFactor = Misc.getScaleFactor(context);
    return GoogleFonts.lato(
      fontSize: 12 * adjustedScaleFactor,
      fontWeight: FontWeight.w500,
      color: const Color(0xff28a745),
      height: 1.4,
    );
  }

  static TextStyle getWarningTextStyle(BuildContext context) {
    final adjustedScaleFactor = Misc.getScaleFactor(context);
    return GoogleFonts.lato(
      fontSize: 12 * adjustedScaleFactor,
      fontWeight: FontWeight.w500,
      color: const Color(0xffffc107),
      height: 1.4,
    );
  }

  static TextStyle getInfoTextStyle(BuildContext context) {
    final adjustedScaleFactor = Misc.getScaleFactor(context);
    return GoogleFonts.lato(
      fontSize: 12 * adjustedScaleFactor,
      fontWeight: FontWeight.w500,
      color: const Color(0xff17a2b8),
      height: 1.4,
    );
  }

  static TextStyle getButtonTextStyle(BuildContext context) {
    final adjustedScaleFactor = Misc.getScaleFactor(context);
    return GoogleFonts.lato(
      fontSize: 14 * adjustedScaleFactor,
      fontWeight: FontWeight.w600,
      height: 1.4,
    );
  }

  static TextStyle getCaptionTextStyle(BuildContext context) {
    final adjustedScaleFactor = Misc.getScaleFactor(context);
    return GoogleFonts.lato(
      fontSize: 10 * adjustedScaleFactor,
      fontWeight: FontWeight.w400,
      color: const Color(0xff6c757d),
      height: 1.4,
    );
  }
}
