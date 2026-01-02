import 'dart:async';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/category/category.dart';
import '../../models/location/location.dart';
import '../../models/notification_payload/notification_payload.dart';
import '../../models/transaction/transaction.dart';
import '../../services/firebase_service.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';
import '../../services/map_service.dart';
import '../../theme/colors.dart';
import '../../theme/extensions.dart';
import '../../util/color.dart';
import '../../util/dependencies.dart';
import '../../util/icons.dart';
import '../../widgets/trosko_app_bar.dart';
import '../../widgets/trosko_text_field.dart';
import 'transaction_controller.dart';
import 'widgets/transaction_amount_widget.dart';
import 'widgets/transaction_category.dart';
import 'widgets/transaction_location.dart';

class TransactionScreen extends WatchingStatefulWidget {
  final Transaction? passedTransaction;
  final List<Category> categories;
  final Category? passedCategory;
  final List<Location> locations;
  final Location? passedLocation;
  final NotificationPayload? passedNotificationPayload;
  final Function() onTransactionUpdated;

  const TransactionScreen({
    required this.passedTransaction,
    required this.categories,
    required this.passedCategory,
    required this.locations,
    required this.passedLocation,
    required this.passedNotificationPayload,
    required this.onTransactionUpdated,
    required super.key,
  });

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<TransactionController>(
      () => TransactionController(
        logger: getIt.get<LoggerService>(),
        hive: getIt.get<HiveService>(),
        firebase: getIt.get<FirebaseService>(),
        passedTransaction: widget.passedTransaction,
        categories: widget.categories,
        locations: widget.locations,
        passedCategory: widget.passedCategory,
        passedLocation: widget.passedLocation,
        passedNotificationPayload: widget.passedNotificationPayload,
      ),
      instanceName: widget.passedTransaction?.id,
      afterRegister: (controller) => controller.init(),
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<TransactionController>(
      instanceName: widget.passedTransaction?.id,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionController = getIt.get<TransactionController>(
      instanceName: widget.passedTransaction?.id,
    );

    final state = watchIt<TransactionController>(
      instanceName: widget.passedTransaction?.id,
    ).value;

    final useVectorMaps = watchIt<HiveService>().value.settings?.useVectorMaps ?? false;

    final mapState = watchIt<MapService>().value;

    final activeCategory = state.category;
    final activeLocation = state.location;

    final chosenDateTime = state.transactionDateTime;

    final dateEditMode = state.dateEditMode;
    final timeEditMode = state.timeEditMode;

    final validated = state.nameValid && state.amountValid && state.categoryValid;

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
                getPhosphorIcon(
                  PhosphorIcons.arrowLeft,
                  isDuotone: false,
                  isBold: true,
                ),
                color: context.colors.text,
                duotoneSecondaryColor: context.colors.buttonPrimary,
                size: 28,
              ),
            ),
            actionWidgets: [
              if (widget.passedTransaction != null)
                IconButton(
                  onPressed: () async {
                    unawaited(
                      HapticFeedback.lightImpact(),
                    );

                    await transactionController.deleteTransaction();
                    widget.onTransactionUpdated();
                    Navigator.of(context).pop();
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    highlightColor: context.colors.buttonBackground,
                  ),
                  icon: PhosphorIcon(
                    getPhosphorIcon(
                      PhosphorIcons.trash,
                      isDuotone: false,
                      isBold: true,
                    ),
                    color: context.colors.delete,
                    duotoneSecondaryColor: context.colors.buttonPrimary,
                    size: 28,
                  ),
                ),
            ],
            smallTitle: widget.passedTransaction != null ? 'transactionUpdateTitle'.tr() : 'transactionNewTitle'.tr(),
            bigTitle: widget.passedTransaction != null ? 'transactionUpdateTitle'.tr() : 'transactionNewTitle'.tr(),
            bigSubtitle: widget.passedTransaction != null ? 'transactionUpdateSubtitle'.tr() : 'transactionNewSubtitle'.tr(),
          ),

          ///
          /// CONTENT
          ///
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 4),

                ///
                /// CATEGORY TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'transactionCategory'.tr(),
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// CATEGORIES
                ///
                IntrinsicHeight(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(
                        widget.categories.length,
                        (index) {
                          final category = widget.categories[index];
                          final key = transactionController.categoryKeys.putIfAbsent(
                            category.id,
                            GlobalKey.new,
                          );

                          final isActive = activeCategory == category;

                          final icon = getPhosphorIconFromName(category.iconName)?.value;

                          return TransactionCategory(
                            key: key,
                            onPressed: (category) {
                              HapticFeedback.lightImpact();
                              transactionController.categoryChanged(category);
                            },
                            category: category,
                            color: category.color.withValues(
                              alpha: isActive ? 1 : 0.2,
                            ),
                            highlightColor: category.color.withValues(
                              alpha: isActive ? 1 : 0.2,
                            ),
                            icon: icon != null
                                ? getPhosphorIcon(
                                    icon,
                                    isDuotone: false,
                                    isBold: false,
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                ///
                /// LOCATION TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'transactionLocation'.tr(),
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

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
                        widget.locations.length,
                        (index) {
                          final location = widget.locations[index];
                          final key = transactionController.locationKeys.putIfAbsent(
                            location.id,
                            GlobalKey.new,
                          );

                          final locationCoordinates = location.latitude != null && location.longitude != null
                              ? LatLng(
                                  location.latitude!,
                                  location.longitude!,
                                )
                              : null;

                          final isActive = activeLocation == location;

                          final icon = getPhosphorIconFromName(location.iconName)?.value;

                          return TransactionLocation(
                            key: key,
                            onPressed: (location) {
                              HapticFeedback.lightImpact();
                              transactionController.locationChanged(location);
                            },
                            location: location,
                            coordinates: locationCoordinates,
                            isActive: isActive,
                            useMap: locationCoordinates != null,
                            useVectorMaps: useVectorMaps,
                            mapStyle: mapState,
                            color: isActive ? context.colors.buttonPrimary : context.colors.buttonBackground,
                            icon: icon != null
                                ? getPhosphorIcon(
                                    icon,
                                    isDuotone: false,
                                    isBold: false,
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                ///
                /// TITLE & NOTE TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'transactionTitleNote'.tr(),
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
                    controller: transactionController.nameTextEditingController,
                    labelText: 'transactionTitle'.tr(),
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
                    controller: transactionController.noteTextEditingController,
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
                /// AMOUNT TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'transactionAmount'.tr(),
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// AMOUNT KEYPAD
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TransactionAmountWidget(
                    onValueChanged: transactionController.transactionAmountChanged,
                    initialCents: widget.passedTransaction?.amountCents ?? widget.passedNotificationPayload?.amountCents ?? 0,
                    languageCode: context.locale.languageCode,
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// DATE TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'transactionDate'.tr(),
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// DATE
                ///
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    transactionController.dateEditModeChanged();
                  },
                  highlightColor: context.colors.buttonBackground,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 16),
                    decoration: BoxDecoration(
                      color: dateEditMode ? context.colors.listTileBackground : null,
                      border: Border.all(
                        color: context.colors.text,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IgnorePointer(
                      ignoring: !dateEditMode,
                      child: CalendarDatePicker2(
                        config: CalendarDatePicker2Config(
                          calendarViewScrollPhysics: const BouncingScrollPhysics(),
                          controlsTextStyle: context.textStyles.homeTitle,
                          currentDate: DateTime.now(),
                          customModePickerIcon: const SizedBox.shrink(),
                          daySplashColor: Colors.transparent,
                          dayTextStyle: context.textStyles.transactionDateInactive,
                          dynamicCalendarRows: true,
                          hideMonthPickerDividers: true,
                          hideScrollViewMonthWeekHeader: true,
                          hideScrollViewTopHeader: true,
                          hideScrollViewTopHeaderDivider: true,
                          hideYearPickerDividers: true,
                          lastMonthIcon: PhosphorIcon(
                            getPhosphorIcon(
                              PhosphorIcons.caretCircleLeft,
                              isDuotone: false,
                              isBold: false,
                            ),
                            color: context.colors.text,
                            duotoneSecondaryColor: context.colors.buttonPrimary,
                            size: 28,
                          ),
                          monthTextStyle: context.textStyles.transactionDateInactive,
                          nextMonthIcon: PhosphorIcon(
                            getPhosphorIcon(
                              PhosphorIcons.caretCircleRight,
                              isDuotone: false,
                              isBold: false,
                            ),
                            color: context.colors.text,
                            duotoneSecondaryColor: context.colors.buttonPrimary,
                            size: 28,
                          ),
                          selectedDayHighlightColor: context.colors.text,
                          selectedDayTextStyle: context.textStyles.transactionDateActive,
                          selectedMonthTextStyle: context.textStyles.transactionDateActive,
                          selectedYearTextStyle: context.textStyles.transactionDateActive,
                          todayTextStyle: context.textStyles.transactionDateInactive,
                          weekdayLabelTextStyle: context.textStyles.homeTransactionNote,
                          yearTextStyle: context.textStyles.transactionDateInactive,
                        ),
                        value: [chosenDateTime],
                        onValueChanged: (dates) => transactionController.dateChanged(
                          dates.first,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                ///
                /// TIME TITLE
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'transactionTime'.tr(),
                    style: context.textStyles.homeTitle,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                /// TIME
                ///
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    transactionController.timeEditModeChanged();
                  },
                  highlightColor: context.colors.buttonBackground,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: timeEditMode ? context.colors.listTileBackground : null,
                      border: Border.all(
                        color: context.colors.text,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IgnorePointer(
                      ignoring: !timeEditMode,
                      child: ScrollDateTimePicker(
                        onChange: transactionController.timeChanged,
                        itemExtent: 64,
                        style: DateTimePickerStyle(
                          activeStyle: context.textStyles.transactionTimeActive,
                          inactiveStyle: context.textStyles.transactionTimeInactive,
                          disabledStyle: context.textStyles.transactionTimeInactive.copyWith(
                            color: context.colors.disabledText,
                          ),
                        ),
                        wheelOption: const DateTimePickerWheelOption(
                          physics: BouncingScrollPhysics(),
                        ),
                        dateOption: DateTimePickerOption(
                          dateFormat: DateFormat(
                            'HH:mm',
                            context.locale.languageCode,
                          ),
                          minDate: DateTime(2010),
                          maxDate: DateTime(2040),
                          initialDate: chosenDateTime,
                        ),
                        centerWidget: DateTimePickerCenterWidget(
                          builder: (context, constraints, child) => Container(
                            decoration: ShapeDecoration(
                              color: context.colors.listTileBackground,
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: context.colors.text,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: child,
                          ),
                        ),
                      ),
                    ),
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

                    await transactionController.addTransaction();
                    widget.onTransactionUpdated();
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
              widget.passedTransaction != null ? 'transactionUpdateButton'.tr().toUpperCase() : 'transactionAddButton'.tr().toUpperCase(),
            ),
          ),
        ),
      ),
    );
  }
}
