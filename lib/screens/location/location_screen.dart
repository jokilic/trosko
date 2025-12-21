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
            smallTitle: widget.passedLocation != null ? 'categoryUpdateTitle'.tr() : 'categoryNewTitle'.tr(),
            bigTitle: widget.passedLocation != null ? 'categoryUpdateTitle'.tr() : 'categoryNewTitle'.tr(),
            bigSubtitle: widget.passedLocation != null ? 'categoryUpdateSubtitle'.tr() : 'categoryNewSubtitle'.tr(),
          ),

          ///
          /// CONTENT
          ///
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 8),

                ///
                /// CATEGORY
                ///
                Column(
                  children: [
                    Container(
                      height: 104,
                      width: 104,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: categoryColor,
                        border: Border.all(
                          color: categoryColor ?? context.colors.text,
                          width: 1.5,
                        ),
                      ),
                      child: categoryIcon != null
                          ? PhosphorIcon(
                              categoryIcon.value,
                              color: getWhiteOrBlackColor(
                                backgroundColor: categoryColor ?? context.colors.scaffoldBackground,
                                whiteColor: TroskoColors.lightThemeWhiteBackground,
                                blackColor: TroskoColors.lightThemeBlackText,
                              ),
                              size: 56,
                            )
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      categoryName ?? '',
                      style: context.textStyles.categoryName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                ///
                /// CATEGORY TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'categoryTitle'.tr(),
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
                    labelText: 'categoryTitle'.tr(),
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// COLOR TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'categoryColor'.tr(),
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// CATEGORY COLORS
                ///
                // CategoryColors(
                //   colors: categoryColors,
                //   activeColor: categoryColor,
                //   onPressedColor: (color) {
                //     HapticFeedback.lightImpact();
                //     locationController.colorChanged(color);
                //   },
                //   onPressedAdd: () async {
                //     unawaited(
                //       HapticFeedback.lightImpact(),
                //     );

                //     /// Show [CategoryCustomColorModal]
                //     final color = await showModalBottomSheet<Color>(
                //       context: context,
                //       backgroundColor: context.colors.scaffoldBackground,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       builder: (context) => CategoryCustomColorModal(
                //         startingColor: context.colors.buttonPrimary,
                //         key: const ValueKey('custom-color-modal'),
                //       ),
                //     );

                //     /// `color` exists
                //     if (color != null) {
                //       locationController.colorChanged(color);
                //     }
                //   },
                // ),
                const SizedBox(height: 28),

                ///
                /// ICON TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'categoryIcon'.tr(),
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// CATEGORY ICON TEXT FIELD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TroskoTextField(
                    controller: TextEditingController(),
                    // controller: locationController.iconTextEditingController,
                    labelText: 'categoryIcon'.tr(),
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 20),

                ///
                /// CATEGORY ICONS
                ///
                if (searchedIcons?.isNotEmpty ?? false)
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: context.colors.listTileBackground,
                      border: Border.all(
                        color: context.colors.text,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: searchedIcons?.length,
                      itemBuilder: (_, index) {
                        final icon = searchedIcons![index];

                        return Container(
                          height: 40,
                          width: 40,
                          color: Colors.green,
                        );

                        // return CategoryIconListTile(
                        //   isActive: categoryIcon?.key == icon.key,
                        //   onPressed: () {
                        //     HapticFeedback.lightImpact();
                        //     locationController.iconChanged(icon);
                        //   },
                        //   icon: icon,
                        // );
                      },
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
