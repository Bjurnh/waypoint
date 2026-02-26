import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../utils/animation_curves.dart';

/// Wrapper for fl_chart components providing consistent card styling, labels, and animations
/// 
/// Usage:
/// ```dart
/// ChartCard(
///   title: 'Weekly Progress',
///   subtitle: 'Last 7 days',
///   child: LineChart(data),
/// )
/// ```
class ChartCard extends StatefulWidget {
  /// Title displayed above the chart
  final String title;

  /// Optional subtitle for additional context
  final String? subtitle;

  /// The chart widget to display (LineChart, BarChart, PieChart, etc.)
  final Widget child;

  /// Optional custom height for the chart container
  final double? height;

  /// Whether to show a loading animation while chart is rendering
  final bool isLoading;

  /// Optional callback when card is tapped
  final VoidCallback? onTap;

  /// Custom background color (defaults to card color)
  final Color? backgroundColor;

  /// Border color with transparency
  final Color? borderColor;

  /// Whether to show shadows beneath the card
  final bool showShadow;

  /// Animation scale on tap (press effect)
  final bool enableTapAnimation;

  const ChartCard({
    required this.title,
    required this.child,
    this.subtitle,
    this.height,
    this.isLoading = false,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.showShadow = true,
    this.enableTapAnimation = true,
    Key? key,
  }) : super(key: key);

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      duration: AppAnimationCurves.durationQuick,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _handleTapDown(_) {
    if (widget.enableTapAnimation) {
      _tapController.forward();
    }
  }

  void _handleTapUp(_) {
    if (widget.enableTapAnimation) {
      _tapController.reverse();
    }
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    if (widget.enableTapAnimation) {
      _tapController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.card,
            border: Border.all(
              color: widget.borderColor ?? AppColors.border.withValues(alpha:0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: widget.showShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(Spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with title and subtitle
                    Padding(
                      padding: EdgeInsets.only(bottom: Spacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground,
                            ),
                          ),
                          if (widget.subtitle != null) ...[
                            SizedBox(height: Spacing.xs),
                            Text(
                              widget.subtitle!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Chart container with loading state
                    Expanded(
                      child: Stack(
                        children: [
                          // Chart
                          if (!widget.isLoading)
                            AnimatedOpacity(
                              opacity: widget.isLoading ? 0.0 : 1.0,
                              duration: AppAnimationCurves.durationMedium,
                              child: widget.child,
                            ),
                          // Loading skeleton
                          if (widget.isLoading)
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.inputBackground,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      AppColors.primary.withValues(alpha:0.6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Variant: ChartCard with action button in header
class ChartCardWithAction extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final String actionLabel;
  final VoidCallback? onAction;
  final double? height;
  final bool showShadow;

  const ChartCardWithAction({
    required this.title,
    required this.child,
    required this.actionLabel,
    this.subtitle,
    this.onAction,
    this.height,
    this.showShadow = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(
          color: AppColors.border.withValues(alpha:0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and action button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: Spacing.xs),
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: Spacing.md),
                FilledButton(
                  onPressed: onAction,
                  child: Text(actionLabel),
                ),
              ],
            ),
            SizedBox(height: Spacing.md),
            // Chart
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
