import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gardener/drawer.dart';
import 'package:gardener/models/plant_data.dart';
import 'package:gardener/plant_info_page.dart';
import 'package:gardener/utils/formatting.dart';
import 'package:shimmer/shimmer.dart';

import 'bloc/home_page/in_season_cubit.dart';
import 'constants/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<InSeasonCubit>(context).loadSeasonPlants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      backgroundColor: ColorPalette.backgroundColor,
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      icon: const Icon(
                        Icons.menu_rounded,
                        size: 40,
                        color: ColorPalette.primaryTextColor, // Icon color
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: SearchBar(
                  hintText: "How can I help You?",
                  backgroundColor:
                      WidgetStateProperty.all(ColorPalette.cardColor),
                  hintStyle: WidgetStateProperty.all(const TextStyle(
                      fontSize: 14, color: ColorPalette.primaryTextColor)),
                  leading: const Icon(Icons.search),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
                )),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "In Season",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: ColorPalette.primaryTextColor),
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<InSeasonCubit, InSeasonState>(
            builder: (context, state) {
              if (state is InSeasonLoading) {
                return GridView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12),
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[50]!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is InSeasonLoaded) {
                Iterable<PlantData> plants = state.plants;
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: plants.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12),
                  itemBuilder: (context, index) {
                    return PlantInfoCard(plantData: plants.elementAt(index));
                  },
                );
              }
              return const Text("Other State");
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                iconAlignment: IconAlignment.end,
                onPressed: () {
                  debugPrint("Garden Data Clicked");
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ColorPalette.primaryTextColor,
                ),
                label: const Text(
                  "Garden Data",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: ColorPalette.primaryTextColor),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          GridView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
            children: const [
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
  const PlantInfoCard({super.key, required this.plantData});
  final PlantData plantData;

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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PlantInfoPage(plantData: widget.plantData)));
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
                        widget.plantData.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        widget.plantData.type.name,
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        widget.plantData.latin,
                        style: const TextStyle(
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
                        const Text(
                          "Growing Time",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: ColorPalette.primaryTextColor),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            // TODO: Time Icons
                            const Icon(
                              Icons.schedule,
                              color: ColorPalette.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              growingTimeToString(widget.plantData.growingTime),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Growing Difficulty",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: ColorPalette.primaryTextColor)),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 24,
                          child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                bool active =
                                    index < widget.plantData.growingDifficulty;
                                return Image(
                                  image: AssetImage(active
                                      ? "lib/assets/images/leaf.png"
                                      : "lib/assets/images/leaf_outlined.png"),
                                  width: 24,
                                  height: 24,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 4),
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
