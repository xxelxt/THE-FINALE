import 'dart:math';
import 'package:flutter/material.dart';

import '../const/colors.dart';

class EmptyBoardWidget extends StatelessWidget {
  const EmptyBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = max(
        290.0,
        min((MediaQuery.sizeOf(context).shortestSide * 0.90).floorToDouble(),
            460.0));

    final sizePerTile = (size / 4).floorToDouble();
    final tileSize = sizePerTile - 12.0 - (12.0 / 4);
    final boardSize = sizePerTile * 4;
    return Container(
      width: boardSize,
      height: boardSize,
      decoration: BoxDecoration(
          color: boardColor, borderRadius: BorderRadius.circular(6.0)),
      child: Stack(
        children: List.generate(16, (i) {
          //Render the empty board in 4x4 GridView
          var x = ((i + 1) / 4).ceil();
          var y = x - 1;

          var top = y * (tileSize) + (x * 12.0);
          var z = (i - (4 * y));
          var left = z * (tileSize) + ((z + 1) * 12.0);

          return Positioned(
            top: top,
            left: left,
            child: Container(
              width: tileSize,
              height: tileSize,
              decoration: BoxDecoration(
                  color: emptyTileColor,
                  borderRadius: BorderRadius.circular(6.0)),
            ),
          );
        }),
      ),
    );
  }
}
