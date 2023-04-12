import 'package:example/bloc/search_cubit.dart';
import 'package:example/bloc/search_result_state.dart';
import 'package:example/bloc/search_state.dart';
import 'package:example/views/app_layout.dart';
import 'package:example/views/map/graph_map.dart';
import 'package:example/views/map/stop_marker/stop_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppPage();
}

class _AppPage extends State<AppPage> {
  final SearchCubit searchCubit = SearchCubit();

  @override
  void initState() {
    super.initState();
    searchCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      bloc: searchCubit,
      builder: (BuildContext buildContext, SearchState state) {
        List<TransitNode> stopNodeList = state.multiGraph?.keys ?? [];

        return AppLayout(
          mapWidget: GraphMap(
              polylines: _getPolylines(state),
            markers: stopNodeList.map((TransitNode e) {
              return StopMarker(transitNode: e, onTap: () => searchCubit.setNode(e));
            }).toList(),
          ),
          menuWidget: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('From'),
                ListTile(
                  selected: state.nodeSelectType == NodeSelectType.from,
                  onTap: () => searchCubit.setNodeSelectType(NodeSelectType.from),
                  title: Text(state.from?.name ?? 'None'),
                  subtitle: Text(state.from?.id ?? 'None'),
                  leading: const Icon(Icons.location_on),
                ),
                const Text('To'),
                ListTile(
                  selected: state.nodeSelectType == NodeSelectType.to,
                  onTap: () => searchCubit.setNodeSelectType(NodeSelectType.to),
                  title: Text(state.to?.name ?? 'None'),
                  subtitle: Text(state.to?.id ?? 'None'),
                  leading: const Icon(Icons.location_on),
                ),
                ElevatedButton(
                  onPressed: () => searchCubit.search(),
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          consoleWidget: Container(
            color: Colors.black,
          ),
        );
      },
    );
  }
  
  List<Polyline> _getPolylines(SearchState state) {
    if( state is SearchResultState ) {
      AStarSearchResult aStarSearchResult = state.searchResult as AStarSearchResult;
      List<Polyline> polylines = aStarSearchResult.transitEdges.map((TransitEdge transitEdge) {
        List<LatLng> latLngList = List<LatLng>.empty(growable: true);
        for (String polyline in transitEdge.path) {
          latLngList.addAll(GoogleCoordsUtils.decodePolyline(polyline));
        }
        return Polyline(
          points: latLngList,
          strokeWidth: 5.0,
          color: transitEdge is WalkEdge ? Colors.red : _getUniqueColor((transitEdge as VehicleEdge).trackId),
          isDotted: transitEdge is WalkEdge,
        );
      }).toList();
      return polylines;
    } else {
      return <Polyline>[];
    }
  }
  
  Color _getUniqueColor(String value) {
    int hash = value.hashCode;
    int r = (hash & 0xFF0000) >> 16;
    int g = (hash & 0x00FF00) >> 8;
    int b = hash & 0x0000FF;
    
    return Color.fromARGB(255, r, g, b);
  }
}
