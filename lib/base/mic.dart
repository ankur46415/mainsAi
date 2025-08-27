import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedMicButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isListening;
  final ThemeData theme;

  const AnimatedMicButton({
    super.key,
    required this.onTap,
    required this.isListening,
    required this.theme,
  });

  @override
  State<AnimatedMicButton> createState() => _AnimatedMicButtonState();
}

class _AnimatedMicButtonState extends State<AnimatedMicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isListening = widget.isListening;
    final theme = widget.theme;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 60,
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulse background
            if (isListening)
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.error.withOpacity(0.2),
                  ),
                ),
              ),

            // Button base
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isListening
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: (isListening
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary)
                        .withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    isListening ? Icons.mic : Icons.mic_none,
                    key: ValueKey(isListening),
                    color: theme.colorScheme.onPrimary,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
