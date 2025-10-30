import 'dart:async';

import 'package:flutter/material.dart';

import '../util/notification.dart';

class NotificationActionListener extends StatefulWidget {
  final Widget child;

  const NotificationActionListener({
    required this.child,
  });

  @override
  State<NotificationActionListener> createState() => _NotificationActionListenerState();
}

class _NotificationActionListenerState extends State<NotificationActionListener> {
  StreamSubscription<void>? subscription;

  @override
  void initState() {
    super.initState();

    subscription = addExpenseStream.listen(
      (_) => WidgetsBinding.instance.addPostFrameCallback(
        (_) => openAddExpenseFromNotification(),
      ),
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
