import 'package:flutter/material.dart';
import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';

class StopMarkerWidget extends StatelessWidget {
  final TransitNode transitNode;
  final VoidCallback onTap;

  const StopMarkerWidget({
    required this.transitNode,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.location_on),
    );
  }
}
