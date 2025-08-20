import 'package:flutter/material.dart';

import '../theme/theme.dart';

class TroskoAppBar extends StatelessWidget {
  final IconData icon;
  final Function() onPressedIcon;
  final String smallTitle;
  final String bigTitle;
  final String bigSubtitle;

  const TroskoAppBar({
    required this.icon,
    required this.onPressedIcon,
    required this.smallTitle,
    required this.bigTitle,
    required this.bigSubtitle,
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
    backgroundColor: context.colors.background,
    foregroundColor: context.colors.text,
    titleSpacing: 4,
    elevation: 0,
    scrolledUnderElevation: 0,
    expandedHeight: 160,
    leading: IconButton(
      onPressed: onPressedIcon,
      icon: Icon(
        icon,
        color: context.colors.text,
        size: 28,
      ),
    ),
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
