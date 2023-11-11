import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../constants/icons.dart';
import '../models/player_model.dart';
import '../services/game_service.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/pill.dart';
import '../widgets/size_measurer.dart';

class GameProgressScreen extends StatefulWidget {
  const GameProgressScreen({super.key});

  @override
  State<GameProgressScreen> createState() => _GameProgressScreenState();
}

class _GameProgressScreenState extends State<GameProgressScreen> {
  late GameService _gameService;
  bool _hiddenWord = false;
  double _popupHeight = 0.0;

  @override
  void initState() {
    _gameService = context.read<GameService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      children: [
        Align(
          alignment: Alignment.center,
          child: Hero(
            tag: "popup",
            child: Container(
              padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
              decoration: const BoxDecoration(
                color: ThemeConstants.blueDarkColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(ThemeConstants.defaultBorderRadius * 3),
                ),
              ),
              child: Wrap(
                clipBehavior: Clip.hardEdge,
                runSpacing: ThemeConstants.defaultPadding,
                children: [
                  Pill(
                    color: ThemeConstants.greenPrimaryColor,
                    borderColor: ThemeConstants.greenSecondaryColor,
                    icon: IconsConstants.cognition,
                    text: AppLocalizations.of(context)!.makeTeamWinButtonLabel(
                      Team.green.name,
                    ),
                    direction: Axis.horizontal,
                    onTap: () => win(Team.green),
                  ),
                  _hiddenWord
                      ? Pill(
                          color: ThemeConstants.defaultTextColor,
                          borderColor: const Color(0xFF3F3C45),
                          child: SizedBox(
                            height: _popupHeight -
                                2 * ThemeConstants.defaultBorder -
                                2 * ThemeConstants.defaultPadding,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.hide_source_rounded,
                                  size: ThemeConstants.defaultIconSize,
                                  color: Color(0xFFFFFFFF),
                                ),
                                const SizedBox(
                                  height: ThemeConstants.defaultPadding,
                                  width: ThemeConstants.defaultPadding,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.hiddenWordText,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                ),
                                const SizedBox(
                                  height: ThemeConstants.defaultPadding,
                                  width: ThemeConstants.defaultPadding,
                                ),
                                RichText(
                                  text: TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: const Color(0xFFFFFFFF),
                                            fontSize: 23,
                                          ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              "${_gameService.state.getScore(Team.yellow)}",
                                          style: const TextStyle(
                                            color: ThemeConstants
                                                .yellowSecondaryColor,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' - ',
                                        ),
                                        TextSpan(
                                          text:
                                              "${_gameService.state.getScore(Team.green)}",
                                          style: const TextStyle(
                                            color: ThemeConstants
                                                .greenSecondaryColor,
                                          ),
                                        ),
                                      ]),
                                )
                              ],
                            ),
                          ),
                          onTap: () => setState(() {
                            _hiddenWord = false;
                          }),
                        )
                      : SizeMeasurer(
                          onChange: (Size size) => setState(() {
                            _popupHeight = size.height;
                          }),
                          child: Pill(
                            color: ThemeConstants.greyPrimaryColor,
                            borderColor: ThemeConstants.greySecondaryColor,
                            icon: Icons.cookie_outlined,
                            text: AppLocalizations.of(context)!.mysteryWordText(
                              _gameService.state.getWord().toUpperCase(),
                            ),
                            onTap: () => setState(() {
                              _hiddenWord = true;
                            }),
                          ),
                        ),
                  Pill(
                    color: ThemeConstants.yellowPrimaryColor,
                    borderColor: ThemeConstants.yellowSecondaryColor,
                    icon: IconsConstants.emojiObjects,
                    text: AppLocalizations.of(context)!.makeTeamWinButtonLabel(
                      Team.yellow.name,
                    ),
                    direction: Axis.horizontal,
                    onTap: () => win(Team.yellow),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void win(Team team) {
    _gameService.state.win(team);

    Navigator.pushNamed(
      context,
      "/game/start",
    );
  }
}
