// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get gameRulesPart1 =>
      'Complicity Game is a group game. You need to divide the participants into two teams composed of people with a great sense of mutual complicity';

  @override
  String get gameRulesPart2 =>
      'At each turn the game chooses a word and a participant. The latter, through clues, will have to get their team to guess the word rather than the opposing team';

  @override
  String get gameRulesPart3 =>
      'The first team to guess the chosen number of words wins (usually five)';

  @override
  String get enterParticipantsNamesText =>
      'Enter at least two participants per team';

  @override
  String get gameRulesButtonLabel => 'Game rules';

  @override
  String get startGameButtonLabel => 'Start game';

  @override
  String get deleteButtonLabel => 'Delete';

  @override
  String get cancelButtonLabel => 'Cancel';

  @override
  String get playerNameHintText => 'Player name';

  @override
  String get greenTeamText => 'Green team';

  @override
  String get yellowTeamText => 'Yellow team';

  @override
  String hideScreenText(String playerName, String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'GREEN TEAM',
        'yellow': 'YELLOW TEAM',
        'other': 'NULL',
      },
    );
    return '$playerName\n($_temp0)\n\nhides the screen from other players';
  }

  @override
  String mysteryWordText(String word) {
    return 'The mystery word is\n\n$word';
  }

  @override
  String makeTeamWinButtonLabel(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'Green',
        'yellow': 'Yellow',
        'other': 'null',
      },
    );
    return '$_temp0 team wins';
  }

  @override
  String get tapToRevealText => 'Tap to reveal it';

  @override
  String get tapToHideText => 'Tap to hide it';

  @override
  String get hiddenWordText => 'Hidden word';

  @override
  String get drawButtonLabel => 'Draw';

  @override
  String get wordFoundButtonLabel => 'Word found!';

  @override
  String get guessedByText => 'Word guessed by';

  @override
  String get chooseModeText => 'Choose how to play';

  @override
  String modeName(String mode) {
    String _temp0 = intl.Intl.selectLogic(
      mode,
      {
        'classic': 'Classic',
        'drinking': 'Drinking',
        'dares': 'Dares',
        'spicy': 'Spicy',
        'other': '-',
      },
    );
    return '$_temp0';
  }

  @override
  String modeDescription(String mode) {
    String _temp0 = intl.Intl.selectLogic(
      mode,
      {
        'classic': 'The original game: just clues and complicity',
        'drinking': 'Word stolen or a draw? Drink up! In moderation',
        'dares': 'Word stolen or a draw? Time for a dare',
        'spicy': 'Cheeky dares, for adults only',
        'other': '-',
      },
    );
    return '$_temp0';
  }

  @override
  String get wordsToWinText => 'Words to win';

  @override
  String roundPointText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'green',
        'yellow': 'yellow',
        'other': '-',
      },
    );
    return 'Point for the $_temp0 team!';
  }

  @override
  String roundStolenText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'green',
        'yellow': 'yellow',
        'other': '-',
      },
    );
    return 'Word stolen!\nPoint for the $_temp0 team';
  }

  @override
  String get roundDrawText => 'Draw!\nNobody scores';

  @override
  String theWordWasText(String word) {
    return 'The word was $word';
  }

  @override
  String drinkPlayerText(String playerName) {
    return '$playerName takes a sip';
  }

  @override
  String drinkTeamText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'green',
        'yellow': 'yellow',
        'other': '-',
      },
    );
    return 'The whole $_temp0 team takes a sip';
  }

  @override
  String sipsText(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sips',
      one: '1 sip',
    );
    return '$_temp0';
  }

  @override
  String drinkFinalText(String team, String sips) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'green',
        'yellow': 'yellow',
        'other': '-',
      },
    );
    return 'The $_temp0 team drinks $sips each';
  }

  @override
  String dareForPlayerText(String playerName) {
    return 'Dare for $playerName';
  }

  @override
  String dareForTeamText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'green',
        'yellow': 'yellow',
        'other': '-',
      },
    );
    return 'Dare for the $_temp0 team\n(the winners choose who does it)';
  }

  @override
  String teamWinsText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'GREEN',
        'yellow': 'YELLOW',
        'other': '-',
      },
    );
    return 'THE $_temp0 TEAM WINS!';
  }

  @override
  String get playAgainButtonLabel => 'Play again';

  @override
  String get homeButtonLabel => 'Home';

  @override
  String get exitGameText => 'Do you want to quit the game?';

  @override
  String get exitButtonLabel => 'Quit';

  @override
  String get addPlayerButtonLabel => 'Add';

  @override
  String get playButtonLabel => 'Play';

  @override
  String get playersTitle => 'Players';

  @override
  String get saveButtonLabel => 'Save';

  @override
  String get nextButtonLabel => 'Next';

  @override
  String get showWordButtonLabel => 'Show the word';

  @override
  String get emptyTeamText => 'No players yet';

  @override
  String get newPlayerTitle => 'New player';

  @override
  String get editPlayerTitle => 'Edit player';

  @override
  String get teamLabel => 'Team';

  @override
  String get nameLabel => 'Name';
}
