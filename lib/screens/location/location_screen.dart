import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/location/location.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../theme/colors.dart';
import '../../theme/extensions.dart';
import '../../util/color.dart';
import '../../util/dependencies.dart';
import '../../widgets/trosko_app_bar.dart';
import '../../widgets/trosko_text_field.dart';
import 'location_controller.dart';
import 'widgets/location_map.dart';

class LocationScreen extends WatchingStatefulWidget {
  final Location? passedLocation;

  const LocationScreen({
    required this.passedLocation,
    required super.key,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<LocationController>(
      () => LocationController(
        logger: getIt.get<LoggerService>(),
        hive: getIt.get<HiveService>(),
        firebase: getIt.get<FirebaseService>(),
        passedLocation: widget.passedLocation,
      ),
      instanceName: widget.passedLocation?.id,
      // afterRegister: (controller) => controller.init(),
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<LocationController>(
      instanceName: widget.passedLocation?.id,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationController = getIt.get<LocationController>(
      instanceName: widget.passedLocation?.id,
    );

    final state = watchIt<LocationController>(
      instanceName: widget.passedLocation?.id,
    ).value;

    final categoryName = state.categoryName;
    final categoryColor = state.categoryColor;
    final categoryIcon = state.categoryIcon;

    final searchedIcons = state.searchedIcons;

    final validated = state.nameValid && state.categoryColor != null && state.categoryIcon != null;

    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        slivers: [
          ///
          /// APP BAR
          ///
          TroskoAppBar(
            leadingWidget: IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                highlightColor: context.colors.buttonBackground,
              ),
              icon: PhosphorIcon(
                PhosphorIcons.arrowLeft(
                  PhosphorIconsStyle.bold,
                ),
                color: context.colors.text,
                size: 28,
              ),
            ),
            actionWidgets: [
              if (widget.passedLocation != null)
                IconButton(
                  onPressed: () async {
                    unawaited(
                      HapticFeedback.lightImpact(),
                    );
                    // await locationController.deleteCategory();
                    Navigator.of(context).pop();
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    highlightColor: context.colors.buttonBackground,
                  ),
                  icon: PhosphorIcon(
                    PhosphorIcons.trash(
                      PhosphorIconsStyle.bold,
                    ),
                    color: context.colors.delete,
                    size: 28,
                  ),
                ),
            ],
            // TODO: Localize
            smallTitle: widget.passedLocation != null ? 'Update location' : 'New location',
            bigTitle: widget.passedLocation != null ? 'Update location' : 'New location',
            bigSubtitle: widget.passedLocation != null ? 'Edit details of an existing location' : 'Create a location to track your expenses',
          ),

          ///
          /// CONTENT
          ///
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 8),

                ///
                /// LOCATION
                ///
                Column(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow,
                        border: Border.all(
                          color: context.colors.text,
                          width: 1.5,
                        ),
                      ),
                      child: LocationMap(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
                const SizedBox(height: 20),

                ///
                /// LOCATION TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    // TODO: Localize
                    'Title',
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// TITLE TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    controller: locationController.nameTextEditingController,
                    // TODO: Localize
                    labelText: 'Title',
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// NOTE TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    controller: locationController.noteTextEditingController,
                    // TODO: Localize
                    labelText: 'transactionNote'.tr(),
                    keyboardType: TextInputType.multiline,
                    minLines: null,
                    maxLines: 3,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// LOCATION ADDRESS
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    // TODO: Localize
                    'Address',
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// ADDRESS TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    onSubmitted: locationController.onAddressSubmitted,
                    controller: locationController.addressTextEditingController,
                    // TODO: Localize
                    labelText: 'Address',
                    keyboardType: TextInputType.streetAddress,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: validated
                ? () async {
                    unawaited(
                      HapticFeedback.lightImpact(),
                    );
                    await locationController.addCategory();
                    Navigator.of(context).pop();
                  }
                : null,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.fromLTRB(
                24,
                28,
                24,
                MediaQuery.paddingOf(context).bottom + 12,
              ),
              backgroundColor: context.colors.buttonPrimary,
              foregroundColor: getWhiteOrBlackColor(
                backgroundColor: context.colors.buttonPrimary,
                whiteColor: TroskoColors.lightThemeWhiteBackground,
                blackColor: TroskoColors.lightThemeBlackText,
              ),
              overlayColor: context.colors.buttonBackground,
              disabledBackgroundColor: context.colors.disabledBackground,
              disabledForegroundColor: context.colors.disabledText,
            ),
            child: Text(
              widget.passedLocation != null ? 'categoryUpdateButton'.tr().toUpperCase() : 'categoryAddButton'.tr().toUpperCase(),
            ),
          ),
        ),
      ),
    );
  }
}
