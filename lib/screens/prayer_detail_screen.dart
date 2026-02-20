import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_card.dart';

class PrayerDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final bool isAnswered;
  final ValueChanged<bool>? onToggleAnswered;
  final DateTime? createdAt;
  final DateTime? answeredAt;

  const PrayerDetailScreen({
    required this.title,
    required this.description,
    this.isAnswered = false,
    this.onToggleAnswered,
    this.createdAt,
    this.answeredAt,
    Key? key,
  }) : super(key: key);

  @override
  State<PrayerDetailScreen> createState() => _PrayerDetailScreenState();
}

class _PrayerDetailScreenState extends State<PrayerDetailScreen> {
  late bool _isAnswered;
  late DateTime _createdAt;
  late DateTime? _answeredAt;

  @override
  void initState() {
    super.initState();
    _isAnswered = widget.isAnswered;
    _createdAt = widget.createdAt ?? DateTime.now();
    _answeredAt = widget.answeredAt;
  }

  void _toggleAnswered() {
    setState(() {
      _isAnswered = !_isAnswered;
      if (_isAnswered && _answeredAt == null) {
        _answeredAt = DateTime.now();
      } else if (!_isAnswered) {
        _answeredAt = null;
      }
    });
    widget.onToggleAnswered?.call(_isAnswered);
  }

  @override
  Widget build(BuildContext context) {
    final createdTimeAgo = timeago.format(_createdAt);
    final answeredTimeAgo = _answeredAt != null ? timeago.format(_answeredAt!) : null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Prayer Detail'),
        leading: BackButton(onPressed: () => Navigator.maybePop(context)),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Edit'),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const Text('Share'),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const Text('Delete'),
                onTap: () => Navigator.maybePop(context),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          GradientBackground(
            child: Container(),
            startColor: Colors.pink.withOpacity(0.05),
            midColor: Colors.purple.withOpacity(0.05),
            endColor: Colors.white,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: kToolbarHeight + Spacing.lg,
              left: Spacing.lg,
              right: Spacing.lg,
              bottom: Spacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Prayer Title and Status
                GradientCard(
                  borderColor: AppColors.border.withOpacity(0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.foreground,
                              ),
                            ),
                          ),
                          SizedBox(width: Spacing.md),
                          if (_isAnswered)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Spacing.sm,
                                vertical: Spacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: 14,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Answered',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: Spacing.md),
                      Text(
                        'Created $createdTimeAgo',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Spacing.lg),

                // Prayer Content
                GradientCard(
                  borderColor: AppColors.border.withOpacity(0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prayer Request',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                      SizedBox(height: Spacing.md),
                      Container(
                        padding: EdgeInsets.all(Spacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.description.isEmpty
                              ? 'No additional details provided'
                              : widget.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: widget.description.isEmpty
                                ? AppColors.textSecondary
                                : AppColors.foreground,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Spacing.lg),

                // Answer Tracking
                GradientCard(
                  borderColor: AppColors.border.withOpacity(0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Prayer Status',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.foreground,
                                ),
                              ),
                              SizedBox(height: Spacing.xs),
                              Text(
                                _isAnswered ? 'Mark as unanswered' : 'Mark as answered',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: _isAnswered,
                            onChanged: (_) => _toggleAnswered(),
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                      if (_isAnswered && answeredTimeAgo != null) ...[
                        SizedBox(height: Spacing.md),
                        Container(
                          padding: EdgeInsets.all(Spacing.md),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 20,
                                color: Colors.green,
                              ),
                              SizedBox(width: Spacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Prayer Answered',
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      answeredTimeAgo,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: Spacing.lg),

                // Action Buttons
                FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_isAnswered ? 'Prayer marked as answered ✨' : 'Prayer unmarked'),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: Spacing.md),
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text(
                    'Save Changes',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
