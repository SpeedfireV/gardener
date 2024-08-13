import 'package:flutter/material.dart';
import 'package:gardener/drawer.dart';
import 'package:gardener/models/min_max_values.dart';
import 'package:gardener/models/plant_data.dart';
import 'package:gardener/plant_info_page.dart';

import 'colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      backgroundColor: ColorPalette.backgroundColor,
      body: ListView(
        children: [
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
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
                        _scaffoldKey.currentState?.openDrawer();
                        debugPrint("Drawer Opened");
                      },
                      style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      icon: Icon(
                        Icons.menu_rounded,
                        size: 40,
                        color: ColorPalette.primaryTextColor, // Icon color
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                    child: SearchBar(
                  hintText: "How can I help You?",
                  backgroundColor:
                      WidgetStateProperty.all(ColorPalette.cardColor),
                  hintStyle: WidgetStateProperty.all(TextStyle(
                      fontSize: 14, color: ColorPalette.primaryTextColor)),
                  leading: Icon(Icons.search),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
                )),
              ],
            ),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "In Season",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: ColorPalette.primaryTextColor),
            ),
          ),
          SizedBox(height: 8),
          GridView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
            children: [PlantInfoCard()],
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                iconAlignment: IconAlignment.end,
                onPressed: () {
                  debugPrint("Garden Data Clicked");
                },
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ColorPalette.primaryTextColor,
                ),
                label: Text(
                  "Garden Data",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: ColorPalette.primaryTextColor),
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          GridView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
            children: [
              Material(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("Air Humidity")],
                ),
              ),
              Material(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Temperature",
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class PlantInfoCard extends StatefulWidget {
  const PlantInfoCard({super.key});

  @override
  State<PlantInfoCard> createState() => _PlantInfoCardState();
}

class _PlantInfoCardState extends State<PlantInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: () {
          debugPrint("Plant Info Card Clicked");
          PlantData _plantData = PlantData(
              "name",
              "latin",
              "description",
              MinMaxValues(2, 4),
              {"pl": true},
              MinMaxValues(25, 34),
              4,
              MinMaxValues(45, 85),
              [Seasons.growing, Seasons.growing],
              3,
              4,
              "howToPlant");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlantInfoPage(plantData: _plantData)));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tomatoes",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Vegetable",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "Solanum lycopersicum",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w300),
                      )
                    ],
                  )),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Growing Time",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: ColorPalette.primaryTextColor),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            // TODO: Time Icons
                            for (int i = 0; i < 4; i++)
                              Icon(
                                Icons.schedule,
                                color: ColorPalette.primaryColor,
                              ),
                            SizedBox(width: 4),
                            Text(
                              "7-9 weeks",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Growing Difficulty",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: ColorPalette.primaryTextColor)),
                        SizedBox(height: 4),
                        SizedBox(
                          height: 24,
                          child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Image(
                                    image: AssetImage(
                                        "lib/assets/images/leaf.png"),
                                    width: 24,
                                    height: 24,
                                  ),
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 4),
                              itemCount: 6),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
