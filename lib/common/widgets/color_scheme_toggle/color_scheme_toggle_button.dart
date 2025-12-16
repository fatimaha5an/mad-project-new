import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/theme/color_scheme_cubit.dart';

/// Reusable color scheme toggle button
/// Shows sun/moon icon and swaps colors when tapped
class ColorSchemeToggleButton extends StatelessWidget {
  final double size;
  final Color? iconColor;
  
  const ColorSchemeToggleButton({
    super.key,
    this.size = 24,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorSchemeCubit, ColorSchemeState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            context.read<ColorSchemeCubit>().toggleScheme();
          },
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              state.isDark ? Icons.light_mode : Icons.dark_mode,
              key: ValueKey(state.isDark),
              color: iconColor ?? state.primary,
              size: size,
            ),
          ),
          tooltip: state.isDark ? "Switch to Light Mode" : "Switch to Dark Mode",
        );
      },
    );
  }
}
