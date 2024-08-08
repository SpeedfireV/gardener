import 'package:flutter/material.dart';

import 'colors.dart';

class PlantInfoPage extends StatefulWidget {
  const PlantInfoPage({super.key});

  @override
  State<PlantInfoPage> createState() => _PlantInfoPageState();
}

class _PlantInfoPageState extends State<PlantInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Material(
                  elevation: 5, // Now applies actual elevation
                  borderRadius: BorderRadius.circular(15),
                  color: ColorPalette.cardColor, // Background color
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 40,
                      color: ColorPalette.primaryTextColor, // Icon color
                    ),
                  ),
                ),
              ),
              SizedBox(width: 56)
            ],
          ),
          Text("Tomatoes"),
          Text("Solanum lycopersicum"),
          Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum  interdum purus augue, et malesuada arcu tincidunt euismod. Sed tellus  lacus, laoreet eget justo tempor, vehicula dictum massa. In a porta."),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [Text("Growing Time"), Text("2-3 weeks")],
              ),
              Column(
                children: [Text("Grown In Poland")],
              ),
              Column(
                children: [Text("Optimal Temp"), Text("21-27°C")],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(children: [
                  Text("Growing Difficulty"),
                ]),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text("Air Humidity"),
                    Text("40-75%"),
                  ],
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Planting Season",
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorPalette.primaryTextColor,
                    ),
                  ),
                  Icon(
                    Icons.info_outline,
                    color: ColorPalette.primaryTextColor,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 1; i < 13; i++)
                    Column(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorPalette.secondaryGreyColor),
                        ),
                        Text(i.toString())
                      ],
                    )
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Needed Water"),
                        Icon(
                          Icons.info_outline,
                          color: ColorPalette.primaryTextColor,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Needed Light"),
                        Icon(
                          Icons.info_outline,
                          color: ColorPalette.primaryTextColor,
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
