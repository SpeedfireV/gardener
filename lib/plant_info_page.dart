import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gardener/models/plant_data.dart';
import 'package:gardener/utils/formatting.dart';
import 'package:gardener/utils/location.dart';
import 'package:gardener/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants/colors.dart';
import 'constants/enums.dart';
import 'constants/styles.dart';

class PlantInfoPage extends StatefulWidget {
  const PlantInfoPage({super.key, required this.plantData});
  final PlantData plantData;

  @override
  State<PlantInfoPage> createState() => _PlantInfoPageState();
}

class _PlantInfoPageState extends State<PlantInfoPage> {
  Future _googleSearch(name, query) async {
    final googleSearchUrl = 'https://www.google.com/search?q=${name} ${query}';
    if (await canLaunchUrl(Uri.parse(googleSearchUrl))) {
      await launchUrl(Uri.parse(googleSearchUrl));
    } else {
      // Handle the case where the URL can't be launched
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch Google Search')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          const SizedBox(height: 16),
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
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 40,
                      color: ColorPalette.primaryTextColor, // Icon color
                    ),
                  ),
                ),
              ),
              Text(
                widget.plantData.name,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: ColorPalette.primaryTextColor),
              ),
              const SizedBox(width: 56),
            ],
          ),
          const SizedBox(height: 12),
          plantTypeToString(widget.plantData.type) != null
              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const SizedBox(height: 4),
                  Text(
                    plantTypeToString(widget.plantData.type)!,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.primaryTextColor),
                  ),
                ])
              : Container(),
          const SizedBox(height: 4),
          Text(
            widget.plantData.latin,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: ColorPalette.primaryTextColor),
          ),
          const SizedBox(height: 12),
          Text(
            widget.plantData.description,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: ColorPalette.primaryTextColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InformationCard(
                  title: "Growing Time",
                  subtitle: growingTimeToString(widget.plantData.growingTime),
                  iconData: Icons.schedule,
                  mono: false),
              const SizedBox(width: 12),
              _isPlantGrownWidget(widget.plantData),
              const SizedBox(width: 12),
              InformationCard(
                  title: "Optimal Temp",
                  subtitle:
                      "${widget.plantData.optimalTemp.min}-${widget.plantData.optimalTemp.max}°C",
                  iconData: Icons.device_thermostat,
                  mono: false),
            ],
          ),
          const SizedBox(height: 12),
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
                      const Text(
                        "Growing Difficulty",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: ColorPalette.primaryTextColor),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 20,
                        child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (index < widget.plantData.growingDifficulty) {
                                return const Image(
                                  image:
                                      AssetImage("lib/assets/images/leaf.png"),
                                  width: 20,
                                  height: 20,
                                );
                              } else {
                                return const Image(
                                  image: AssetImage(
                                      "lib/assets/images/leaf_outlined.png"),
                                  width: 20,
                                  height: 20,
                                );
                              }
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 4),
                            itemCount: 6),
                      )
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: ColorPalette.cardColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(children: [
                      const Text(
                        "Air Humidity",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: ColorPalette.primaryTextColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${widget.plantData.airHumidity.min.toInt()}-${widget.plantData.airHumidity.max.toInt()}%",
                        style: const TextStyle(
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
          const SizedBox(height: 12),
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
                    builder: (context) => const PlantingSeasonDialog());
              },
              child: SizedBox(
                height: 100,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
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
                      const SizedBox(height: 8),
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
                                return const SizedBox(width: 8);
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
          const SizedBox(height: 12),
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
                          builder: (context) => const NeededWaterDialog());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          const Row(
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
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 20,
                            child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  if (index < widget.plantData.neededWater) {
                                    return const Image(
                                      image: AssetImage(
                                          "lib/assets/images/droplet.png"),
                                      width: 20,
                                      height: 20,
                                    );
                                  } else {
                                    return const Image(
                                      image: AssetImage(
                                          "lib/assets/images/droplet_outlined.png"),
                                      width: 20,
                                      height: 20,
                                    );
                                  }
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 4),
                                itemCount: 6),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
                          builder: (context) => const NeededLightDialog());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          const Row(
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
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 20,
                            child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  if (index < widget.plantData.neededLight) {
                                    return const Image(
                                      image: AssetImage(
                                          "lib/assets/images/sun.png"),
                                      width: 20,
                                      height: 20,
                                    );
                                  } else {
                                    return const Image(
                                      image: AssetImage(
                                          "lib/assets/images/sun_outlined.png"),
                                      width: 20,
                                      height: 20,
                                    );
                                  }
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 4),
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
          const SizedBox(height: 12),
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
                      showDialog(
                          context: context,
                          builder: (context) => _howToPlantDialog());
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
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
              const SizedBox(width: 12),
              Expanded(
                child: Material(
                  elevation: 5,
                  color: ColorPalette.cardColor,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () {
                      debugPrint("Soil Details Tapped");
                      showDialog(
                          context: context,
                          builder: (context) => _soilDetailsDialog());
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
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
          const SizedBox(height: 12),
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
                      await _googleSearch(
                          widget.plantData.name, "nutrition facts");
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
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
              const SizedBox(width: 12),
              Expanded(
                child: Material(
                  elevation: 5,
                  color: ColorPalette.cardColor,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () async {
                      debugPrint("Cooking Tapped");
                      await _googleSearch(widget.plantData.name, "recipies");
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
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

  Dialog _howToPlantDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: Paddings.dialogPadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.question_mark_rounded,
                size: 40,
                color: ColorPalette.primaryTextColor,
              ),
              SizedBox(height: 8),
              Text(
                "How To Plant",
                style: TextStyles.dialogTitleStyle,
              ),
              SizedBox(height: 16),
              Text(
                widget.plantData.howToPlant,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              closeTextButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Dialog _soilDetailsDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: Paddings.dialogPadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.grass,
                size: 40,
                color: ColorPalette.primaryTextColor,
              ),
              SizedBox(height: 8),
              Text(
                "Soil Details",
                style: TextStyles.dialogTitleStyle,
              ),
              SizedBox(height: 16),
              Text(
                widget.plantData.soilDetails,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              closeTextButton(context)
            ],
          ),
        ),
      ),
    );
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
        padding: const EdgeInsets.all(8),
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
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: _textColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
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
            const Icon(
              Icons.info_outline_rounded,
              size: 40,
              color: ColorPalette.primaryTextColor,
            ),
            const SizedBox(height: 4),
            Text(
              "Seasons' Description",
              style: TextStyles.dialogTitleStyle,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: ColorPalette.primaryColor),
                ),
                const SizedBox(width: 4),
                const Text(
                  "Planting Season",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.primaryTextColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: ColorPalette.mediumColor),
                ),
                const SizedBox(width: 4),
                const Text(
                  "Growing Season",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.primaryTextColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorPalette.complementaryColor),
                ),
                const SizedBox(width: 4),
                const Text(
                  "Harvest Season",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.primaryTextColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorPalette.secondaryGreyColor),
                ),
                const SizedBox(width: 4),
                const Text(
                  "Resting Season",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.primaryTextColor),
                ),
              ],
            ),
            const SizedBox(height: 18),
            closeTextButton(context)
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
              const Icon(
                Icons.info_outline_rounded,
                size: 40,
                color: ColorPalette.primaryTextColor,
              ),
              const SizedBox(height: 4),
              const Text(
                "Needed Water Description",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: ColorPalette.primaryTextColor),
              ),
              const SizedBox(height: 24),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
                    itemCount: 6),
              ),
              const Text("Needs to be watered few times a week"),
              const SizedBox(height: 8),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
                    itemCount: 6),
              ),
              const Text("Needs to be watered few times a week"),
              const SizedBox(height: 8),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
                    itemCount: 6),
              ),
              const Text("Needs to be watered few times a week"),
              const SizedBox(height: 8),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
                    itemCount: 6),
              ),
              const Text("Needs to be watered few times a week"),
              const SizedBox(height: 8),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
                    itemCount: 6),
              ),
              const Text("Needs to be watered few times a week"),
              const SizedBox(height: 8),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
                    itemCount: 6),
              ),
              const Text("Needs to be watered few times a week"),
              const SizedBox(height: 18),
              closeTextButton(context)
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
              const Icon(
                Icons.info_outline_rounded,
                size: 40,
                color: ColorPalette.primaryTextColor,
              ),
              const SizedBox(height: 4),
              const Text(
                "Needed Water Description",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: ColorPalette.primaryTextColor),
              ),
              const SizedBox(height: 24),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
                    itemCount: 6),
              ),
              const Text("Needs to be watered few times a week"),
              const SizedBox(height: 8),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
                    itemCount: 6),
              ),
              const Text("Needs to be watered few times a week"),
              const SizedBox(height: 8),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
                    itemCount: 6),
              ),
              const Text("Needs to be watered few times a week"),
              const SizedBox(height: 8),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
                    itemCount: 6),
              ),
              const Text("Needs to be watered few times a week"),
              const SizedBox(height: 8),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
                    itemCount: 6),
              ),
              const Text("Needs to be watered few times a week"),
              const SizedBox(height: 8),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
                    itemCount: 6),
              ),
              const Text("Needs to be watered few times a week"),
              const SizedBox(height: 18),
              closeTextButton(context)
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
