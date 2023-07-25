import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.blueSecondaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: ThemeConstants.bluePrimaryColor,
            border: Border.all(
              color: ThemeConstants.blueSecondaryColor,
              style: BorderStyle.solid,
              width: ThemeConstants.defaultBorder,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Hero(
                    tag: "logo",
                    child: Container(
                      padding:
                          const EdgeInsets.all(ThemeConstants.defaultPadding),
                      constraints: const BoxConstraints(
                        maxWidth: ThemeConstants.defaultMaxWidth,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/splash-icon.svg',
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 84.0,
                      child: FloatingActionButton.extended(
                        backgroundColor: Colors.white,
                        onPressed: () => Navigator.pushNamed(context, "/game_rules/1"),
                        icon: Icon(Icons.emoji_objects_outlined, color: ThemeConstants.defaultTextStyle.color, size: ThemeConstants.defaultIconSize,),
                        label: const Text(
                          "Regole del gioco",
                          style: ThemeConstants.defaultTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
