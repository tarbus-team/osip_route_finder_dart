import 'package:math_parser/math_parser.dart';
import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';
import 'package:osip_route_finder_dart/src/models/penalty_strategy/penalty_strategy.dart';
import 'package:osip_route_finder_dart/src/search_state.dart';

class WalkingDistancePenaltyStrategy implements PenaltyStrategy {
  final double guaranteedPenalty;
  final String penaltyFunction;

  const WalkingDistancePenaltyStrategy({
    this.guaranteedPenalty = 30,
    this.penaltyFunction = '(x/100)^2 + a',
  });

  @override
  double calcPenalty(SearchState searchState, TransitEdge transitEdge) {
    if (transitEdge is WalkEdge) {
      double x = transitEdge.distanceInMeters.toDouble();
      double a = guaranteedPenalty;

      double distancePenalty = MathNodeExpression.fromString(penaltyFunction, variableNames: const <String>{'x', 'a'})
          .calc(MathVariableValues(<String, double>{'x': x, 'a': a}))
          .toDouble();

      return distancePenalty;
    } else {
      return 0;
    }
  }
}