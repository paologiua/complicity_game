import 'package:flutter/material.dart';

import '../constants/theme.dart';

/// Opens [builder]'s content in a white sheet that slides up from the bottom,
/// stays above the keyboard and closes by swiping down or tapping outside.
Future<T?> showClaySheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: ThemeConstants.scrimColor,
    elevation: 0.0,
    builder: (BuildContext context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        child: Center(
          heightFactor: 1.0,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 390.0),
            margin: const EdgeInsets.all(12.0),
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
            decoration: ThemeConstants.clay(
              ThemeConstants.greyPrimaryColor,
              ThemeConstants.greySecondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(28.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44.0,
                  height: 5.0,
                  decoration: const BoxDecoration(
                    color: ThemeConstants.greySecondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  ),
                ),
                Flexible(child: builder(context)),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
