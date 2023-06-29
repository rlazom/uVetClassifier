import 'package:flutter/material.dart'
    show Alignment, BoxDecoration, Color, LinearGradient;
import 'package:u_vet_classifyer/common/extensions.dart';

/// URL ------------------------------------------------------------------------
class R {
  R._();
  static FlexStoreIdentifiers get storeIdentifiers =>
      const FlexStoreIdentifiers._();
  static FlexUrl get urls => const FlexUrl._();
  static FlexColors get colors => const FlexColors._();
  static FlexAssets get assets => const FlexAssets._();
  static CacheDirectories get directories => const CacheDirectories._();
}

/// Store Identifiers ----------------------------------------------------------
class FlexStoreIdentifiers {
  const FlexStoreIdentifiers._();
  String get appStoreId => '1485296132';
  String get googlePlayIdentifier => 'engineering.aleph.flexsports';
}

/// ----------------------------------------------------------------------------

/// URLs -----------------------------------------------------------------------
class FlexUrl {
  const FlexUrl._();
  static const String fitGamesDomain = 'https://api-mobile.flexsport.de/';
  FlexUrlManual get manualModule => const FlexUrlManual._();
  FlexUrlProgram get programModule => const FlexUrlProgram._();
  FlexUrlWorkout get workoutModule => const FlexUrlWorkout._();
  String get termsAndConditions => 'https://pages.flycricket.io/flexsports-0/terms.html';
  String get privacyPolicy => 'https://pages.flycricket.io/flexsports-0/privacy.html';
  String get deleteProfile => '${FlexUrl.fitGamesDomain}user';
}

class FlexUrlManual {
  const FlexUrlManual._();
  String get allCategories => '${FlexUrl.fitGamesDomain}manual-info/';
}

class FlexUrlProgram {
  const FlexUrlProgram._();
  String get allCategories => '${FlexUrl.fitGamesDomain}program_categories/';
  String programsByCategory({required String categoryId}) =>
      '${FlexUrl.fitGamesDomain}programs/?category=$categoryId';
  String weeksByProgram({required String programId}) =>
      '${FlexUrl.fitGamesDomain}programs/$programId';
}

class FlexUrlWorkout {
  const FlexUrlWorkout._();
  String get allCategories =>
      '${FlexUrl.fitGamesDomain}workout_categories/list_categories/';
  String get allRunDrillCategories =>
      '${FlexUrl.fitGamesDomain}workout_categories/get_run_drills/';
  String workoutsByCategory({required String categoryId}) =>
      '${FlexUrl.fitGamesDomain}workouts/?categories=$categoryId';
  String exercisesByWorkout({required String workoutId}) =>
      '${FlexUrl.fitGamesDomain}workouts/$workoutId/';
  FlexUrlStripe get stripe => const FlexUrlStripe._();
  // String get allPlans => '${FlexUrl.fitGamesDomain}checkout/products/';
  // String get allPlans => '${FlexUrl.fitGamesDomain}checkout/products/';
  // String get allPlans => '${FlexUrl.fitGamesDomain}checkout/products/';
  // String planCheckout({required String priceId}) =>
  //     '${FlexUrl.fitGamesDomain}checkout/product?price_id=$priceId';
  // String get activeSubscription =>
  //     '${FlexUrl.fitGamesDomain}checkout/subscription/';
  // String get cancelActiveSubscription =>
  //     '$activeSubscription''cancel/';
}

class FlexUrlStripe {
  const FlexUrlStripe._();
  static const String stripeDomain = 'https://api.stripe.com/';
  static const String stripeVersion = 'v1/';
  static const String stripeUrl = '$stripeDomain$stripeVersion';
  // String get allPlans => '${FlexUrl.fitGamesDomain}checkout/products/';
  String get products => '$stripeUrl''products';
  String get prices => '$stripeUrl''prices';
  String get customers => '$stripeUrl''customers';
  String get subscriptions => '$stripeUrl''subscriptions';
  String get paymentMethods => '$stripeUrl''payment_methods';
  String product({required String? productId}) =>
      '$products''/$productId';
  String customer({required String? customerId}) =>
      '$customers''/$customerId';
  String customerByEmail({required String? email}) =>
      '$customers''?email=$email';
  String subscription({subscriptionId}) => '$subscriptions''/$subscriptionId';
  String paymentMethod({required String? paymentMethodId}) =>
      '$paymentMethods''/$paymentMethodId';
  String paymentMethodAttach({required String? paymentMethodId}) =>
      '${paymentMethod(paymentMethodId: paymentMethodId)}/attach';
  // String planCheckout({required String priceId}) => '${FlexUrl.fitGamesDomain}checkout/product?price_id=$priceId';
  // String get activeSubscription => '${FlexUrl.fitGamesDomain}checkout/subscription/';
  String activeSubscription({required String? customerId}) => '${customer(customerId: customerId)}''/subscriptions';
  // String get cancelActiveSubscription => '$activeSubscription''cancel/';
  String get updateUserSubscription => '${FlexUrl.fitGamesDomain}user/subscribe';
}
/// ----------------------------------------------------------------------------

/// Colors ---------------------------------------------------------------------
class FlexColors {
  const FlexColors._();
  Color get appPrimaryColor => const Color(0xFF009FE3);
  Color get workoutCardBackgroundColor => '#1E1E1E'.hexToColor();
  Color get workoutCardInnerContainerColor => '#303030'.hexToColor();
  Color get darkGreyColor => '#262626'.hexToColor();
  Color get videoCardColor => '#424242'.hexToColor();
  BoxDecoration get mainBackgroundGradient => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.4174, 0.93],
          colors: ['#000000'.hexToColor(), '#2B2B2B'.hexToColor()],
        ),
      );
}

/// ----------------------------------------------------------------------------

/// Assets  --------------------------------------------------------------------
class FlexAssets {
  const FlexAssets._();
  // Map<AudioType, String> get audio => {
  //       AudioType.WORK: 'beep1.mp3',
  //       AudioType.REST: 'beep2.mp3',
  //       AudioType.FINISH: 'beep4.mp3',
  //       AudioType.COUNTDOWN_3: 'beep_alarm_3.mp3',
  //       AudioType.COUNTDOWN_2: 'beep_alarm_2.mp3',
  //       AudioType.COUNTDOWN_1: 'beep_alarm_1.mp3',
  //     };
}

/// ----------------------------------------------------------------------------

/// Cache Directories ----------------------------------------------------------
class CacheDirectories {
  const CacheDirectories._();
  String get dirAssetsPath => 'assets';
  String get dirManualPath => 'manual';
  String get dirAudioPath => 'audio';
  String get dirVideoPath => 'video';
  String get dirRunDrillsPath => 'run_drills';
  String get dirWorkoutPath => 'workout';
  String get dirProgramPath => 'program';
  String get dirDownloadPath => 'download';
}

/// ----------------------------------------------------------------------------
