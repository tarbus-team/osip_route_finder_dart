import 'package:osip_route_finder_dart/src/search_request.dart';
import 'package:osip_route_finder_dart/src/utils/multi_graph.dart';

abstract class SearchAlgorithm {
  Future<void> process(MultiGraph graph, SearchRequest searchRequest);
}