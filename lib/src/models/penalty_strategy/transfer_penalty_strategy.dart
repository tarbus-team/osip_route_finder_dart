import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';
import 'package:osip_route_finder_dart/src/models/penalty_strategy/penalty_strategy.dart';
import 'package:osip_route_finder_dart/src/search_state.dart';

class TransferPenaltyStrategy implements PenaltyStrategy {
  final double guaranteedPenalty;

  const TransferPenaltyStrategy({
    this.guaranteedPenalty = 30,
  });

  @override
  double calcPenalty(SearchState searchState, TransitEdge transitEdge) {
    double penalty = 0;

    if(searchState.previousEdge is VehicleEdge && transitEdge is VehicleEdge) {
      VehicleEdge previousVehicleEdge = searchState.previousEdge as VehicleEdge;
      VehicleEdge currentVehicleEdge = transitEdge;
      penalty = previousVehicleEdge.trackId != currentVehicleEdge.trackId ? guaranteedPenalty : 0;
    }

    return penalty;
  }
}