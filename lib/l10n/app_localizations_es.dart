// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get gameRulesPart1 =>
      'El Juego de la Complicidad es un juego de grupo. Tienes que dividir a los participantes en dos equipos compuestos por personas con un gran sentido de la complicidad mutua';

  @override
  String get gameRulesPart2 =>
      'En cada turno, el juego elige una palabra y un participante. Éste, mediante pistas, tendrá que conseguir que su equipo adivine la palabra y no el equipo contrario';

  @override
  String get gameRulesPart3 =>
      'Gana el equipo que adivine primero el número de palabras elegido (normalmente cinco)';

  @override
  String get enterParticipantsNamesText =>
      'Inscriba al menos a dos participantes por equipo';

  @override
  String get gameRulesButtonLabel => 'Reglas del juego';

  @override
  String get startGameButtonLabel => 'Iniciar una partida';

  @override
  String get deleteButtonLabel => 'Eliminar';

  @override
  String get cancelButtonLabel => 'Cancelar';

  @override
  String get playerNameHintText => 'Nombre del jugador';

  @override
  String get greenTeamText => 'Equipo verde';

  @override
  String get yellowTeamText => 'Equipo amarillo';

  @override
  String hideScreenText(String playerName, String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'EQUIPO VERDE',
        'yellow': 'EQUIPO AMARILLO',
        'other': 'NULL',
      },
    );
    return '$playerName\n($_temp0)\n\noculta la pantalla a otros jugadores';
  }

  @override
  String mysteryWordText(String word) {
    return 'La palabra secreta es\n\n$word';
  }

  @override
  String makeTeamWinButtonLabel(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'verde',
        'yellow': 'amarillo',
        'other': 'null',
      },
    );
    return 'Equipo $_temp0 gana';
  }

  @override
  String get hiddenWordText => 'Palabra oculta';

  @override
  String get drawButtonLabel => 'Empate';

  @override
  String get wordFoundButtonLabel => '¡Palabra encontrada!';

  @override
  String get guessedByText => 'Palabra adivinada por';

  @override
  String get chooseModeText => 'Elige cómo jugar';

  @override
  String modeName(String mode) {
    String _temp0 = intl.Intl.selectLogic(
      mode,
      {
        'classic': 'Clásica',
        'drinking': 'Alcohólica',
        'dares': 'Penitencias',
        'spicy': 'Picante',
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
        'classic': 'El juego original: solo pistas y complicidad',
        'drinking': '¿Palabra robada o empate? ¡A beber! Con moderación',
        'dares': '¿Palabra robada o empate? Toca penitencia',
        'spicy': 'Penitencias pícaras, solo para adultos',
        'other': '-',
      },
    );
    return '$_temp0';
  }

  @override
  String get wordsToWinText => 'Palabras para ganar';

  @override
  String roundPointText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'verde',
        'yellow': 'amarillo',
        'other': '-',
      },
    );
    return '¡Punto para el equipo $_temp0!';
  }

  @override
  String roundStolenText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'verde',
        'yellow': 'amarillo',
        'other': '-',
      },
    );
    return '¡Palabra robada!\nPunto para el equipo $_temp0';
  }

  @override
  String get roundDrawText => '¡Empate!\nNadie puntúa';

  @override
  String theWordWasText(String word) {
    return 'La palabra era $word';
  }

  @override
  String drinkPlayerText(String playerName) {
    return '$playerName bebe un trago';
  }

  @override
  String drinkTeamText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'verde',
        'yellow': 'amarillo',
        'other': '-',
      },
    );
    return 'Todo el equipo $_temp0 bebe un trago';
  }

  @override
  String sipsText(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tragos',
      one: '1 trago',
    );
    return '$_temp0';
  }

  @override
  String drinkFinalText(String team, String sips) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'verde',
        'yellow': 'amarillo',
        'other': '-',
      },
    );
    return 'El equipo $_temp0 bebe $sips por persona';
  }

  @override
  String dareForPlayerText(String playerName) {
    return 'Penitencia para $playerName';
  }

  @override
  String dareForTeamText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'verde',
        'yellow': 'amarillo',
        'other': '-',
      },
    );
    return 'Penitencia para el equipo $_temp0\n(los ganadores eligen quién la hace)';
  }

  @override
  String teamWinsText(String team) {
    String _temp0 = intl.Intl.selectLogic(
      team,
      {
        'green': 'VERDE',
        'yellow': 'AMARILLO',
        'other': '-',
      },
    );
    return '¡EL EQUIPO $_temp0 GANA!';
  }

  @override
  String get playAgainButtonLabel => 'Jugar otra vez';

  @override
  String get homeButtonLabel => 'Inicio';

  @override
  String get exitGameText => '¿Quieres abandonar la partida?';

  @override
  String get exitButtonLabel => 'Salir';

  @override
  String get addPlayerButtonLabel => 'Añadir';

  @override
  String get playButtonLabel => 'Jugar';
}
