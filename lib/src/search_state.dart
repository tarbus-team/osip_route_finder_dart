import 'package:equatable/equatable.dart';
import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';
import 'package:osip_route_finder_dart/src/models/edge/transit_edge.dart';
import 'package:osip_route_finder_dart/src/models/node/transit_node.dart';
import 'package:osip_route_finder_dart/src/models/penalty_strategy/penalty_strategy.dart';

class SearchState extends Equatable {
  // the current time at this state, in seconds since UNIX epoch
  final int time;
  final SearchRequest searchRequest;

  // accumulated weight up to this state
  final double weight;

  // associate this state with a vertex in the graph
  final TransitNode node;
  
  final TransitEdge? previousEdge;

  // allow path reconstruction from states
  final SearchState? backState;
  
  factory SearchState.initial({
    required TransitNode node,
    required SearchRequest searchRequest,
  }) {
    
    return SearchState._(
      time: searchRequest.startTimeMin,
      searchRequest: searchRequest,
      weight: 0,
      node: node,
      backState: null,
      previousEdge: null,
    );
  }

  const SearchState._({
    required this.time,
    required this.searchRequest,
    required this.weight,
    required this.node,
    required this.previousEdge,
    this.backState,
  });
  
  SearchState nextState({
    required TransitEdge edge,
    required List<PenaltyStrategy> penaltyStrategies,
  }) {
    final double penalty = penaltyStrategies.fold(0, (double prev, PenaltyStrategy strategy) => prev + strategy.calcPenalty(this, edge));
    final Duration totalDuration = edge.getTotalDuration(this);
    
    final int nextTime = time + totalDuration.inMinutes;
    final double nextWeight = weight + totalDuration.inMinutes + penalty;
    
    
    return SearchState._(
      time: nextTime,
      searchRequest: searchRequest,
      weight: nextWeight,
      node: edge.to,
      previousEdge: edge,
      backState: this,
    );
  }
  
  List<String> get path {
    return [previousEdge.toString(), ...backState?.path ?? []];
  }
  
  @override
  String toString() {
    if( previousEdge is WalkEdge ) {
      return 'WALK $time, $weight, ${previousEdge?.from.name} -> ${previousEdge?.to.name}';
    } else {
      return 'BUS  $time, $weight, ${previousEdge?.from.name} -> ${previousEdge?.to.name}';
    }
  }
  
  @override
  List<Object?> get props => [time, searchRequest, weight, node, previousEdge, backState];
}
