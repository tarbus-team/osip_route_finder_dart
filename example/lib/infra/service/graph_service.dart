import 'package:example/infra/entity/transit_edge_entity.dart';
import 'package:example/infra/entity/vehicle_edge_entity.dart';
import 'package:example/infra/entity/walk_edge_entity.dart';
import 'package:example/infra/repository/assets_edge_repository.dart';
import 'package:example/infra/service/stop_service.dart';
import 'package:osip_route_finder_dart/src/models/edge/transit_edge.dart';
import 'package:osip_route_finder_dart/src/models/node/stop_node.dart';
import 'package:osip_route_finder_dart/src/utils/multi_graph.dart';

class GraphService {
  final StopService stopService = StopService();
  final AssetsEdgeRepository edgeRepository = AssetsEdgeRepository();
  
  Future<MultiGraph> getFullTransitsGraph() async {
    MultiGraph graph = MultiGraph();
    List<StopNode> stopNodeList = await stopService.getAll();
    List<TransitEdge> transitEdgeList = await _getEdgesList(stopNodeList);
    
    graph.addNodeIterable(stopNodeList);
    graph.addEdgeIterable(transitEdgeList);
    
    return graph;
  }

  Future<List<TransitEdge>> _getEdgesList(List<StopNode> stopNodeList) async {
    List<TransitEdgeEntity> edgesEntityList = await edgeRepository.getAll();
    List<TransitEdge> transitEdgeList = List<TransitEdge>.empty(growable: true);
    for (TransitEdgeEntity transitEdgeEntity in edgesEntityList) {
      StopNode from = stopNodeList.where((StopNode e) => e.id == transitEdgeEntity.from.toString()).first;
      StopNode to = stopNodeList.where((StopNode e) => e.id == transitEdgeEntity.to.toString()).first;
      
      switch(transitEdgeEntity.runtimeType) {
        case VehicleEdgeEntity:
          VehicleEdgeEntity vehicleEdgeEntity = transitEdgeEntity as VehicleEdgeEntity;
          int timeFromNow = vehicleEdgeEntity.departureTimeInMin;
          if( timeFromNow >= 0 ) {
            transitEdgeList.add(vehicleEdgeEntity.toModel(from, to));
          }
          break;
        case WalkEdgeEntity:
          WalkEdgeEntity walkEdgeEntity = transitEdgeEntity as WalkEdgeEntity;
          transitEdgeList.add(walkEdgeEntity.toModel(from, to));
          break;  
        default:
          throw Exception('Unknown TransitEdgeEntity type');
      }
    }
    return transitEdgeList;
  }
}