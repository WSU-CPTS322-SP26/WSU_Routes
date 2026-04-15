// modifed attributes and build method
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuildingMapScreen extends StatefulWidget {
  final String buildingName;
  final SvgPicture svgImage;
  final CustomPainter painter;
  const BuildingMapScreen({
    super.key,
    required this.buildingName,
    required this.svgImage,
    required this.painter
  });

  @override
  State<BuildingMapScreen> createState() => _BuildingMapScreenState();
}

class _BuildingMapScreenState extends State<BuildingMapScreen> {
  // TODO: add selected room state and path result here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.buildingName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/<building>.svg'),
            CustomPaint(painter: widget.painter),
          ],
        ),
      ),
    );
  }
}
