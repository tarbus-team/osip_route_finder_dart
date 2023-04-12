import 'package:equatable/equatable.dart';
import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';
import 'package:osip_route_finder_dart/src/models/penalty_strategy/penalty_strategy.dart';

class SearchState extends Equatable {
  final int currentTimeInMin;
  final int stepWaitingTime;
  final double currentWeight;
  final Duration stepDuration;
  final SearchRequest searchRequest;
  final TransitNode node;
  final TransitEdge? edge;
  final SearchState? backState;

  const SearchState._({
    required this.currentTimeInMin,
    required this.stepWaitingTime,
    required this.stepDuration,
    required this.searchRequest,
    required this.currentWeight,
    required this.node,
    required this.edge,
    this.backState,
  });

  factory SearchState.initial({
    required TransitNode node,
    required SearchRequest searchRequest,
  }) {

    return SearchState._(
      currentTimeInMin: searchRequest.startTimeMin,
      stepWaitingTime: 0,
      stepDuration: const Duration(minutes: 0),
      searchRequest: searchRequest,
      currentWeight: 0,
      node: node,
      backState: null,
      edge: null,
    );
  }
  
  SearchState nextState({
    required TransitEdge edge,
    required List<PenaltyStrategy> penaltyStrategies,
  }) {
    final double penalty = penaltyStrategies.fold(0, (double prev, PenaltyStrategy strategy) => prev + strategy.calcPenalty(this, edge));
    final Duration totalDuration = edge.getTotalDuration(this);
    
    final int nextTime = currentTimeInMin + totalDuration.inMinutes;
    final double nextWeight = currentWeight + totalDuration.inMinutes + penalty;
    
    int waitingTime = 0;
    if( edge is VehicleEdge ) {
      waitingTime = edge.departureTimeInMin - currentTimeInMin;
    }
    
    
    return SearchState._(
      currentTimeInMin: nextTime,
      stepWaitingTime: waitingTime,
      stepDuration: totalDuration,
      searchRequest: searchRequest,
      currentWeight: nextWeight,
      node: edge.to,
      edge: edge,
      backState: this,
    );
  }
  
  
  DateTime get arrivalTime {
    return searchRequest.dateTime.copyWith(hour: currentTimeInMin ~/ 60, minute: currentTimeInMin % 60);
  }
  
  DateTime get departureTime {
    int departureTimeMin = edge?.getDepartureTimeInMin(this) ?? -1;
    if( departureTimeMin == -1 ) {
      return arrivalTime;
    } else {
      return searchRequest.dateTime.copyWith(hour: departureTimeMin ~/ 60, minute: departureTimeMin % 60);
    }
  }

  DateTime get endTime {
    int tripTimeInMin = edge?.getTripTimeInMin(this) ?? 0;
    return departureTime.add(Duration(minutes: tripTimeInMin));
  }
  
  List<String> get path {
    return [edge.toString(), ...backState?.path ?? []];
  }
  
  @override
  List<Object?> get props => [currentTimeInMin, searchRequest, currentWeight, node, edge, backState];
}
