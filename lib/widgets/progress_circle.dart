import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';

/// Enhanced circular progress indicator with percentage display and animation
/// Matches React styling with smooth animation on load
class ProgressCircle extends StatefulWidget {
  /// Progress value from 0.0 to 1.0
  final double value;

  /// Size of the circle (width/height in pixels)
  final double size;

  /// Stroke width of the progress indicator
  final double strokeWidth;

  /// Label text (e.g., 'Weekly Progress')
  final String? label;

  /// Background color of the progress indicator
  final Color backgroundColor;

  /// Progress color
  final Color progressColor;

  /// Whether to animate on load
  final bool animate;

  /// Animation duration
  final Duration animationDuration;

  const ProgressCircle({
    required this.value,
    this.size = 140,
    this.strokeWidth = 8,
    this.label,
    this.backgroundColor = const Color(0xFFE5E7EB),
    this.progressColor = AppColors.primary,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 1500),
    Key? key,
  }) : super(key: key);

  @override
  State<ProgressCircle> createState() => _ProgressCircleState();
}

class _ProgressCircleState extends State<ProgressCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.animate) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(ProgressCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(begin: oldWidget.value, end: widget.value)
          .animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ));
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final percent = (_animation.value * 100).toInt();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: widget.strokeWidth,
                    backgroundColor: widget.backgroundColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.backgroundColor,
                    ),
                  ),

                  // Progress circle
                  CircularProgressIndicator(
                    value: _animation.value,
                    strokeWidth: widget.strokeWidth,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.progressColor,
                    ),
                  ),

                  // Center content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$percent%',
                        style: TextStyle(
                          fontSize: widget.size * 0.28,
                          fontWeight: FontWeight.w700,
                          color: widget.progressColor,
                        ),
                      ),
                      if (widget.label != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.label!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (widget.label != null && widget.label!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: Spacing.md),
                child: Text(
                  '${(_animation.value * 100).toStringAsFixed(1)}% Complete',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        );
      },
    );
  }
}
