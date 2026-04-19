import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuildingMapScreen extends StatefulWidget {
  final String buildingName;
  final String svgName;
  final CustomPainter painter;
  const BuildingMapScreen({
    super.key,
    required this.buildingName,
    required this.svgName,
    required this.painter
  });

  @override
  State<BuildingMapScreen> createState() => _BuildingMapScreenState();
}

class _BuildingMapScreenState extends State<BuildingMapScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.buildingName)),
      body: InteractiveViewer(
        panEnabled: true,
        scaleEnabled: true,
        boundaryMargin: EdgeInsets.all(500),
        child: Center(
          child: Stack(
            children: [
              SvgPicture.asset(widget.svgName),
              Positioned.fill(
                child: CustomPaint(painter: widget.painter),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
