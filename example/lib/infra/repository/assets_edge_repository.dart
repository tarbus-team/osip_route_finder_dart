import 'dart:convert';

import 'package:example/infra/entity/transit_edge_entity.dart';
import 'package:example/infra/entity/vehicle_edge_entity.dart';
import 'package:example/infra/entity/walk_edge_entity.dart';
import 'package:example/utils/file_utils.dart';

class AssetsEdgeRepository {
  Future<List<TransitEdgeEntity>> getAll() async {
    String assetsEdges = await FileUtils.readAssetFile('edges.json');
    List<dynamic> edgesMap = jsonDecode(assetsEdges) as List<dynamic>;

    List<TransitEdgeEntity> transitEdgesEntity = edgesMap.map((dynamic e) {
      Map<String, dynamic> edgeMap = e as Map<String, dynamic>;
      if(edgeMap['type'] == 'walk') {
        return WalkEdgeEntity.fromJson(edgeMap);
      } else if(edgeMap['type'] == 'vehicle') {
        return VehicleEdgeEntity.fromAssetsJson(edgeMap);
      } else {
        throw Exception('Unknown TransitEdgeEntity type');
      }
    }).toList();
    
    print('ALL EDGES COUNT: ${transitEdgesEntity.length}');
    return transitEdgesEntity;
  }
}
