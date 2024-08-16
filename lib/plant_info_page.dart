import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gardener/models/plant_data.dart';
import 'package:gardener/utils/location.dart';
import 'package:url_launcher/url_launcher.dart';

import 'colors.dart';

class PlantInfoPage extends StatefulWidget {
  const PlantInfoPage({super.key, required this.plantData});
  final PlantData plantData;

  @override
  State<PlantInfoPage> createState() => _PlantInfoPageState();
}

class _PlantInfoPageState extends State<PlantInfoPage> {
  Future _googleSearch() async {
    final googleSearchUrl =
        'https://www.google.com/search?q=cabbage nutrition facts';
    if (await canLaunchUrl(Uri.parse(googleSearchUrl))) {
      await launchUrl(Uri.parse(googleSearchUrl));
    } else {
      // Handle the case where the URL can't be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch Google Search')),
      );
    }
  }

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
                    style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 40,
                      color: ColorPalette.primaryTextColor, // Icon color
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: ColorPalette.cardColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Image(
                  image: AssetImage("lib/assets/images/tomato.png"),
                  width: 40,
                  height: 40,
                ),
              ),
              SizedBox(width: 56)
            ],
          ),
          SizedBox(height: 12),
          Text(
            widget.plantData.name,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: ColorPalette.primaryTextColor),
          ),
          SizedBox(height: 4),
          Text(
            widget.plantData.latin,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: ColorPalette.primaryTextColor),
          ),
          SizedBox(height: 12),
          Text(
            widget.plantData.description,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: ColorPalette.primaryTextColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InformationCard(
                  title: "Growing Time",
                  subtitle:
                      "${widget.plantData.growingTime.min.toInt()}-${widget.plantData.growingTime.max.toInt()} weeks",
                  iconData: Icons.schedule,
                  mono: false),
              SizedBox(width: 12),
              _isPlantGrownWidget(widget.plantData),
              SizedBox(width: 12),
              InformationCard(
                  title: "Optimal Temp",
                  subtitle: "21-27°C",
                  iconData: Icons.device_thermostat,
                  mono: false),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: ColorPalette.cardColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(children: [
                      Text(
                        "Growing Difficulty",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: ColorPalette.primaryTextColor),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 20,
                        child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (index < widget.plantData.growingDifficulty) {
                                return Image(
                                  image:
                                      AssetImage("lib/assets/images/leaf.png"),
                                  width: 20,
                                  height: 20,
                                );
                              } else {
                                return Image(
                                  image: AssetImage(
                                      "lib/assets/images/leaf_outlined.png"),
                                  width: 20,
                                  height: 20,
                                );
                              }
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 4),
                            itemCount: 6),
                      )
                    ]),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: ColorPalette.cardColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(children: [
                      Text(
                        "Air Humidity",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: ColorPalette.primaryTextColor),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "${widget.plantData.airHumidity.min.toInt()}-${widget.plantData.airHumidity.max.toInt()}%",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: ColorPalette.primaryTextColor),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Material(
            elevation: 5,
            color: ColorPalette.cardColor,
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                debugPrint("Planting Season Tapped");
                showDialog(
                    context: context,
                    builder: (context) => PlantingSeasonDialog());
              },
              child: SizedBox(
                height: 100,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
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
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.info_outline,
                            color: ColorPalette.primaryTextColor,
                            size: 20,
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: Center(
                          child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    MyArc(
                                      diameter: 20,
                                      leftSideColor: _colorBySeason(widget
                                          .plantData
                                          .seasons[(index + 1) * 2 - 2]),
                                      rightSideColor: _colorBySeason(widget
                                          .plantData
                                          .seasons[(index + 1) * 2 - 1]),
                                    ),
                                    Text(index.toString())
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(width: 8);
                              },
                              itemCount: 12),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Material(
                  elevation: 5,
                  color: ColorPalette.cardColor,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () {
                      debugPrint("Needed Water Tapped");
                      showDialog(
                          context: context,
                          builder: (context) => NeededWaterDialog());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Needed Water",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.primaryTextColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.info_outline,
                                color: ColorPalette.primaryTextColor,
                                size: 20,
                              )
                            ],
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            height: 20,
                            child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  if (index < widget.plantData.neededWater) {
                                    return Image(
                                      image: AssetImage(
                                          "lib/assets/images/droplet.png"),
                                      width: 20,
                                      height: 20,
                                    );
                                  } else {
                                    return Image(
                                      image: AssetImage(
                                          "lib/assets/images/droplet_outlined.png"),
                                      width: 20,
                                      height: 20,
                                    );
                                  }
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 4),
                                itemCount: 6),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Material(
                  elevation: 5,
                  color: ColorPalette.cardColor,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () {
                      debugPrint("Needed Light Tapped");
                      showDialog(
                          context: context,
                          builder: (context) => NeededLightDialog());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Needed Light",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.primaryTextColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.info_outline,
                                color: ColorPalette.primaryTextColor,
                                size: 20,
                              )
                            ],
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            height: 20,
                            child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  if (index < widget.plantData.neededLight) {
                                    return Image(
                                      image: AssetImage(
                                          "lib/assets/images/sun.png"),
                                      width: 20,
                                      height: 20,
                                    );
                                  } else {
                                    return Image(
                                      image: AssetImage(
                                          "lib/assets/images/sun_outlined.png"),
                                      width: 20,
                                      height: 20,
                                    );
                                  }
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 4),
                                itemCount: 6),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Material(
                  elevation: 5,
                  color: ColorPalette.cardColor,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () {
                      debugPrint("How To Plant Tapped");
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "How To Plant?",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.primaryTextColor,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Material(
                  elevation: 5,
                  color: ColorPalette.cardColor,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () {
                      debugPrint("Soil Details Tapped");
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Soil Details",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.primaryTextColor,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Material(
                  elevation: 5,
                  color: ColorPalette.cardColor,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () async {
                      debugPrint("Nutrients Tapped");
                      await _googleSearch();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.library_books_outlined,
                                  color: ColorPalette.primaryTextColor),
                              SizedBox(width: 4),
                              Text(
                                "Nutrients",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.primaryTextColor,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Material(
                  elevation: 5,
                  color: ColorPalette.cardColor,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () async {
                      debugPrint("Cooking Tapped");
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.local_cafe_outlined,
                                  color: ColorPalette.primaryTextColor),
                              SizedBox(width: 4),
                              Text(
                                "Cooking",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.primaryTextColor,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }

  Widget _isPlantGrownWidget(PlantData plant) {
    switch (isPlantGrown(plant)) {
      case (IsPlantGrown.grown):
        {
          return InformationCard(
            title: "Grown In Your Country",
            iconData: Icons.eco_outlined,
            mono: true,
          );
        }
      case (IsPlantGrown.notGrown):
        {
          return InformationCard(
            title: "Not Grown In Your Country",
            iconData: Icons.eco_outlined,
            mono: true,
            customBackgroundColor: ColorPalette.complementaryColor,
          );
        }
      default:
        return Container();
    }
  }

  Color _colorBySeason(Seasons season) {
    switch (season) {
      case Seasons.harvesting:
        {
          return ColorPalette.complementaryColor;
        }
      case Seasons.growing:
        {
          return ColorPalette.mediumColor;
        }
      case Seasons.planting:
        {
          return ColorPalette.primaryColor;
        }
      case Seasons.resting:
        {
          return ColorPalette.secondaryGreyColor;
        }
    }
  }
}

class InformationCard extends StatelessWidget {
  const InformationCard(
      {super.key,
      required this.title,
      this.subtitle,
      required this.iconData,
      required this.mono,
      this.customBackgroundColor});
  final String title;
  final String? subtitle;
  final IconData iconData;
  final bool mono;
  final Color? customBackgroundColor;

  @override
  Widget build(BuildContext context) {
    late Color _backgroundColor;
    late Color _primaryColor;
    late Color _textColor;
    if (mono) {
      _backgroundColor = ColorPalette.primaryColor;
      _primaryColor = ColorPalette.cardColor;
      _textColor = ColorPalette.cardColor;
    } else {
      _backgroundColor = ColorPalette.cardColor;
      _primaryColor = ColorPalette.primaryColor;
      _textColor = ColorPalette.primaryTextColor;
    }

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: customBackgroundColor ?? _backgroundColor,
            borderRadius: BorderRadius.circular(15)),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 32,
                color: _primaryColor,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: _textColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2),
              subtitle != null
                  ? Text(
                      subtitle!,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: _textColor),
                      textAlign: TextAlign.center,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

class PlantingSeasonDialog extends StatelessWidget {
  const PlantingSeasonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 40,
              color: ColorPalette.primaryTextColor,
            ),
            SizedBox(height: 4),
            Text(
              "Seasons' Description",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: ColorPalette.primaryTextColor),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: ColorPalette.primaryColor),
                ),
                SizedBox(width: 4),
                Text(
                  "Planting Season",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.primaryTextColor),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: ColorPalette.mediumColor),
                ),
                SizedBox(width: 4),
                Text(
                  "Growing Season",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.primaryTextColor),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorPalette.complementaryColor),
                ),
                SizedBox(width: 4),
                Text(
                  "Harvest Season",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.primaryTextColor),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorPalette.secondaryGreyColor),
                ),
                SizedBox(width: 4),
                Text(
                  "Resting Season",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.primaryTextColor),
                ),
              ],
            ),
            SizedBox(height: 18),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Close",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.deleteColor),
                ))
          ],
        ),
      ),
    );
  }
}

class NeededWaterDialog extends StatelessWidget {
  const NeededWaterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 40,
                color: ColorPalette.primaryTextColor,
              ),
              SizedBox(height: 4),
              Text(
                "Needed Water Description",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: ColorPalette.primaryTextColor),
              ),
              SizedBox(height: 24),
              SizedBox(
                height: 20,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Image(
                          image: AssetImage(index < 1
                              ? "lib/assets/images/droplet.png"
                              : "lib/assets/images/droplet_outlined.png"),
                          width: 20,
                          height: 20,
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 4),
                    itemCount: 6),
              ),
              Text("Needs to be watered few times a week"),
              SizedBox(height: 8),
              SizedBox(
                height: 20,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Image(
                          image: AssetImage(index < 2
                              ? "lib/assets/images/droplet.png"
                              : "lib/assets/images/droplet_outlined.png"),
                          width: 20,
                          height: 20,
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 4),
                    itemCount: 6),
              ),
              Text("Needs to be watered few times a week"),
              SizedBox(height: 8),
              SizedBox(
                height: 20,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Image(
                          image: AssetImage(index < 3
                              ? "lib/assets/images/droplet.png"
                              : "lib/assets/images/droplet_outlined.png"),
                          width: 20,
                          height: 20,
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 4),
                    itemCount: 6),
              ),
              Text("Needs to be watered few times a week"),
              SizedBox(height: 8),
              SizedBox(
                height: 20,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Image(
                          image: AssetImage(index < 4
                              ? "lib/assets/images/droplet.png"
                              : "lib/assets/images/droplet_outlined.png"),
                          width: 20,
                          height: 20,
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 4),
                    itemCount: 6),
              ),
              Text("Needs to be watered few times a week"),
              SizedBox(height: 8),
              SizedBox(
                height: 20,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Image(
                          image: AssetImage(index < 5
                              ? "lib/assets/images/droplet.png"
                              : "lib/assets/images/droplet_outlined.png"),
                          width: 20,
                          height: 20,
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 4),
                    itemCount: 6),
              ),
              Text("Needs to be watered few times a week"),
              SizedBox(height: 8),
              SizedBox(
                height: 20,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Image(
                          image: AssetImage(index < 6
                              ? "lib/assets/images/droplet.png"
                              : "lib/assets/images/droplet_outlined.png"),
                          width: 20,
                          height: 20,
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 4),
                    itemCount: 6),
              ),
              Text("Needs to be watered few times a week"),
              SizedBox(height: 18),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.deleteColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class NeededLightDialog extends StatelessWidget {
  const NeededLightDialog({super.key});

  final String _icon = "lib/assets/images/sun.png";
  final String _icon_outlined = "lib/assets/images/sun_outlined.png";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 40,
                color: ColorPalette.primaryTextColor,
              ),
              SizedBox(height: 4),
              Text(
                "Needed Water Description",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: ColorPalette.primaryTextColor),
              ),
              SizedBox(height: 24),
              SizedBox(
                height: 20,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Image(
                          image: AssetImage(index < 1 ? _icon : _icon_outlined),
                          width: 20,
                          height: 20,
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 4),
                    itemCount: 6),
              ),
              Text("Needs to be watered few times a week"),
              SizedBox(height: 8),
              SizedBox(
                height: 20,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Image(
                          image: AssetImage(index < 2 ? _icon : _icon_outlined),
                          width: 20,
                          height: 20,
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 4),
                    itemCount: 6),
              ),
              Text("Needs to be watered few times a week"),
              SizedBox(height: 8),
              SizedBox(
                height: 20,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Image(
                          image: AssetImage(index < 3 ? _icon : _icon_outlined),
                          width: 20,
                          height: 20,
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 4),
                    itemCount: 6),
              ),
              Text("Needs to be watered few times a week"),
              SizedBox(height: 8),
              SizedBox(
                height: 20,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Image(
                          image: AssetImage(index < 4 ? _icon : _icon_outlined),
                          width: 20,
                          height: 20,
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 4),
                    itemCount: 6),
              ),
              Text("Needs to be watered few times a week"),
              SizedBox(height: 8),
              SizedBox(
                height: 20,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Image(
                          image: AssetImage(index < 5 ? _icon : _icon_outlined),
                          width: 20,
                          height: 20,
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 4),
                    itemCount: 6),
              ),
              Text("Needs to be watered few times a week"),
              SizedBox(height: 8),
              SizedBox(
                height: 20,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Image(
                          image: AssetImage(index < 6 ? _icon : _icon_outlined),
                          width: 20,
                          height: 20,
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 4),
                    itemCount: 6),
              ),
              Text("Needs to be watered few times a week"),
              SizedBox(height: 18),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.deleteColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class MyArc extends StatelessWidget {
  final double diameter;
  final Color leftSideColor;
  final Color rightSideColor;
  const MyArc(
      {super.key,
      required this.diameter,
      required this.leftSideColor,
      required this.rightSideColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: LeftHalfPainter(leftSideColor),
          size: Size(diameter, diameter),
        ),
        CustomPaint(
          painter: RightHalfPainter(rightSideColor),
          size: Size(diameter, diameter),
        ),
      ],
    );
  }
}

// This is the Painter class
class LeftHalfPainter extends CustomPainter {
  final Color color;

  LeftHalfPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi / 2,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RightHalfPainter extends CustomPainter {
  final Color color;

  RightHalfPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi * 1.5,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
