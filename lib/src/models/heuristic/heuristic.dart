import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';

abstract class Heuristic {
  double calc(TransitNode a, TransitNode b);
}