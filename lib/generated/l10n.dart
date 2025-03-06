// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello`
  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  /// `Became a Partner`
  String get became_partner {
    return Intl.message(
      'Became a Partner',
      name: 'became_partner',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to our application!`
  String get welcome {
    return Intl.message(
      'Welcome to our application!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Warehousing`
  String get warehousing {
    return Intl.message('Warehousing', name: 'warehousing', desc: '', args: []);
  }

  /// `Transportation`
  String get transportation {
    return Intl.message(
      'Transportation',
      name: 'transportation',
      desc: '',
      args: [],
    );
  }

  /// `Manpower`
  String get manpower {
    return Intl.message('Manpower', name: 'manpower', desc: '', args: []);
  }

  /// `Agricultural`
  String get agricultural {
    return Intl.message(
      'Agricultural',
      name: 'agricultural',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message('More', name: 'more', desc: '', args: []);
  }

  /// `See all...`
  String get seall {
    return Intl.message('See all...', name: 'seall', desc: '', args: []);
  }

  /// `Call for Assistance`
  String get call_for_assistance {
    return Intl.message(
      'Call for Assistance',
      name: 'call_for_assistance',
      desc: '',
      args: [],
    );
  }

  /// `Contracts Documents`
  String get contracts_documents {
    return Intl.message(
      'Contracts Documents',
      name: 'contracts_documents',
      desc: '',
      args: [],
    );
  }

  /// `Complete KYC`
  String get complete_kyc {
    return Intl.message(
      'Complete KYC',
      name: 'complete_kyc',
      desc: '',
      args: [],
    );
  }

  /// `Subscriptions`
  String get subscriptions {
    return Intl.message(
      'Subscriptions',
      name: 'subscriptions',
      desc: '',
      args: [],
    );
  }

  /// `Referral`
  String get referral {
    return Intl.message('Referral', name: 'referral', desc: '', args: []);
  }

  /// `Help and Support`
  String get help_and_support {
    return Intl.message(
      'Help and Support',
      name: 'help_and_support',
      desc: '',
      args: [],
    );
  }

  /// `Connect with WhatsApp`
  String get connect_with_whatsapp {
    return Intl.message(
      'Connect with WhatsApp',
      name: 'connect_with_whatsapp',
      desc: '',
      args: [],
    );
  }

  /// `Notification Setting`
  String get notification_setting {
    return Intl.message(
      'Notification Setting',
      name: 'notification_setting',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get terms_and_conditions {
    return Intl.message(
      'Terms and Conditions',
      name: 'terms_and_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get log_out {
    return Intl.message('Log out', name: 'log_out', desc: '', args: []);
  }

  /// `Follow us on`
  String get follow_us_on {
    return Intl.message(
      'Follow us on',
      name: 'follow_us_on',
      desc: '',
      args: [],
    );
  }

  /// `We value your feedback`
  String get we_value_your_feedback {
    return Intl.message(
      'We value your feedback',
      name: 'we_value_your_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Rate your experience`
  String get rate_your_experience {
    return Intl.message(
      'Rate your experience',
      name: 'rate_your_experience',
      desc: '',
      args: [],
    );
  }

  /// `Your comment`
  String get your_comment {
    return Intl.message(
      'Your comment',
      name: 'your_comment',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Submit feedback`
  String get submit_feedback {
    return Intl.message(
      'Submit feedback',
      name: 'submit_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `No Notifications`
  String get no_notifications {
    return Intl.message(
      'No Notifications',
      name: 'no_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Sort`
  String get sort {
    return Intl.message('Sort', name: 'sort', desc: '', args: []);
  }

  /// `Filter`
  String get filter {
    return Intl.message('Filter', name: 'filter', desc: '', args: []);
  }

  /// `Please wait for sometime...`
  String get please_wait_for_sometime {
    return Intl.message(
      'Please wait for sometime...',
      name: 'please_wait_for_sometime',
      desc: '',
      args: [],
    );
  }

  /// `ShortListed`
  String get shortlisted {
    return Intl.message('ShortListed', name: 'shortlisted', desc: '', args: []);
  }

  /// `Interested`
  String get interested {
    return Intl.message('Interested', name: 'interested', desc: '', args: []);
  }

  /// `No Shortlisted Warehouses found`
  String get no_shortlisted_warehouses_found {
    return Intl.message(
      'No Shortlisted Warehouses found',
      name: 'no_shortlisted_warehouses_found',
      desc: '',
      args: [],
    );
  }

  /// `No Interested Warehouse found`
  String get no_interested_warehouse_found {
    return Intl.message(
      'No Interested Warehouse found',
      name: 'no_interested_warehouse_found',
      desc: '',
      args: [],
    );
  }

  /// `Express interest to get a call back.`
  String get express_interest_to_get_callback {
    return Intl.message(
      'Express interest to get a call back.',
      name: 'express_interest_to_get_callback',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `General`
  String get general {
    return Intl.message('General', name: 'general', desc: '', args: []);
  }

  /// `Your comments and Ratings help us to improve`
  String get your_comments_and_ratings_help_us_to_improve {
    return Intl.message(
      'Your comments and Ratings help us to improve',
      name: 'your_comments_and_ratings_help_us_to_improve',
      desc: '',
      args: [],
    );
  }

  /// `Write something valuable...(eg. Loved the service!)`
  String get write_something_valuable {
    return Intl.message(
      'Write something valuable...(eg. Loved the service!)',
      name: 'write_something_valuable',
      desc: '',
      args: [],
    );
  }

  /// `Post your Property FREE`
  String get post_your_property_free {
    return Intl.message(
      'Post your Property FREE',
      name: 'post_your_property_free',
      desc: '',
      args: [],
    );
  }

  /// `Looking for Rent Your Properties?`
  String get looking_for_rent_your_properties {
    return Intl.message(
      'Looking for Rent Your Properties?',
      name: 'looking_for_rent_your_properties',
      desc: '',
      args: [],
    );
  }

  /// `Verified property and Owner`
  String get verified_property_and_owner {
    return Intl.message(
      'Verified property and Owner',
      name: 'verified_property_and_owner',
      desc: '',
      args: [],
    );
  }

  /// `Larger Collection of Warehouses`
  String get larger_collection_of_warehouses {
    return Intl.message(
      'Larger Collection of Warehouses',
      name: 'larger_collection_of_warehouses',
      desc: '',
      args: [],
    );
  }

  /// `Search by location`
  String get search_by_location {
    return Intl.message(
      'Search by location',
      name: 'search_by_location',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse near you..`
  String get warehouse_near_you {
    return Intl.message(
      'Warehouse near you..',
      name: 'warehouse_near_you',
      desc: '',
      args: [],
    );
  }

  /// `Near By`
  String get near_by {
    return Intl.message('Near By', name: 'near_by', desc: '', args: []);
  }

  /// `Price (Min to Max)`
  String get price_min_to_max {
    return Intl.message(
      'Price (Min to Max)',
      name: 'price_min_to_max',
      desc: '',
      args: [],
    );
  }

  /// `Price (Max to Min)`
  String get price_max_to_min {
    return Intl.message(
      'Price (Max to Min)',
      name: 'price_max_to_min',
      desc: '',
      args: [],
    );
  }

  /// `Area (Min to Max)`
  String get area_min_to_max {
    return Intl.message(
      'Area (Min to Max)',
      name: 'area_min_to_max',
      desc: '',
      args: [],
    );
  }

  /// `Area (Max to Min)`
  String get area_max_to_min {
    return Intl.message(
      'Area (Max to Min)',
      name: 'area_max_to_min',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Filters`
  String get advanced_filters {
    return Intl.message(
      'Advanced Filters',
      name: 'advanced_filters',
      desc: '',
      args: [],
    );
  }

  /// `Construction Types`
  String get construction_types {
    return Intl.message(
      'Construction Types',
      name: 'construction_types',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse Types`
  String get warehouse_types {
    return Intl.message(
      'Warehouse Types',
      name: 'warehouse_types',
      desc: '',
      args: [],
    );
  }

  /// `Rent Range`
  String get rent_range {
    return Intl.message('Rent Range', name: 'rent_range', desc: '', args: []);
  }

  /// `PEB`
  String get peb {
    return Intl.message('PEB', name: 'peb', desc: '', args: []);
  }

  /// `Cold Storage`
  String get cold_storage {
    return Intl.message(
      'Cold Storage',
      name: 'cold_storage',
      desc: '',
      args: [],
    );
  }

  /// `RCC`
  String get rcc {
    return Intl.message('RCC', name: 'rcc', desc: '', args: []);
  }

  /// `Shed`
  String get shed {
    return Intl.message('Shed', name: 'shed', desc: '', args: []);
  }

  /// `Factory`
  String get factory {
    return Intl.message('Factory', name: 'factory', desc: '', args: []);
  }

  /// `Others`
  String get others {
    return Intl.message('Others', name: 'others', desc: '', args: []);
  }

  /// `Clear All`
  String get clear_all {
    return Intl.message('Clear All', name: 'clear_all', desc: '', args: []);
  }

  /// `Apply Filters`
  String get apply_filters {
    return Intl.message(
      'Apply Filters',
      name: 'apply_filters',
      desc: '',
      args: [],
    );
  }

  /// `Dark Store`
  String get dark_store {
    return Intl.message('Dark Store', name: 'dark_store', desc: '', args: []);
  }

  /// `Open Space`
  String get open_space {
    return Intl.message('Open Space', name: 'open_space', desc: '', args: []);
  }

  /// `Industrial Shed`
  String get industrial_shed {
    return Intl.message(
      'Industrial Shed',
      name: 'industrial_shed',
      desc: '',
      args: [],
    );
  }

  /// `BTS`
  String get bts {
    return Intl.message('BTS', name: 'bts', desc: '', args: []);
  }

  /// `Multi-Storey Building`
  String get multi_storey_building {
    return Intl.message(
      'Multi-Storey Building',
      name: 'multi_storey_building',
      desc: '',
      args: [],
    );
  }

  /// `Parking Land`
  String get parking_land {
    return Intl.message(
      'Parking Land',
      name: 'parking_land',
      desc: '',
      args: [],
    );
  }

  /// `Select Rent Range`
  String get select_rent_range {
    return Intl.message(
      'Select Rent Range',
      name: 'select_rent_range',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Radius in KM`
  String get radius_in_km {
    return Intl.message(
      'Radius in KM',
      name: 'radius_in_km',
      desc: '',
      args: [],
    );
  }

  /// `Whose partner do you want to be?`
  String get whose_partner_question {
    return Intl.message(
      'Whose partner do you want to be?',
      name: 'whose_partner_question',
      desc: '',
      args: [],
    );
  }

  /// `Manage your warehouse quickly!`
  String get manage_your_warehouse {
    return Intl.message(
      'Manage your warehouse quickly!',
      name: 'manage_your_warehouse',
      desc: '',
      args: [],
    );
  }

  /// `Add New`
  String get add_new {
    return Intl.message('Add New', name: 'add_new', desc: '', args: []);
  }

  /// `Add Warehouse`
  String get add_warehouse {
    return Intl.message(
      'Add Warehouse',
      name: 'add_warehouse',
      desc: '',
      args: [],
    );
  }

  /// `Start by adding your first warehouse`
  String get start_adding_warehouse {
    return Intl.message(
      'Start by adding your first warehouse',
      name: 'start_adding_warehouse',
      desc: '',
      args: [],
    );
  }

  /// `Add warehouse details to attract potential customers`
  String get add_warehouse_details {
    return Intl.message(
      'Add warehouse details to attract potential customers',
      name: 'add_warehouse_details',
      desc: '',
      args: [],
    );
  }

  /// `We are happy to help you!`
  String get we_are_happy_to_help {
    return Intl.message(
      'We are happy to help you!',
      name: 'we_are_happy_to_help',
      desc: '',
      args: [],
    );
  }

  /// `Need Assistance`
  String get need_assistance {
    return Intl.message(
      'Need Assistance',
      name: 'need_assistance',
      desc: '',
      args: [],
    );
  }

  /// `My Profile`
  String get my_profile {
    return Intl.message('My Profile', name: 'my_profile', desc: '', args: []);
  }

  /// `Help`
  String get help {
    return Intl.message('Help', name: 'help', desc: '', args: []);
  }

  /// `All topics`
  String get all_topics {
    return Intl.message('All topics', name: 'all_topics', desc: '', args: []);
  }

  /// `Troubleshooting`
  String get troubleshooting {
    return Intl.message(
      'Troubleshooting',
      name: 'troubleshooting',
      desc: '',
      args: [],
    );
  }

  /// `Payments`
  String get payments {
    return Intl.message('Payments', name: 'payments', desc: '', args: []);
  }

  /// `Add warehouse Now`
  String get add_warehouse_now {
    return Intl.message(
      'Add warehouse Now',
      name: 'add_warehouse_now',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get my_account {
    return Intl.message('My Account', name: 'my_account', desc: '', args: []);
  }

  /// `Is warehouse available?`
  String get is_warehouse_available {
    return Intl.message(
      'Is warehouse available?',
      name: 'is_warehouse_available',
      desc: '',
      args: [],
    );
  }

  /// `View request`
  String get view_request {
    return Intl.message(
      'View request',
      name: 'view_request',
      desc: '',
      args: [],
    );
  }

  /// `Bids`
  String get bids {
    return Intl.message('Bids', name: 'bids', desc: '', args: []);
  }

  /// `Contracts`
  String get contracts {
    return Intl.message('Contracts', name: 'contracts', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Update Warehouse`
  String get update_warehouse {
    return Intl.message(
      'Update Warehouse',
      name: 'update_warehouse',
      desc: '',
      args: [],
    );
  }

  /// `Update your warehouse information!`
  String get update_warehouse_info {
    return Intl.message(
      'Update your warehouse information!',
      name: 'update_warehouse_info',
      desc: '',
      args: [],
    );
  }

  /// `Update your warehouse address`
  String get update_warehouse_address {
    return Intl.message(
      'Update your warehouse address',
      name: 'update_warehouse_address',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse Name/ Owner's name`
  String get warehouse_name_owner_name {
    return Intl.message(
      'Warehouse Name/ Owner\'s name',
      name: 'warehouse_name_owner_name',
      desc: '',
      args: [],
    );
  }

  /// `Total area`
  String get total_area {
    return Intl.message('Total area', name: 'total_area', desc: '', args: []);
  }

  /// `Carpet Area`
  String get carpet_area {
    return Intl.message('Carpet Area', name: 'carpet_area', desc: '', args: []);
  }

  /// `Ground Floor`
  String get ground_floor {
    return Intl.message(
      'Ground Floor',
      name: 'ground_floor',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message('Open', name: 'open', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `No. of floors including Ground Floors`
  String get num_of_floors_including_ground_floors {
    return Intl.message(
      'No. of floors including Ground Floors',
      name: 'num_of_floors_including_ground_floors',
      desc: '',
      args: [],
    );
  }

  /// `Is the base available for rent?`
  String get is_base_available_for_rent {
    return Intl.message(
      'Is the base available for rent?',
      name: 'is_base_available_for_rent',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse type`
  String get warehouse_type {
    return Intl.message(
      'Warehouse type',
      name: 'warehouse_type',
      desc: '',
      args: [],
    );
  }

  /// `Construction Type`
  String get construction_type {
    return Intl.message(
      'Construction Type',
      name: 'construction_type',
      desc: '',
      args: [],
    );
  }

  /// `Construction age in months`
  String get construction_age_in_months {
    return Intl.message(
      'Construction age in months',
      name: 'construction_age_in_months',
      desc: '',
      args: [],
    );
  }

  /// `Rent per Sq.ft`
  String get rent_per_sqft {
    return Intl.message(
      'Rent per Sq.ft',
      name: 'rent_per_sqft',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance Cost (per Sq. ft.)`
  String get maintenance_cost_per_sqft {
    return Intl.message(
      'Maintenance Cost (per Sq. ft.)',
      name: 'maintenance_cost_per_sqft',
      desc: '',
      args: [],
    );
  }

  /// `Security Deposit`
  String get security_deposit {
    return Intl.message(
      'Security Deposit',
      name: 'security_deposit',
      desc: '',
      args: [],
    );
  }

  /// `Token Advance`
  String get token_advance {
    return Intl.message(
      'Token Advance',
      name: 'token_advance',
      desc: '',
      args: [],
    );
  }

  /// `Lock-in Period`
  String get lock_in_period {
    return Intl.message(
      'Lock-in Period',
      name: 'lock_in_period',
      desc: '',
      args: [],
    );
  }

  /// `Update & Proceed`
  String get update_and_proceed {
    return Intl.message(
      'Update & Proceed',
      name: 'update_and_proceed',
      desc: '',
      args: [],
    );
  }

  /// `Skip for now`
  String get skip_for_now {
    return Intl.message(
      'Skip for now',
      name: 'skip_for_now',
      desc: '',
      args: [],
    );
  }

  /// `Add additional details to attract more clients`
  String get add_additional_details {
    return Intl.message(
      'Add additional details to attract more clients',
      name: 'add_additional_details',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse Images`
  String get warehouse_images {
    return Intl.message(
      'Warehouse Images',
      name: 'warehouse_images',
      desc: '',
      args: [],
    );
  }

  /// `Upload media`
  String get upload_media {
    return Intl.message(
      'Upload media',
      name: 'upload_media',
      desc: '',
      args: [],
    );
  }

  /// `Update & Next`
  String get update_and_next {
    return Intl.message(
      'Update & Next',
      name: 'update_and_next',
      desc: '',
      args: [],
    );
  }

  /// `Edit warehouse Details`
  String get edit_warehouse_details {
    return Intl.message(
      'Edit warehouse Details',
      name: 'edit_warehouse_details',
      desc: '',
      args: [],
    );
  }

  /// `Update warehouse amenities`
  String get update_warehouse_amenities {
    return Intl.message(
      'Update warehouse amenities',
      name: 'update_warehouse_amenities',
      desc: '',
      args: [],
    );
  }

  /// `FIRE NOC: Is your warehouse Fire compliant?`
  String get fire_noc {
    return Intl.message(
      'FIRE NOC: Is your warehouse Fire compliant?',
      name: 'fire_noc',
      desc: '',
      args: [],
    );
  }

  /// `Do you have CLU Document?`
  String get have_clu_document {
    return Intl.message(
      'Do you have CLU Document?',
      name: 'have_clu_document',
      desc: '',
      args: [],
    );
  }

  /// `Electricity (in KVA)`
  String get electricity_in_kva {
    return Intl.message(
      'Electricity (in KVA)',
      name: 'electricity_in_kva',
      desc: '',
      args: [],
    );
  }

  /// `No of Fans`
  String get num_of_fans {
    return Intl.message('No of Fans', name: 'num_of_fans', desc: '', args: []);
  }

  /// `No. of Lights`
  String get num_of_lights {
    return Intl.message(
      'No. of Lights',
      name: 'num_of_lights',
      desc: '',
      args: [],
    );
  }

  /// `Does your warehouse have power backup?`
  String get warehouse_power_backup {
    return Intl.message(
      'Does your warehouse have power backup?',
      name: 'warehouse_power_backup',
      desc: '',
      args: [],
    );
  }

  /// `Do you provide Office Space?`
  String get provide_office_space {
    return Intl.message(
      'Do you provide Office Space?',
      name: 'provide_office_space',
      desc: '',
      args: [],
    );
  }

  /// `Does your warehouse have Dock Levelers?`
  String get warehouse_dock_levelers {
    return Intl.message(
      'Does your warehouse have Dock Levelers?',
      name: 'warehouse_dock_levelers',
      desc: '',
      args: [],
    );
  }

  /// `No. of toilets`
  String get num_of_toilets {
    return Intl.message(
      'No. of toilets',
      name: 'num_of_toilets',
      desc: '',
      args: [],
    );
  }

  /// `Truck Parking Slots`
  String get truck_parking_slots {
    return Intl.message(
      'Truck Parking Slots',
      name: 'truck_parking_slots',
      desc: '',
      args: [],
    );
  }

  /// `Bike Parking Slots`
  String get bike_parking_slots {
    return Intl.message(
      'Bike Parking Slots',
      name: 'bike_parking_slots',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Inner Length (feet)`
  String get inner_length {
    return Intl.message(
      'Inner Length (feet)',
      name: 'inner_length',
      desc: '',
      args: [],
    );
  }

  /// `Inner Width (feet)`
  String get inner_width {
    return Intl.message(
      'Inner Width (feet)',
      name: 'inner_width',
      desc: '',
      args: [],
    );
  }

  /// `Side Height (feet)`
  String get side_height {
    return Intl.message(
      'Side Height (feet)',
      name: 'side_height',
      desc: '',
      args: [],
    );
  }

  /// `Centre Height (feet)`
  String get centre_height {
    return Intl.message(
      'Centre Height (feet)',
      name: 'centre_height',
      desc: '',
      args: [],
    );
  }

  /// `No. of Docks`
  String get num_of_docks {
    return Intl.message(
      'No. of Docks',
      name: 'num_of_docks',
      desc: '',
      args: [],
    );
  }

  /// `Docks Height (feet)`
  String get docks_height {
    return Intl.message(
      'Docks Height (feet)',
      name: 'docks_height',
      desc: '',
      args: [],
    );
  }

  /// `Flooring Type`
  String get flooring_type {
    return Intl.message(
      'Flooring Type',
      name: 'flooring_type',
      desc: '',
      args: [],
    );
  }

  /// `Furnishing Type`
  String get furnishing_type {
    return Intl.message(
      'Furnishing Type',
      name: 'furnishing_type',
      desc: '',
      args: [],
    );
  }

  /// `Are you interested in Flexi Model?`
  String get flexi_model_interest {
    return Intl.message(
      'Are you interested in Flexi Model?',
      name: 'flexi_model_interest',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Are you sure you want to logout?`
  String get logout_confirmation {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logout_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Notification Settings`
  String get notification_settings {
    return Intl.message(
      'Notification Settings',
      name: 'notification_settings',
      desc: '',
      args: [],
    );
  }

  /// `Email Notifications`
  String get email_notifications {
    return Intl.message(
      'Email Notifications',
      name: 'email_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Phone Notifications`
  String get phone_notifications {
    return Intl.message(
      'Phone Notifications',
      name: 'phone_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Push Notifications`
  String get push_notifications {
    return Intl.message(
      'Push Notifications',
      name: 'push_notifications',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `Upload`
  String get upload {
    return Intl.message('Upload', name: 'upload', desc: '', args: []);
  }

  /// `Owner PAN CARD`
  String get owner_pan_card {
    return Intl.message(
      'Owner PAN CARD',
      name: 'owner_pan_card',
      desc: '',
      args: [],
    );
  }

  /// `Selfie of Owner`
  String get selfie_of_owner {
    return Intl.message(
      'Selfie of Owner',
      name: 'selfie_of_owner',
      desc: '',
      args: [],
    );
  }

  /// `Upload Aadhar Front Side`
  String get upload_aadhar_front {
    return Intl.message(
      'Upload Aadhar Front Side',
      name: 'upload_aadhar_front',
      desc: '',
      args: [],
    );
  }

  /// `Upload Aadhar Back Side`
  String get upload_aadhar_back {
    return Intl.message(
      'Upload Aadhar Back Side',
      name: 'upload_aadhar_back',
      desc: '',
      args: [],
    );
  }

  /// `Choose from Gallery`
  String get choose_from_gallery {
    return Intl.message(
      'Choose from Gallery',
      name: 'choose_from_gallery',
      desc: '',
      args: [],
    );
  }

  /// `Choose from Camera`
  String get choose_from_camera {
    return Intl.message(
      'Choose from Camera',
      name: 'choose_from_camera',
      desc: '',
      args: [],
    );
  }

  /// `Upload Document`
  String get upload_document {
    return Intl.message(
      'Upload Document',
      name: 'upload_document',
      desc: '',
      args: [],
    );
  }

  /// `Please upload your document`
  String get please_upload_document {
    return Intl.message(
      'Please upload your document',
      name: 'please_upload_document',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Phone Number`
  String get phone_number {
    return Intl.message(
      'Phone Number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Additional Phone Number`
  String get additional_phone_number {
    return Intl.message(
      'Additional Phone Number',
      name: 'additional_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Add Additional Email Address`
  String get add_additional_email {
    return Intl.message(
      'Add Additional Email Address',
      name: 'add_additional_email',
      desc: '',
      args: [],
    );
  }

  /// `Amenities`
  String get amenities {
    return Intl.message('Amenities', name: 'amenities', desc: '', args: []);
  }

  /// `View More`
  String get view_more {
    return Intl.message('View More', name: 'view_more', desc: '', args: []);
  }

  /// `View Less`
  String get view_less {
    return Intl.message('View Less', name: 'view_less', desc: '', args: []);
  }

  /// `Express Interest`
  String get express_interest {
    return Intl.message(
      'Express Interest',
      name: 'express_interest',
      desc: '',
      args: [],
    );
  }

  /// `Company Name`
  String get company_name {
    return Intl.message(
      'Company Name',
      name: 'company_name',
      desc: '',
      args: [],
    );
  }

  /// `Designation`
  String get designation {
    return Intl.message('Designation', name: 'designation', desc: '', args: []);
  }

  /// `Select Date of Possession`
  String get select_date_of_possession {
    return Intl.message(
      'Select Date of Possession',
      name: 'select_date_of_possession',
      desc: '',
      args: [],
    );
  }

  /// `Immediate`
  String get immediate {
    return Intl.message('Immediate', name: 'immediate', desc: '', args: []);
  }

  /// `Within 15 Days`
  String get within_15_days {
    return Intl.message(
      'Within 15 Days',
      name: 'within_15_days',
      desc: '',
      args: [],
    );
  }

  /// `Within 30 Days`
  String get within_30_days {
    return Intl.message(
      'Within 30 Days',
      name: 'within_30_days',
      desc: '',
      args: [],
    );
  }

  /// `Within 60 Days`
  String get within_60_days {
    return Intl.message(
      'Within 60 Days',
      name: 'within_60_days',
      desc: '',
      args: [],
    );
  }

  /// `Messenger`
  String get messenger {
    return Intl.message('Messenger', name: 'messenger', desc: '', args: []);
  }

  /// `Select Location`
  String get select_location {
    return Intl.message(
      'Select Location',
      name: 'select_location',
      desc: '',
      args: [],
    );
  }

  /// `Get Address`
  String get get_address {
    return Intl.message('Get Address', name: 'get_address', desc: '', args: []);
  }

  /// `Enter Address`
  String get enter_address {
    return Intl.message(
      'Enter Address',
      name: 'enter_address',
      desc: '',
      args: [],
    );
  }

  /// `Uploaded Successfully`
  String get uploaded_successfully {
    return Intl.message(
      'Uploaded Successfully',
      name: 'uploaded_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Add More Photos`
  String get add_more_photos {
    return Intl.message(
      'Add More Photos',
      name: 'add_more_photos',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Manage Videos`
  String get manage_videos {
    return Intl.message(
      'Manage Videos',
      name: 'manage_videos',
      desc: '',
      args: [],
    );
  }

  /// `Manage Photos`
  String get manage_photos {
    return Intl.message(
      'Manage Photos',
      name: 'manage_photos',
      desc: '',
      args: [],
    );
  }

  /// `Add More Videos`
  String get add_more_videos {
    return Intl.message(
      'Add More Videos',
      name: 'add_more_videos',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse Updated`
  String get warehouse_updated {
    return Intl.message(
      'Warehouse Updated',
      name: 'warehouse_updated',
      desc: '',
      args: [],
    );
  }

  /// `Your changes have been saved successfully`
  String get changes_saved_successfully {
    return Intl.message(
      'Your changes have been saved successfully',
      name: 'changes_saved_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Coming Soon`
  String get coming_soon {
    return Intl.message('Coming Soon', name: 'coming_soon', desc: '', args: []);
  }

  /// `Stay tuned for something amazing!`
  String get stay_tuned {
    return Intl.message(
      'Stay tuned for something amazing!',
      name: 'stay_tuned',
      desc: '',
      args: [],
    );
  }

  /// `Warehouses near you`
  String get warehouses_near_you {
    return Intl.message(
      'Warehouses near you',
      name: 'warehouses_near_you',
      desc: '',
      args: [],
    );
  }

  /// `Manage`
  String get manage {
    return Intl.message('Manage', name: 'manage', desc: '', args: []);
  }

  /// `Photos`
  String get photos {
    return Intl.message('Photos', name: 'photos', desc: '', args: []);
  }

  /// `Videos`
  String get videos {
    return Intl.message('Videos', name: 'videos', desc: '', args: []);
  }

  /// `Add Files`
  String get add_files {
    return Intl.message('Add Files', name: 'add_files', desc: '', args: []);
  }

  /// `Pick Images`
  String get pick_images {
    return Intl.message('Pick Images', name: 'pick_images', desc: '', args: []);
  }

  /// `Pick Videos`
  String get pick_videos {
    return Intl.message('Pick Videos', name: 'pick_videos', desc: '', args: []);
  }

  /// `Select Media`
  String get select_media {
    return Intl.message(
      'Select Media',
      name: 'select_media',
      desc: '',
      args: [],
    );
  }

  /// `Uploaded Media`
  String get uploaded_media {
    return Intl.message(
      'Uploaded Media',
      name: 'uploaded_media',
      desc: '',
      args: [],
    );
  }

  /// `Save & Next`
  String get save_next {
    return Intl.message('Save & Next', name: 'save_next', desc: '', args: []);
  }

  /// `Upload Warehouse Image Only`
  String get upload_warehouse_image {
    return Intl.message(
      'Upload Warehouse Image Only',
      name: 'upload_warehouse_image',
      desc: '',
      args: [],
    );
  }

  /// `Please ensure clarity & proper lighting`
  String get ensure_clarity_lighting {
    return Intl.message(
      'Please ensure clarity & proper lighting',
      name: 'ensure_clarity_lighting',
      desc: '',
      args: [],
    );
  }

  /// `Select Image Types`
  String get select_image_types {
    return Intl.message(
      'Select Image Types',
      name: 'select_image_types',
      desc: '',
      args: [],
    );
  }

  /// `Choose the type of image you are uploading`
  String get choose_image_type {
    return Intl.message(
      'Choose the type of image you are uploading',
      name: 'choose_image_type',
      desc: '',
      args: [],
    );
  }

  /// `Interior`
  String get interior {
    return Intl.message('Interior', name: 'interior', desc: '', args: []);
  }

  /// `Outer`
  String get outer {
    return Intl.message('Outer', name: 'outer', desc: '', args: []);
  }

  /// `Parking`
  String get parking {
    return Intl.message('Parking', name: 'parking', desc: '', args: []);
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Warehouse Amenities`
  String get warehouse_amenities {
    return Intl.message(
      'Warehouse Amenities',
      name: 'warehouse_amenities',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations`
  String get congratulations {
    return Intl.message(
      'Congratulations',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `Your warehouse has been published successfully`
  String get warehouse_published_success {
    return Intl.message(
      'Your warehouse has been published successfully',
      name: 'warehouse_published_success',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse Dimensions`
  String get warehouse_dimensions {
    return Intl.message(
      'Warehouse Dimensions',
      name: 'warehouse_dimensions',
      desc: '',
      args: [],
    );
  }

  /// `None`
  String get none {
    return Intl.message('None', name: 'none', desc: '', args: []);
  }

  /// `Failed to load image!`
  String get failed_to_load_image {
    return Intl.message(
      'Failed to load image!',
      name: 'failed_to_load_image',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get select_date {
    return Intl.message('Select Date', name: 'select_date', desc: '', args: []);
  }

  /// `Select Time`
  String get select_time {
    return Intl.message('Select Time', name: 'select_time', desc: '', args: []);
  }

  /// `Sorry...`
  String get sorry {
    return Intl.message('Sorry...', name: 'sorry', desc: '', args: []);
  }

  /// `No warehouse near you`
  String get no_warehouse_near_you {
    return Intl.message(
      'No warehouse near you',
      name: 'no_warehouse_near_you',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `Select a Filter`
  String get select_filter {
    return Intl.message(
      'Select a Filter',
      name: 'select_filter',
      desc: '',
      args: [],
    );
  }

  /// `Office Space`
  String get office_space {
    return Intl.message(
      'Office Space',
      name: 'office_space',
      desc: '',
      args: [],
    );
  }

  /// `Dock Levelers`
  String get dock_levelers {
    return Intl.message(
      'Dock Levelers',
      name: 'dock_levelers',
      desc: '',
      args: [],
    );
  }

  /// `Power Backup`
  String get power_backup {
    return Intl.message(
      'Power Backup',
      name: 'power_backup',
      desc: '',
      args: [],
    );
  }

  /// `Flexi Model`
  String get flexi_model {
    return Intl.message('Flexi Model', name: 'flexi_model', desc: '', args: []);
  }

  /// `Rent`
  String get rent {
    return Intl.message('Rent', name: 'rent', desc: '', args: []);
  }

  /// `Available Area`
  String get available_area {
    return Intl.message(
      'Available Area',
      name: 'available_area',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `km away from your current location`
  String get km_away {
    return Intl.message(
      'km away from your current location',
      name: 'km_away',
      desc: '',
      args: [],
    );
  }

  /// `Electricity`
  String get electricity {
    return Intl.message('Electricity', name: 'electricity', desc: '', args: []);
  }

  /// `Toilets`
  String get toilets {
    return Intl.message('Toilets', name: 'toilets', desc: '', args: []);
  }

  /// `Truck Slots`
  String get truck_slots {
    return Intl.message('Truck Slots', name: 'truck_slots', desc: '', args: []);
  }

  /// `Fans`
  String get fans {
    return Intl.message('Fans', name: 'fans', desc: '', args: []);
  }

  /// `Lights`
  String get lights {
    return Intl.message('Lights', name: 'lights', desc: '', args: []);
  }

  /// `Bike Slot`
  String get bike_slot {
    return Intl.message('Bike Slot', name: 'bike_slot', desc: '', args: []);
  }

  /// `Schedule a Visit`
  String get schedule_a_visit {
    return Intl.message(
      'Schedule a Visit',
      name: 'schedule_a_visit',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Your warehouse has been added successfully. Our team will connect with you shortly!`
  String get warehouse_added_success {
    return Intl.message(
      'Your warehouse has been added successfully. Our team will connect with you shortly!',
      name: 'warehouse_added_success',
      desc: '',
      args: [],
    );
  }

  /// `Continue Browsing`
  String get continue_browsing {
    return Intl.message(
      'Continue Browsing',
      name: 'continue_browsing',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message('Ok', name: 'ok', desc: '', args: []);
  }

  /// `Thanks you for your feedback!`
  String get thanks_for_feedback {
    return Intl.message(
      'Thanks you for your feedback!',
      name: 'thanks_for_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Edit Feedback`
  String get edit_feedback {
    return Intl.message(
      'Edit Feedback',
      name: 'edit_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Your changes have been saved Successfully`
  String get your_changes_saved {
    return Intl.message(
      'Your changes have been saved Successfully',
      name: 'your_changes_saved',
      desc: '',
      args: [],
    );
  }

  /// `Your Warehouse has been Published Successfully`
  String get warehouse_published {
    return Intl.message(
      'Your Warehouse has been Published Successfully',
      name: 'warehouse_published',
      desc: '',
      args: [],
    );
  }

  /// `Aadhaar Front`
  String get aadhaar_front {
    return Intl.message(
      'Aadhaar Front',
      name: 'aadhaar_front',
      desc: '',
      args: [],
    );
  }

  /// `Aadhaar Back`
  String get aadhaar_back {
    return Intl.message(
      'Aadhaar Back',
      name: 'aadhaar_back',
      desc: '',
      args: [],
    );
  }

  /// `Phone Notification`
  String get phone_notification {
    return Intl.message(
      'Phone Notification',
      name: 'phone_notification',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'kn'),
      Locale.fromSubtags(languageCode: 'ml'),
      Locale.fromSubtags(languageCode: 'mr'),
      Locale.fromSubtags(languageCode: 'pa'),
      Locale.fromSubtags(languageCode: 'ta'),
      Locale.fromSubtags(languageCode: 'te'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
