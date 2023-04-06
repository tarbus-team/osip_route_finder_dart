import 'package:osip_route_finder_dart/src/search_state.dart';
import 'package:osip_route_finder_dart/src/models/edge/transit_edge.dart';
import 'package:osip_route_finder_dart/src/models/node/transit_node.dart';

class MultiGraph {
  final Map<TransitNode, Map<TransitNode, List<TransitEdge>>> adjacencyList = <TransitNode, Map<TransitNode, List<TransitEdge>>>{};

  void addVertex(TransitNode node) {
    adjacencyList[node] = <TransitNode, List<TransitEdge>>{};
  }

  void addNodeIterable(Iterable<TransitNode> vertices) {
    vertices.forEach(addVertex);
  }

  void addEdge(TransitEdge transitEdge) {
    adjacencyList.putIfAbsent(transitEdge.from, () => <TransitNode, List<TransitEdge>>{});
    adjacencyList[transitEdge.from]!.putIfAbsent(transitEdge.to, () => <TransitEdge>[]);
    adjacencyList[transitEdge.from]![transitEdge.to]!.add(transitEdge);
  }

  void addEdgeIterable(Iterable<TransitEdge> transitEdges) {
    transitEdges.forEach(addEdge);
  }

  List<TransitEdge> getEdgesForState(SearchState state) {
    Map<TransitNode, List<TransitEdge>>? nodeConnections = adjacencyList[state.node];
    if (nodeConnections == null) {
      return <TransitEdge>[];
    }
    return nodeConnections.values.expand((List<TransitEdge> edges) => edges).toList();
  }

  Map<TransitNode, List<TransitEdge>> operator [](TransitNode node) => adjacencyList[node] ?? <TransitNode, List<TransitEdge>>{};

  List<TransitNode> get keys => adjacencyList.keys.toList();

  List<TransitEdge> get edges {
    final Set<TransitEdge> result = <TransitEdge>{};
    for (Map<TransitNode, List<TransitEdge>> value in adjacencyList.values) {
      for (List<TransitEdge> value in value.values) {
        result.addAll(value);
      }
    }
    return result.toList();
  }

  TransitNode get randomNode {
    List<TransitNode> nodes = keys;
    nodes.shuffle();
    return nodes.first;
  }
}
