import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('it')
  ];

  /// The first part of the game rules displayed to the user
  ///
  /// In en, this message translates to:
  /// **'Complicity Game is a group game. You need to divide the participants into two teams composed of people with a great sense of mutual complicity'**
  String get gameRulesPart1;

  /// The second part of the game rules displayed to the user
  ///
  /// In en, this message translates to:
  /// **'At each turn the game chooses a word and a participant. The latter, through clues, will have to get their team to guess the word rather than the opposing team'**
  String get gameRulesPart2;

  /// The third part of the game rules displayed to the user
  ///
  /// In en, this message translates to:
  /// **'The first team to guess the chosen number of words wins (usually five)'**
  String get gameRulesPart3;

  /// The text prompting the user to enter participants' names
  ///
  /// In en, this message translates to:
  /// **'Enter at least two participants per team'**
  String get enterParticipantsNamesText;

  /// Text of the button to access the game rules screen
  ///
  /// In en, this message translates to:
  /// **'Game rules'**
  String get gameRulesButtonLabel;

  /// Text of the button to start a game
  ///
  /// In en, this message translates to:
  /// **'Start game'**
  String get startGameButtonLabel;

  /// Text of the button to delete a player
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButtonLabel;

  /// Text of the button to cancel the insertion of a player
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButtonLabel;

  /// HintText of the input to insert or edit a player
  ///
  /// In en, this message translates to:
  /// **'Player name'**
  String get playerNameHintText;

  /// Green team name
  ///
  /// In en, this message translates to:
  /// **'Green team'**
  String get greenTeamText;

  /// Yellow team name
  ///
  /// In en, this message translates to:
  /// **'Yellow team'**
  String get yellowTeamText;

  /// No description provided for @turnOfText.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get turnOfText;

  /// No description provided for @hideScreenHintText.
  ///
  /// In en, this message translates to:
  /// **'Keep the screen hidden from the others'**
  String get hideScreenHintText;

  /// Text where the mysterious word is indicated
  ///
  /// In en, this message translates to:
  /// **'The mystery word is\n\n{word}'**
  String mysteryWordText(String word);

  /// Text of the button to make a team win during the game
  ///
  /// In en, this message translates to:
  /// **'{team, select, green{Green} yellow{Yellow} other{null}} team wins'**
  String makeTeamWinButtonLabel(String team);

  /// No description provided for @tapToRevealText.
  ///
  /// In en, this message translates to:
  /// **'Tap to reveal it'**
  String get tapToRevealText;

  /// No description provided for @tapToHideText.
  ///
  /// In en, this message translates to:
  /// **'Tap to hide it'**
  String get tapToHideText;

  /// Text indicating that the mysterious word was hidden
  ///
  /// In en, this message translates to:
  /// **'Hidden word'**
  String get hiddenWordText;

  /// Text of the button to skip the round
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get drawButtonLabel;

  /// Text of the button to indicate that the word has been found
  ///
  /// In en, this message translates to:
  /// **'Word found!'**
  String get wordFoundButtonLabel;

  /// Title of the dialog used to pick who guessed the word
  ///
  /// In en, this message translates to:
  /// **'Word guessed by'**
  String get guessedByText;

  /// Title of the game setup screen
  ///
  /// In en, this message translates to:
  /// **'Choose how to play'**
  String get chooseModeText;

  /// Name of a game mode
  ///
  /// In en, this message translates to:
  /// **'{mode, select, classic{Classic} drinking{Drinking} dares{Dares} spicy{Spicy} other{-}}'**
  String modeName(String mode);

  /// Short description of a game mode
  ///
  /// In en, this message translates to:
  /// **'{mode, select, classic{The original game: just clues and complicity} drinking{Word stolen or a draw? Drink up! In moderation} dares{Word stolen or a draw? Time for a dare} spicy{Cheeky words and dares, for adults only} other{-}}'**
  String modeDescription(String mode);

  /// Label of the target score selector
  ///
  /// In en, this message translates to:
  /// **'Words to win'**
  String get wordsToWinText;

  /// The clue giver's team guessed the word
  ///
  /// In en, this message translates to:
  /// **'Point for the {team, select, green{green} yellow{yellow} other{-}} team!'**
  String roundPointText(String team);

  /// The opposing team guessed the word
  ///
  /// In en, this message translates to:
  /// **'Word stolen!\nPoint for the {team, select, green{green} yellow{yellow} other{-}} team'**
  String roundStolenText(String team);

  /// Nobody guessed the word
  ///
  /// In en, this message translates to:
  /// **'Draw!\nNobody scores'**
  String get roundDrawText;

  /// Reveals the word of the turn that just ended
  ///
  /// In en, this message translates to:
  /// **'The word was {word}'**
  String theWordWasText(String word);

  /// Drinking mode: one player drinks
  ///
  /// In en, this message translates to:
  /// **'{playerName} takes a sip'**
  String drinkPlayerText(String playerName);

  /// Drinking mode: a whole team drinks
  ///
  /// In en, this message translates to:
  /// **'The whole {team, select, green{green} yellow{yellow} other{-}} team takes a sip'**
  String drinkTeamText(String team);

  /// A number of sips
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 sip} other{{count} sips}}'**
  String sipsText(int count);

  /// Drinking mode: what the losing team drinks at the end
  ///
  /// In en, this message translates to:
  /// **'The {team, select, green{green} yellow{yellow} other{-}} team drinks {sips} each'**
  String drinkFinalText(String team, String sips);

  /// Title of the dare assigned to a player
  ///
  /// In en, this message translates to:
  /// **'Dare for {playerName}'**
  String dareForPlayerText(String playerName);

  /// Title of the dare assigned to the losing team
  ///
  /// In en, this message translates to:
  /// **'Dare for the {team, select, green{green} yellow{yellow} other{-}} team\n(the winners choose who does it)'**
  String dareForTeamText(String team);

  /// Announces the winning team
  ///
  /// In en, this message translates to:
  /// **'THE {team, select, green{GREEN} yellow{YELLOW} other{-}} TEAM WINS!'**
  String teamWinsText(String team);

  /// Text of the button to play again with the same teams
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgainButtonLabel;

  /// Text of the button to go back to the home screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeButtonLabel;

  /// Question asked before quitting a running game
  ///
  /// In en, this message translates to:
  /// **'Do you want to quit the game?'**
  String get exitGameText;

  /// Text of the button that confirms quitting the game
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get exitButtonLabel;

  /// No description provided for @addPlayerButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addPlayerButtonLabel;

  /// No description provided for @playButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playButtonLabel;

  /// No description provided for @playersTitle.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get playersTitle;

  /// No description provided for @saveButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButtonLabel;

  /// No description provided for @nextButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButtonLabel;

  /// No description provided for @showWordButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Show the word'**
  String get showWordButtonLabel;

  /// No description provided for @emptyTeamText.
  ///
  /// In en, this message translates to:
  /// **'No players yet'**
  String get emptyTeamText;

  /// No description provided for @newPlayerTitle.
  ///
  /// In en, this message translates to:
  /// **'New player'**
  String get newPlayerTitle;

  /// No description provided for @editPlayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit player'**
  String get editPlayerTitle;

  /// No description provided for @teamLabel.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get teamLabel;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
