// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get gameRulesPart1 =>
      'Complicity Game è un gioco di gruppo. Occorre dividere i partecipanti in due squadre composte da persone con un grande senso di complicità reciproco';

  @override
  String get gameRulesPart2 =>
      'Ad ogni turno il gioco sceglie una parola e un partecipante. Quest’ultimo, tramite degli indizi, dovrà far indovinare la parola alla propria squadra piuttosto che a quella avversaria';

  @override
  String get gameRulesPart3 =>
      'Vince la squadra che indovina per prima il numero di parole scelto (di solito 5)';

  @override
  String get enterParticipantsNamesText =>
      'Inserisci almeno due partecipanti per squadra';

  @override
  String get gameRulesButtonLabel => 'Regole del gioco';

  @override
  String get startGameButtonLabel => 'Inizia una partita';

  @override
  String get deleteButtonLabel => 'Elimina';

  @override
  String get cancelButtonLabel => 'Annulla';

  @override
  String get playerNameHintText => 'Nome del giocatore';

  @override
  String get greenTeamText => 'Squadra verde';

  @override
  String get yellowTeamText => 'Squadra gialla';

  @override
  String hideScreenText(String playerName, String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'SQUADRA VERDE',
        'yellow': 'SQUADRA GIALLA',
        'other': 'NULL',
      },
    );
    return '$playerName\n($_temp0)\n\nnasconde lo schermo agli altri giocatori';
  }

  @override
  String mysteryWordText(String word) {
    return 'La parola segreta è\n\n$word';
  }

  @override
  String makeTeamWinButtonLabel(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'verde',
        'yellow': 'gialla',
        'other': 'null',
      },
    );
    return 'Squadra $_temp0 vince';
  }

  @override
  String get hiddenWordText => 'Parola nascosta';

  @override
  String get drawButtonLabel => 'Patta';

  @override
  String get wordFoundButtonLabel => 'Parola trovata!';

  @override
  String get guessedByText => 'Parola indovinata da';

  @override
  String get chooseModeText => 'Scegli come giocare';

  @override
  String modeName(String mode) {
    String _temp0 = intl.Intl.selectLogic(
      mode,
      {
        'classic': 'Classica',
        'drinking': 'Alcolica',
        'dares': 'Penitenze',
        'spicy': 'Piccante',
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
        'classic': 'Il gioco originale: solo indizi e complicità',
        'drinking': 'Parola rubata o patta? Si beve! Con moderazione',
        'dares': 'Parola rubata o patta? Scatta la penitenza',
        'spicy': 'Penitenze maliziose, solo per adulti',
        'other': '-',
      },
    );
    return '$_temp0';
  }

  @override
  String get wordsToWinText => 'Parole per vincere';

  @override
  String roundPointText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'verde',
        'yellow': 'gialla',
        'other': '-',
      },
    );
    return 'Punto alla squadra $_temp0!';
  }

  @override
  String roundStolenText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'verde',
        'yellow': 'gialla',
        'other': '-',
      },
    );
    return 'Parola rubata!\nPunto alla squadra $_temp0';
  }

  @override
  String get roundDrawText => 'Patta!\nNessun punto';

  @override
  String theWordWasText(String word) {
    return 'La parola era $word';
  }

  @override
  String drinkPlayerText(String playerName) {
    return '$playerName beve un sorso';
  }

  @override
  String drinkTeamText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'verde',
        'yellow': 'gialla',
        'other': '-',
      },
    );
    return 'Tutta la squadra $_temp0 beve un sorso';
  }

  @override
  String sipsText(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sorsi',
      one: '1 sorso',
    );
    return '$_temp0';
  }

  @override
  String drinkFinalText(String team, String sips) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'verde',
        'yellow': 'gialla',
        'other': '-',
      },
    );
    return 'La squadra $_temp0 beve $sips a testa';
  }

  @override
  String dareForPlayerText(String playerName) {
    return 'Penitenza per $playerName';
  }

  @override
  String dareForTeamText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'verde',
        'yellow': 'gialla',
        'other': '-',
      },
    );
    return 'Penitenza per la squadra $_temp0\n(i vincitori scelgono chi la fa)';
  }

  @override
  String teamWinsText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'VERDE',
        'yellow': 'GIALLA',
        'other': '-',
      },
    );
    return 'LA SQUADRA $_temp0 VINCE!';
  }

  @override
  String get playAgainButtonLabel => 'Gioca ancora';

  @override
  String get homeButtonLabel => 'Home';

  @override
  String get exitGameText => 'Vuoi abbandonare la partita?';

  @override
  String get exitButtonLabel => 'Esci';
}
