import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_id_enum.dart";
import "package:scouting_frontend/models/enums/auto_gamepiece_state_enum.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/autonomous/auto_gamepieces.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/autonomous/autonomous_gamepiece_card.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/input_view_vars.dart";

class AutonomousSelector extends StatelessWidget {
  const AutonomousSelector({
    super.key,
    required this.match,
    required this.onNewMatch,
    this.isRedAlliance = false,
  });

  final InputViewVars match;
  final void Function(InputViewVars) onNewMatch;
  final bool isRedAlliance;

  @override
  Widget build(final BuildContext context) {
    final Map<AutoGamepieceID, AutoGamepieceState> gamepieces =
        match.autoGamepieces.asMap;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        2,
        (final int index) => Expanded(
          child: Column(
            children: gamepieces.keys
                .where(
                  (final AutoGamepieceID element) =>
                      (element.title.characters.first == "L" &&
                          index == (isRedAlliance ? 0 : 1)) ||
                      (element.title.characters.first == "M" &&
                          index == (isRedAlliance ? 1 : 0)),
                )
                .map(
                  (final AutoGamepieceID gamepieceId) => AutonomousGamepiece(
                    color: getColorByState(
                        gamepieces[gamepieceId] ?? AutoGamepieceState.noAttempt,
                        isRedAlliance),
                    state: gamepieces[gamepieceId]!,
                    gamepieceID: gamepieceId,
                    onSelectedStateOfGamepiece:
                        (final AutoGamepieceState state) {
                      gamepieces[gamepieceId] = state;
                      onNewMatch(
                        match.copyWith(
                          autoGamepieces: () =>
                              AutoGamepieces.fromMap(gamepieces),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

Color getColorByState(AutoGamepieceState gamepieceState, bool isRed) {
  switch (gamepieceState) {
    case AutoGamepieceState.noAttempt:
      return Colors.grey;
    case AutoGamepieceState.scoredSpeaker:
      return Colors.green;
    case AutoGamepieceState.missedSpeaker:
      return Colors.amber;
    case AutoGamepieceState.notTaken:
      return Colors.red;
  }
}
