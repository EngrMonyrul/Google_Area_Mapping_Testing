import 'package:flutter/material.dart';

void showBottomSheetForMeasure(context, area) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildAreaMeasure('Meter',area),
            const SizedBox(height: 10),
            buildAreaMeasure('Millimetre',area*1000000),
            const SizedBox(height: 10),
            buildAreaMeasure('Kilometer',area/1000000),
            const SizedBox(height: 10),
            buildAreaMeasure('Kilometer',area/1000000),
            const SizedBox(height: 10),
            buildAreaMeasure('Mile',area/2.59000000),
            const SizedBox(height: 10),
            buildAreaMeasure('Yard',area*1.196),
            const SizedBox(height: 10),
            buildAreaMeasure('Foot',area*10.764),
            const SizedBox(height: 10),
            buildAreaMeasure('Inch',area*1550),
            const SizedBox(height: 10),
            buildAreaMeasure('Hectare',area/10000),
            const SizedBox(height: 10),
            buildAreaMeasure('Acre',area/4047),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

Container buildAreaMeasure(meter, area) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.5),
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('$meter - ', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(
          area.toString(),
          overflow: TextOverflow.ellipsis,
          maxLines: null,
        )
      ],
    ),
  );
}
