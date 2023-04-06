import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final Widget mapWidget;
  final Widget menuWidget;
  final Widget consoleWidget;

  const AppLayout({
    required this.mapWidget,
    required this.menuWidget,
    required this.consoleWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: mapWidget,
                ),
                Expanded(
                  child: menuWidget,
                ),
              ],
            ),
          ),
          Expanded(
            child: consoleWidget,
          ),
        ],
      ),
    );
  }
}
