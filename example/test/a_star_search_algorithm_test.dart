import 'package:example/infra/service/graph_service.dart';
import 'package:flutter/material.dart';
import 'package:osip_route_finder_dart/src/a_star_search_algorithm.dart';
import 'package:osip_route_finder_dart/src/search_request.dart';
import 'package:osip_route_finder_dart/src/utils/multi_graph.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  GraphService graphService = GraphService();
  
  MultiGraph graph = await graphService.getFullTransitsGraph();
  print(graph);
  
  SearchRequest searchRequest = SearchRequest(
    from: graph.randomNode,
    to: graph.randomNode,
  );
  
  print(searchRequest);
  
  AStarSearchAlgorithm aStarSearchAlgorithm = AStarSearchAlgorithm();
  aStarSearchAlgorithm.process(graph, searchRequest);
}