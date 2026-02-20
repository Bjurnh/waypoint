import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../widgets/gradient_background.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      NotificationItem(
        id: '1',
        title: 'Prayer Answered!',
        description: 'Your prayer for guidance has been answered',
        type: NotificationType.prayer,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        title: '7-Day Streak!',
        description: 'Amazing! You\'ve completed 7 days of Bible reading',
        type: NotificationType.achievement,
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        isRead: false,
      ),
      NotificationItem(
        id: '3',
        title: 'Habit Reminder',
        description: 'Don\'t forget your daily morning habit',
        type: NotificationType.reminder,
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        isRead: true,
      ),
      NotificationItem(
        id: '4',
        title: 'Bible Plan Updated',
        description: 'Your reading plan for today is ready',
        type: NotificationType.planUpdate,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ];
  }

  void _markAsRead(int index) {
    setState(() {
      _notifications[index].isRead = true;
    });
  }

  void _deleteNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Notification dismissed')),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: BackButton(onPressed: () => Navigator.maybePop(context)),
      ),
      body: Stack(
        children: [
          GradientBackground(
            child: Container(),
            startColor: Colors.pink.withOpacity(0.05),
            midColor: Colors.purple.withOpacity(0.05),
            endColor: Colors.white,
          ),
          _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_rounded,
                        size: 64,
                        color: AppColors.border.withOpacity(0.5),
                      ),
                      SizedBox(height: Spacing.lg),
                      Text(
                        'No Notifications',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.only(
                    top: kToolbarHeight + Spacing.lg,
                    left: Spacing.lg,
                    right: Spacing.lg,
                    bottom: Spacing.lg,
                  ),
                  itemCount: _notifications.length,
                  separatorBuilder: (_, __) => SizedBox(height: Spacing.md),
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return _NotificationCard(
                      notification: notification,
                      onMarkAsRead: () => _markAsRead(index),
                      onDelete: () => _deleteNotification(index),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

enum NotificationType {
  prayer,
  achievement,
  reminder,
  planUpdate,
}

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notification,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  IconData _getIcon() {
    switch (notification.type) {
      case NotificationType.prayer:
        return Icons.favorite_rounded;
      case NotificationType.achievement:
        return Icons.emoji_events_rounded;
      case NotificationType.reminder:
        return Icons.schedule_rounded;
      case NotificationType.planUpdate:
        return Icons.auto_stories_rounded;
    }
  }

  Color _getColor() {
    switch (notification.type) {
      case NotificationType.prayer:
        return Colors.pink;
      case NotificationType.achievement:
        return Colors.amber;
      case NotificationType.reminder:
        return Colors.purple;
      case NotificationType.planUpdate:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final timeAgo = timeago.format(notification.timestamp);

    return GestureDetector(
      onTap: notification.isRead ? null : onMarkAsRead,
      child: Container(
        decoration: BoxDecoration(
          color: notification.isRead ? AppColors.card : color.withOpacity(0.05),
          border: Border.all(
            color: notification.isRead
                ? AppColors.border.withOpacity(0.2)
                : color.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(Spacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color,
                      color.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIcon(),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: Spacing.md),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: Spacing.xs),
                    Text(
                      notification.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Spacing.sm),
                    Text(
                      timeAgo,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Spacing.md),
              // Actions
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: onMarkAsRead,
                    child: const Text('Mark as read'),
                  ),
                  PopupMenuItem(
                    onTap: onDelete,
                    child: const Text('Dismiss'),
                  ),
                ],
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
