import 'package:flutter/material.dart';

class SyncStatusBar extends StatelessWidget {
  final bool isOnline;
  final bool isSyncing;
  final DateTime? lastSynced;
  final VoidCallback? onSync;

  const SyncStatusBar({this.isOnline = true, this.isSyncing = false, this.lastSynced, this.onSync, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isOnline ? Colors.green[50] : Colors.red[50],
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(isOnline ? Icons.cloud_done : Icons.cloud_off, size: 18, color: isOnline ? Colors.green : Colors.red),
              SizedBox(width: 8),
              Text(isSyncing ? 'Syncing...' : (isOnline ? 'Online' : 'Offline')),
            ],
          ),
          Row(
            children: [
              if (lastSynced != null) Text('${lastSynced!.toLocal().toString().split('.')[0]}'),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.sync),
                onPressed: onSync,
              )
            ],
          )
        ],
      ),
    );
  }
}
