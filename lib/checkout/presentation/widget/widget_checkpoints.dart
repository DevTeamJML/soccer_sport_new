import 'package:flutter/material.dart';

class CheckPoints extends StatelessWidget {
  final int checkedTill;
  final List<String> checkPoints;
  final Color checkPointFilledColor;
  const CheckPoints(
      {required this.checkedTill,
      required this.checkPointFilledColor,
      required this.checkPoints});
  final double circleDia = 32;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (c, s) {
        final double cWidth =
            ((s.maxWidth - (32.0 * (checkPoints.length + 1))) /
                (checkPoints.length - 1));

        return Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: checkPoints.map((e) {
                    int index = checkPoints.indexOf(e);
                    return Expanded(
                      child: Container(
                          height: circleDia,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: circleDia,
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index <= checkedTill
                                        ? checkPointFilledColor
                                        : checkPointFilledColor
                                            .withOpacity(0.2),
                                  ),
                                ),
                              ),
                              index != (checkPoints.length - 1)
                                  ? Expanded(
                                      child: Container(
                                        color: index < checkedTill
                                            ? checkPointFilledColor
                                            : checkPointFilledColor
                                                .withOpacity(0.2),
                                        height: 4,
                                        width: cWidth,
                                      ),
                                    )
                                  : Container()
                            ],
                          )),
                    );
                  }).toList(),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: checkPoints
                      .map((e) => Text(e,
                          style: TextStyle(fontWeight: FontWeight.bold)))
                      .toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
