import 'package:osip_route_finder_dart/src/a_start_search_result.dart';
import 'package:osip_route_finder_dart/src/models/heuristic/haversine_heuristic.dart';
import 'package:osip_route_finder_dart/src/models/heuristic/heuristic.dart';
import 'package:osip_route_finder_dart/src/models/penalty_strategy/penalty_strategy.dart';
import 'package:osip_route_finder_dart/src/models/penalty_strategy/transfer_penalty_strategy.dart';
import 'package:osip_route_finder_dart/src/models/penalty_strategy/walking_distance_penalty_strategy.dart';
import 'package:osip_route_finder_dart/src/search_algorithm.dart';
import 'package:osip_route_finder_dart/src/search_request.dart';
import 'package:osip_route_finder_dart/src/search_state.dart';
import 'package:osip_route_finder_dart/src/skip_edge_strategy.dart';
import 'package:osip_route_finder_dart/src/models/edge/transit_edge.dart';
import 'package:osip_route_finder_dart/src/models/node/transit_node.dart';
import 'package:osip_route_finder_dart/src/utils/multi_graph.dart';
import 'package:osip_route_finder_dart/src/utils/priority_queue.dart';

class AStarSearchAlgorithm implements SearchAlgorithm {
  @override
  Future<AStarSearchResult> process(MultiGraph graph, SearchRequest searchRequest) async {
    return _AStarSearchEngine(
      graph: graph,
      searchRequest: searchRequest,
      from: searchRequest.from,
      to: searchRequest.to,
    ).process();
  }
}

class _AStarSearchEngine {
  final MultiGraph graph;
  final SearchRequest searchRequest;
  final TransitNode from;
  final TransitNode to;
  final Map<TransitNode, double> weightTable;
  final PriorityQueue<SearchState> queue;
  final SkipEdgeStrategy? skipEdgeStrategy;
  final Heuristic heuristic;
  final List<PenaltyStrategy> penaltyStrategies;

  _AStarSearchEngine({
    required this.graph,
    required this.searchRequest,
    required this.from,
    required this.to,
    this.skipEdgeStrategy = const DefaultSkipEdgeStrategy(),
    this.heuristic = const HaversineHeuristic(),
    List<PenaltyStrategy>? penaltyStrategies,
  })  : weightTable = {},
        penaltyStrategies = penaltyStrategies ?? const [TransferPenaltyStrategy(), WalkingDistancePenaltyStrategy()],
        queue = PriorityQueue<SearchState>();

  AStarSearchResult process() {
    SearchState initialSearchState = SearchState.initial(node: from, searchRequest: searchRequest);
    queue.add(initialSearchState, 0);
    weightTable[from] = 0;

    SearchState? searchState;

    while (queue.isNotEmpty) {
      SearchState currentState = queue.pop().value;

      if (currentState.node == to) {
        searchState = currentState;
        break;
      }

      for (TransitEdge transitEdge in graph.getEdgesForState(currentState)) {
        bool shouldSkipEdge = skipEdgeStrategy?.shouldSkipEdge(currentState, transitEdge) ?? false;
        if (shouldSkipEdge) {
          continue;
        }

        SearchState nextState = currentState.nextState(edge: transitEdge, penaltyStrategies: penaltyStrategies);
        double previousWeight = weightTable[nextState.node] ?? double.infinity;
        double currentWeight = nextState.currentWeight + heuristic.calc(currentState.node, to);

        bool firstNeighborVisit = weightTable.containsKey(nextState.node) == false;
        bool hasBetterCost = currentWeight < previousWeight;

        if (firstNeighborVisit || hasBetterCost) {
          weightTable[nextState.node] = currentWeight;
          queue.add(nextState, currentWeight);
        }
      }
    }
    if (searchState == null) {
      throw Exception("No path found");
    } else {
      return AStarSearchResult.constructFromSearchState(searchState);
    }
  }
}
