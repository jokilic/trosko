import 'package:flutter/material.dart';

import '../theme/theme.dart';

class TroskoAppBar extends StatelessWidget {
  final Widget? leadingWidget;
  final List<Widget>? actionWidgets;
  final String smallTitle;
  final String bigTitle;
  final String bigSubtitle;

  const TroskoAppBar({
    required this.smallTitle,
    required this.bigTitle,
    required this.bigSubtitle,
    this.leadingWidget,
    this.actionWidgets,
  });

  @override
  Widget build(BuildContext context) => SliverAppBar.large(
    centerTitle: false,
    title: Text(
      smallTitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.textStyles.appBarTitleSmall,
    ),
    backgroundColor: context.colors.scaffoldBackground,
    foregroundColor: context.colors.buttonPrimary,
    titleSpacing: leadingWidget != null ? 4 : 16,
    elevation: 0,
    scrolledUnderElevation: 0,
    expandedHeight: 160,
    leading: leadingWidget,
    actions: actionWidgets,
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: false,
      titlePadding: const EdgeInsets.all(16),
      title: FadingFlexibleTitle(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bigTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.appBarTitleBig,
            ),
            const SizedBox(height: 2),
            Text(
              bigSubtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.appBarSubtitleBig,
            ),
          ],
        ),
      ),
    ),
  );
}

class FadingFlexibleTitle extends StatelessWidget {
  final Widget child;

  const FadingFlexibleTitle({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();

    if (settings == null) {
      return child;
    }

    final delta = settings.maxExtent - settings.minExtent;
    final t = ((settings.currentExtent - settings.minExtent) / delta).clamp(0.0, 1.0);
    final opacity = Curves.easeOut.transform(t);

    /// Slight slide-up as it fades
    final dy = Tween<double>(begin: 8, end: 0).transform(t);

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, dy),
        child: child,
      ),
    );
  }
}
