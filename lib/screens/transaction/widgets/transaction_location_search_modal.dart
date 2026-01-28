import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../../../models/location/location.dart';
import '../../../theme/extensions.dart';
import '../../../util/icons.dart';
import '../../../util/search.dart';
import '../../../widgets/trosko_text_field.dart';
import 'transaction_location.dart';

class TransactionLocationSearchModal extends StatefulWidget {
  final List<Location> locations;
  final Style? mapState;
  final bool useColorfulIcons;
  final bool useVectorMaps;

  const TransactionLocationSearchModal({
    required this.locations,
    required this.mapState,
    required this.useColorfulIcons,
    required this.useVectorMaps,
    required super.key,
  });

  @override
  State<TransactionLocationSearchModal> createState() => _TransactionLocationSearchModalState();
}

class _TransactionLocationSearchModalState extends State<TransactionLocationSearchModal> {
  late final textEditingController = TextEditingController();
  late final FocusNode searchFocusNode = FocusNode();
  late var currentLocations = widget.locations;

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(updateState);

    /// Delay focus to after the sheet & maps are laid out so they don't steal it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void updateState() {
    /// Get `query`
    final searchText = textEditingController.text.trim();

    /// Search all `locations`
    final items = searchLocations(
      items: widget.locations,
      query: searchText,
    );

    /// Sort `locations`
    final sortedItems = items
      ..sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );

    /// Update `state`
    setState(
      () => currentLocations = sortedItems,
    );
  }

  /// Searches `locations` using passed `query`
  List<Location> searchLocations({
    required List<Location> items,
    required String query,
    // Higher to be stricter, lower to be fuzzier
    int threshold = 80,
  }) {
    final q = query.trim();
    if (q.isEmpty) {
      return items;
    }

    /// Short queries: only literal contains to avoid noise
    if (q.length <= 3) {
      final nq = normalizeString(q);

      return items
          .where(
            (l) =>
                normalizeString(l.name).contains(nq) ||
                (l.address != null && normalizeString(l.address!).contains(nq)) ||
                (l.note != null && normalizeString(l.note!).contains(nq)),
          )
          .toList();
    }

    final scored = <({Location l, int score})>[];

    for (final l in items) {
      final fields = [
        l.name,
        if ((l.address ?? '').isNotEmpty) l.address!,
        if ((l.note ?? '').isNotEmpty) l.note!,
      ];

      /// Require trigram overlap with at least one field unless literal contains
      final passesGuard = fields.any((f) {
        final nf = normalizeString(f);
        return nf.contains(normalizeString(q)) || sharesTrigram(q, f);
      });

      if (!passesGuard) {
        continue;
      }

      final score = fields
          .map((f) => getFuzzyScore(q, f))
          .fold<int>(
            0,
            (mx, v) => v > mx ? v : mx,
          );

      if (score >= threshold) {
        scored.add((l: l, score: score));
      }
    }

    scored.sort((a, b) {
      final s = b.score.compareTo(a.score);
      return s != 0 ? s : a.l.name.compareTo(b.l.name);
    });

    return [for (final e in scored) e.l];
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///
          /// LOCATIONS
          ///
          IntrinsicHeight(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  currentLocations.length,
                  (index) {
                    final location = currentLocations[index];

                    final locationCoordinates = location.latitude != null && location.longitude != null
                        ? LatLng(
                            location.latitude!,
                            location.longitude!,
                          )
                        : null;

                    final icon = getPhosphorIconFromName(location.iconName)?.value;

                    return TransactionLocation(
                      key: ValueKey(location.id),
                      onPressed: (location) {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop(location);
                      },
                      location: location,
                      coordinates: locationCoordinates,
                      isActive: false,
                      useMap: locationCoordinates != null,
                      useVectorMaps: widget.useVectorMaps,
                      mapStyle: widget.mapState,
                      color: context.colors.buttonBackground,
                      icon: icon != null
                          ? getPhosphorIcon(
                              icon,
                              isDuotone: widget.useColorfulIcons,
                              isBold: false,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          ///
          /// TEXT
          ///
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              'transactionLocationSearchModalText'.tr(),
              style: context.textStyles.homeTitle,
            ),
          ),
          const SizedBox(height: 12),

          ///
          /// SEARCH
          ///
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TroskoTextField(
              autofocus: true,
              onSubmitted: (_) {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop(currentLocations.firstOrNull);
              },
              focusNode: searchFocusNode,
              controller: textEditingController,
              labelText: 'searchTextField'.tr(),
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.search,
            ),
          ),
        ],
      ),
    ),
  );
}
