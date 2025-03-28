import 'package:flutter/material.dart';
import 'tokens/color_tokens.dart';
import 'tokens/spacing_tokens.dart';
import 'tokens/typography_tokens.dart';
import 'themes/widget_themes.dart';
import '../themes/my_theme.dart';

/// A centralized access point for the application's design system
class DesignSystem {
  /// Get the complete light theme
  static ThemeData getLightTheme() => getMaterial3Theme();

  /// Get the complete dark theme
  static ThemeData getDarkTheme() => getMaterial3DarkTheme();

  /// Colors used throughout the application
  static ColorTokens get colors => _colors;
  static final _colors = _ColorTokensAccessor();

  /// Spacing values used throughout the application
  static SpacingTokensAccessor get spacing => _spacing;
  static final _spacing = SpacingTokensAccessor();

  /// Update a specific theme extension
  static T updateExtension<T extends ThemeExtension<T>>(
      BuildContext context, T Function(T) updater) {
    final theme = Theme.of(context);
    final extension = theme.extension<T>() as T;
    return updater(extension);
  }

  /// Apply theme updates and rebuild specific components
  static void applyComponentThemeUpdates(BuildContext context) {
    // This would be hooked up to a state management solution
    // to trigger rebuilds when theme updates occur
  }
}

/// Accessor for color tokens to improve discoverability
class _ColorTokensAccessor {
  Color get primary => ColorTokens.primaryLight;
  Color get primaryDark => ColorTokens.primaryDark;
  Color get secondary => ColorTokens.secondaryLight;
  Color get secondaryDark => ColorTokens.secondaryDark;
  Color get surface => ColorTokens.surface;
  Color get background => ColorTokens.background;
  Color get surfaceDark => ColorTokens.surfaceDark;
  Color get backgroundDark => ColorTokens.backgroundDark;
  Color get error => ColorTokens.error;
  Color get success => ColorTokens.success;
  Color get warning => ColorTokens.warning;
  Color get info => ColorTokens.info;
  Color get textPrimary => ColorTokens.textPrimary;
  Color get textSecondary => ColorTokens.textSecondary;
  Color get textPrimaryDark => ColorTokens.textPrimaryDark;
  Color get textSecondaryDark => ColorTokens.textSecondaryDark;
}

/// Accessor for spacing tokens to improve discoverability
class SpacingTokensAccessor {
  double get xs => SpacingTokens.xs;
  double get s => SpacingTokens.s;
  double get m => SpacingTokens.m;
  double get l => SpacingTokens.l;
  double get xl => SpacingTokens.xl;
  double get xxl => SpacingTokens.xxl;
  double get buttonHeight => SpacingTokens.buttonHeight;
  double get inputHeight => SpacingTokens.inputHeight;
  double get radiusS => SpacingTokens.radiusS;
  double get radiusM => SpacingTokens.radiusM;
  double get radiusL => SpacingTokens.radiusL;
}
