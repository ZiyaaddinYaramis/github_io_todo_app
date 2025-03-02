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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Task Management`
  String get appTitle {
    return Intl.message(
      'Task Management',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter Task`
  String get enterTask {
    return Intl.message(
      'Enter Task',
      name: 'enterTask',
      desc: '',
      args: [],
    );
  }

  /// `Priority`
  String get priorityLabel {
    return Intl.message(
      'Priority',
      name: 'priorityLabel',
      desc: '',
      args: [],
    );
  }

  /// `Low`
  String get low {
    return Intl.message(
      'Low',
      name: 'low',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get medium {
    return Intl.message(
      'Medium',
      name: 'medium',
      desc: '',
      args: [],
    );
  }

  /// `High`
  String get high {
    return Intl.message(
      'High',
      name: 'high',
      desc: '',
      args: [],
    );
  }

  /// `Add Task`
  String get addTask {
    return Intl.message(
      'Add Task',
      name: 'addTask',
      desc: '',
      args: [],
    );
  }

  /// `No tasks available`
  String get noTasksAvailable {
    return Intl.message(
      'No tasks available',
      name: 'noTasksAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Incomplete`
  String get incomplete {
    return Intl.message(
      'Incomplete',
      name: 'incomplete',
      desc: '',
      args: [],
    );
  }

  /// `By Due Date`
  String get byDueDate {
    return Intl.message(
      'By Due Date',
      name: 'byDueDate',
      desc: '',
      args: [],
    );
  }

  /// `By Priority`
  String get byPriority {
    return Intl.message(
      'By Priority',
      name: 'byPriority',
      desc: '',
      args: [],
    );
  }

  /// `Reminder Date`
  String get reminderDate {
    return Intl.message(
      'Reminder Date',
      name: 'reminderDate',
      desc: '',
      args: [],
    );
  }

  /// `Choose Date`
  String get chooseDate {
    return Intl.message(
      'Choose Date',
      name: 'chooseDate',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Registration Successful`
  String get registrationSuccessful {
    return Intl.message(
      'Registration Successful',
      name: 'registrationSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Sign In Successful`
  String get signInSuccessful {
    return Intl.message(
      'Sign In Successful',
      name: 'signInSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get password {
    return Intl.message(
      'Enter your password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get error {
    return Intl.message(
      'An error occurred',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Fields cannot be empty`
  String get fieldsCannotBeEmpty {
    return Intl.message(
      'Fields cannot be empty',
      name: 'fieldsCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format`
  String get invalidEmailFormat {
    return Intl.message(
      'Invalid email format',
      name: 'invalidEmailFormat',
      desc: '',
      args: [],
    );
  }

  /// `Password reset email sent successfully.`
  String get passwordResetEmailSent {
    return Intl.message(
      'Password reset email sent successfully.',
      name: 'passwordResetEmailSent',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email to reset your password.`
  String get enterYourEmailToResetPassword {
    return Intl.message(
      'Please enter your email to reset your password.',
      name: 'enterYourEmailToResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters long.`
  String get passwordTooShort {
    return Intl.message(
      'Password must be at least 6 characters long.',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `No Reminder Date Chosen`
  String get noReminderDate {
    return Intl.message(
      'No Reminder Date Chosen',
      name: 'noReminderDate',
      desc: '',
      args: [],
    );
  }

  /// `Task Reminder`
  String get reminderTitle {
    return Intl.message(
      'Task Reminder',
      name: 'reminderTitle',
      desc: '',
      args: [],
    );
  }

  /// `No user found with this email.`
  String get userNotFound {
    return Intl.message(
      'No user found with this email.',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password. Please try again.`
  String get wrongPassword {
    return Intl.message(
      'Incorrect password. Please try again.',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `This account has been disabled. Please contact support.`
  String get userDisabled {
    return Intl.message(
      'This account has been disabled. Please contact support.',
      name: 'userDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Task name cannot be empty!`
  String get taskNameCannotBeEmpty {
    return Intl.message(
      'Task name cannot be empty!',
      name: 'taskNameCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this task?`
  String get deleteTaskConfirmation {
    return Intl.message(
      'Are you sure you want to delete this task?',
      name: 'deleteTaskConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete Task`
  String get deleteTask {
    return Intl.message(
      'Delete Task',
      name: 'deleteTask',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Edit Task`
  String get editTask {
    return Intl.message(
      'Edit Task',
      name: 'editTask',
      desc: '',
      args: [],
    );
  }

  /// `Add New Task`
  String get addNewTask {
    return Intl.message(
      'Add New Task',
      name: 'addNewTask',
      desc: '',
      args: [],
    );
  }

  /// `No user is logged in`
  String get noUserLoggedIn {
    return Intl.message(
      'No user is logged in',
      name: 'noUserLoggedIn',
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
      Locale.fromSubtags(languageCode: 'fi'),
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
