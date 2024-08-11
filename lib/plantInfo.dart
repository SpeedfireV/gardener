import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'colors.dart';

class PlantInfoPage extends StatefulWidget {
  const PlantInfoPage({super.key});

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
            "Tomatoes",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: ColorPalette.primaryTextColor),
          ),
          SizedBox(height: 4),
          Text(
            "Solanum lycopersicum",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: ColorPalette.primaryTextColor),
          ),
          SizedBox(height: 12),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum  interdum purus augue, et malesuada arcu tincidunt euismod. Sed tellus  lacus, laoreet eget justo tempor, vehicula dictum massa. In a porta.",
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
                  subtitle: "2-3 weeks",
                  iconData: Icons.schedule,
                  mono: false),
              SizedBox(width: 12),
              InformationCard(
                  title: "Grown In Poland",
                  iconData: Icons.eco_outlined,
                  mono: true),
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
                            itemBuilder: (context, index) => Image(
                                  image:
                                      AssetImage("lib/assets/images/leaf.png"),
                                  width: 20,
                                  height: 20,
                                ),
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
                        "40-75%",
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
              },
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
                                itemBuilder: (context, index) => Image(
                                      image: AssetImage(
                                          "lib/assets/images/droplet.png"),
                                      width: 20,
                                      height: 20,
                                    ),
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
                                itemBuilder: (context, index) => Image(
                                      image: AssetImage(
                                          "lib/assets/images/sun.png"),
                                      width: 20,
                                      height: 20,
                                    ),
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
}

class InformationCard extends StatelessWidget {
  const InformationCard(
      {super.key,
      required this.title,
      this.subtitle,
      required this.iconData,
      required this.mono});
  final String title;
  final String? subtitle;
  final IconData iconData;
  final bool mono;

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
            color: _backgroundColor, borderRadius: BorderRadius.circular(15)),
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
