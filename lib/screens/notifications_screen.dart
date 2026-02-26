import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../widgets/gradient_background.dart';
import '../state/app_state.dart';

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

  Future<void> _showReminderDialog(BuildContext context, [Reminder? existing]) async {
    final isNew = existing == null;
    String title = existing?.title ?? '';
    TimeOfDay time = existing?.time ?? TimeOfDay(hour: 8, minute: 0);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isNew ? 'New Reminder' : 'Edit Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: TextEditingController(text: title),
                onChanged: (v) => title = v,
              ),
              const SizedBox(height: Spacing.md),
              Row(
                children: [
                  const Text('Time:'),
                  const SizedBox(width: Spacing.sm),
                  TextButton(
                    child: Text(time.format(context)),
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: time,
                      );
                      if (picked != null) {
                        setState(() {
                          time = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  if (title.trim().isEmpty) return;
                  final app = Provider.of<AppState>(context, listen: false);
                  if (isNew) {
                    final id = DateTime.now().millisecondsSinceEpoch.toString();
                    app.addReminder(Reminder(id: id, title: title, time: time, enabled: true));
                  } else {
                    final r = existing;
                    r.title = title;
                    r.time = time;
                    app.updateReminder(r);
                  }
                  Navigator.pop(context);
                },
                child: Text(isNew ? 'Create' : 'Save')),
          ],
        );
      },
    );
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
            startColor: Colors.pink.withValues(alpha:0.05),
            midColor: Colors.purple.withValues(alpha:0.05),
            endColor: Colors.white,
          ),
          Consumer<AppState>(
            builder: (context, app, _) {
              final reminders = app.reminders;
              return ListView(
                padding: EdgeInsets.only(
                  top: kToolbarHeight + Spacing.lg,
                  left: Spacing.lg,
                  right: Spacing.lg,
                  bottom: Spacing.lg,
                ),
                children: [
                  // Reminders header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Your Reminders',
                          style: Theme.of(context).textTheme.titleLarge),
                      TextButton.icon(
                        onPressed: () => _showReminderDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                  ...reminders.map((r) {
                    return ListTile(
                      title: Text(r.title),
                      subtitle: Text(r.time.format(context)),
                      trailing: Switch(
                        value: r.enabled,
                        onChanged: (v) {
                          setState(() {
                            r.enabled = v;
                          });
                          app.updateReminder(r);
                        },
                      ),
                      onTap: () => _showReminderDialog(context, r),
                    );
                  }).toList(),
                  const Divider(),
                  // existing notifications
                  if (_notifications.isEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_rounded,
                            size: 64,
                            color: AppColors.border.withValues(alpha:0.5),
                          ),
                          SizedBox(height: Spacing.lg),
                          Text(
                            'No Notifications',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...List.generate(_notifications.length, (index) {
                      final notification = _notifications[index];
                      return Column(
                        children: [
                          _NotificationCard(
                            notification: notification,
                            onMarkAsRead: () => _markAsRead(index),
                            onDelete: () => _deleteNotification(index),
                          ),
                          SizedBox(height: Spacing.md),
                        ],
                      );
                    }),
                ],
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
          color: notification.isRead ? AppColors.card : color.withValues(alpha:0.05),
          border: Border.all(
            color: notification.isRead
                ? AppColors.border.withValues(alpha:0.2)
                : color.withValues(alpha:0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
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
                      color.withValues(alpha:0.7),
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
