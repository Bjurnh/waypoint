import 'package:flutter/material.dart';
import '../utils/spacing.dart';

/// Enum for sync states
enum SyncState {
  /// Data is being synced
  syncing,

  /// Data has been synced successfully
  synced,

  /// Sync failed
  failed,
}

/// Notification bar showing sync state at the top of the screen
/// Can be dismissed by user
class SyncStatusBar extends StatefulWidget {
  /// Current sync state
  final SyncState state;

  /// Custom message to display
  final String? message;

  /// Callback when dismissed
  final VoidCallback? onDismiss;

  /// Whether the bar is visible
  final bool visible;

  /// Duration to auto-hide (null = manual dismiss only)
  final Duration? autoDismissDuration;

  /// Optional: online status (legacy compatibility)
  final bool? isOnline;

  /// Optional: syncing status (legacy compatibility)
  final bool? isSyncing;

  /// Optional: last synced time (legacy compatibility)
  final DateTime? lastSynced;

  /// Optional: sync callback (legacy compatibility)
  final VoidCallback? onSync;

  const SyncStatusBar({
    super.key,
    this.state = SyncState.syncing,
    this.message,
    this.onDismiss,
    this.visible = true,
    this.autoDismissDuration = const Duration(seconds: 3),
    this.isOnline,
    this.isSyncing,
    this.lastSynced,
    this.onSync,
  });

  @override
  State<SyncStatusBar> createState() => _SyncStatusBarState();
}

class _SyncStatusBarState extends State<SyncStatusBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    if (widget.visible) {
      _slideController.forward();
      _scheduleAutoDismiss();
    }
  }

  void _scheduleAutoDismiss() {
    if (widget.autoDismissDuration != null && widget.state == SyncState.synced) {
      Future.delayed(widget.autoDismissDuration!, () {
        if (mounted) {
          _dismiss();
        }
      });
    }
  }

  void _dismiss() {
    _slideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
        widget.onDismiss?.call();
      }
    });
  }

  @override
  void didUpdateWidget(SyncStatusBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible) {
      if (widget.visible) {
        setState(() {
          _isVisible = true;
        });
        _slideController.forward();
        _scheduleAutoDismiss();
      } else {
        _dismiss();
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    switch (widget.state) {
      case SyncState.syncing:
        return const Color(0xFF60A5FA).withOpacity(0.1);
      case SyncState.synced:
        return const Color(0xFF10B981).withOpacity(0.1);
      case SyncState.failed:
        return const Color(0xFFEF4444).withOpacity(0.1);
    }
  }

  Color get _textColor {
    switch (widget.state) {
      case SyncState.syncing:
        return const Color(0xFF1E40AF);
      case SyncState.synced:
        return const Color(0xFF065F46);
      case SyncState.failed:
        return const Color(0xFF7F1D1D);
    }
  }

  IconData get _icon {
    switch (widget.state) {
      case SyncState.syncing:
        return Icons.cloud_sync;
      case SyncState.synced:
        return Icons.cloud_done;
      case SyncState.failed:
        return Icons.cloud_off;
    }
  }

  String get _defaultMessage {
    switch (widget.state) {
      case SyncState.syncing:
        return 'Syncing data...';
      case SyncState.synced:
        return 'All changes synced';
      case SyncState.failed:
        return 'Sync failed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        color: _backgroundColor,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.md,
        ),
        child: Row(
          children: [
            // Icon with rotation animation for syncing state
            SizedBox(
              width: 24,
              height: 24,
              child: widget.state == SyncState.syncing
                  ? RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0)
                          .animate(_slideController),
                      child: Icon(
                        _icon,
                        color: _textColor,
                        size: 20,
                      ),
                    )
                  : Icon(
                      _icon,
                      color: _textColor,
                      size: 20,
                    ),
            ),
            const SizedBox(width: Spacing.md),

            // Message
            Expanded(
              child: Text(
                widget.message ?? _defaultMessage,
                style: TextStyle(
                  color: _textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Dismiss button
            if (widget.state != SyncState.syncing)
              IconButton(
                icon: Icon(Icons.close, color: _textColor, size: 18),
                onPressed: _dismiss,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
