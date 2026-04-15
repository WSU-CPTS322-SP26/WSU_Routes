// Generative AI was utilized to generate this code
import 'package:flutter/material.dart';

class BuildingMapScreen extends StatefulWidget {
  final String buildingName;

  const BuildingMapScreen({super.key, required this.buildingName});

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
            const Icon(Icons.map_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Map coming soon for\n${widget.buildingName}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            // TODO: replace above with Stack(
            //   children: [
            //     SvgPicture.asset('assets/images/<building>.svg'),
            //     CustomPaint(painter: PathPainter(pathOffsets)),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
