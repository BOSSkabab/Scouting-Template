import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/id_providers.dart";
import "package:scouting_frontend/models/input_view_vars.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/input_view.dart";

class EditTechnicalMatch extends StatelessWidget {
  const EditTechnicalMatch({
    required this.matchIdentifier,
    required this.teamForQuery,
  });
  final MatchIdentifier matchIdentifier;
  final LightTeam teamForQuery;

  @override
  Widget build(final BuildContext context) => isPC(context)
      ? DashboardScaffold(body: editTechnicalMatch(context))
      : Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "${matchIdentifier.type} ${matchIdentifier.number}, team ${teamForQuery.number}",
            ),
          ),
          body: editTechnicalMatch(context),
        );
  FutureBuilder<InputViewVars> editTechnicalMatch(final BuildContext context) =>
      FutureBuilder<InputViewVars>(
        future: fetchTechnicalMatch(matchIdentifier, teamForQuery, context),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<InputViewVars> snapshot,
        ) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return UserInput(snapshot.data);
          }
        },
      );
}

//TODO add new query here
const String query = """

""";

Future<InputViewVars> fetchTechnicalMatch(
  final MatchIdentifier matchIdentifier,
  final LightTeam teamForQuery,
  final BuildContext context,
) async {
  final GraphQLClient client = getClient();

  final QueryResult<InputViewVars> result = await client.query(
    QueryOptions<InputViewVars>(
      //TODO add json parsing and create a Match containing the data
      parserFn: (final Map<String, dynamic> technicalMatch) =>
          InputViewVars(context),
      document: gql(query),
      variables: <String, dynamic>{
        "team_id": teamForQuery.id,
        "match_type_id": IdProvider.of(context)
            .matchType
            .nameToId[matchIdentifier.type.title],
        "match_number": matchIdentifier.number,
        "is_rematch": matchIdentifier.isRematch,
      },
    ),
  );
  return result.mapQueryResult();
}
