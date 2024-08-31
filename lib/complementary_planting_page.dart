import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gardener/bloc/complementary_planting_page/plants_list_bloc.dart';
import 'package:gardener/constants/styles.dart';
import 'package:gardener/plant_info_page.dart';
import 'package:gardener/search_for_companions_page.dart';
import 'package:gardener/utils/formatting.dart';
import 'package:gardener/utils/location.dart';
import 'package:shimmer/shimmer.dart';

import 'bloc/plants_handbook_page/firestore_bloc.dart';
import 'constants/colors.dart';
import 'constants/enums.dart';
import 'models/plant_data.dart';

class ComplementaryPlantingPage extends StatefulWidget {
  const ComplementaryPlantingPage({super.key});

  @override
  State<ComplementaryPlantingPage> createState() =>
      _ComplementaryPlantingPageState();
}

class _ComplementaryPlantingPageState extends State<ComplementaryPlantingPage> {
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    BlocProvider.of<FirestoreBloc>(context).add(LoadPlants());
    BlocProvider.of<PlantsListBloc>(context).add(PlantsListResetSelection());
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: [
          ListView(
            children: [
              SizedBox(height: 16),
              Row(
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
                    controller: searchController,
                    hintText: "Find your plant",
                    onTapOutside: (pointer) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    onChanged: (query) {
                      BlocProvider.of<PlantsListBloc>(context)
                          .add(PlantsListSearchQueryChanged(query));
                    },
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
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: BlocBuilder<PlantsListBloc, PlantsListState>(
                    builder: (context, state) {
                      bool filtered = context.read<PlantsListBloc>().filter ==
                          PlantType.all;
                      return Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(15),
                          color: ColorPalette.cardColor,
                          child: InkWell(
                            onTap: () {
                              debugPrint("Filter Tapped");
                              _showFiltersBottomSheet(context);
                            },
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.filter_list_rounded,
                                        color: filtered
                                            ? ColorPalette.primaryTextColor
                                            : ColorPalette.primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Filter",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: filtered
                                              ? ColorPalette.primaryTextColor
                                              : ColorPalette.primaryColor,
                                        ),
                                      )
                                    ])),
                          ));
                    },
                  )),
                  const SizedBox(
                    width: 18,
                  ),
                  Expanded(
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(15),
                      color: ColorPalette.cardColor,
                      child: InkWell(
                        onTap: () {
                          debugPrint("Sorting Tapped");
                          _showSortingDialog(context);
                        },
                        child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.sort),
                                  SizedBox(width: 8),
                                  Text(
                                    "Sorting",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: ColorPalette.primaryTextColor),
                                  )
                                ])),
                      ),
                    ),
                  ),
                ],
              ),
              BlocBuilder<FirestoreBloc, FirestoreState>(
                builder: (context, firestoreState) {
                  if (firestoreState is PlantsLoaded) {
                    context
                        .read<PlantsListBloc>()
                        .setPlants(firestoreState.plants);
                    context
                        .read<PlantsListBloc>()
                        .add(PlantsListFilterChanged(PlantType.all));
                    return BlocBuilder<PlantsListBloc, PlantsListState>(
                      builder: (context, plantsListState) {
                        if (plantsListState is PlantsListLoaded) {
                          Map<String, List<PlantData>> plantsByLetters =
                              dividePlantsByFirstLetter(plantsListState.plants);
                          Iterable<String> letters = plantsByLetters.keys;
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, letterIndex) {
                                String currentLetter =
                                    letters.elementAt(letterIndex);
                                String? expandedCard =
                                    context.read<PlantsListBloc>().expanded;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        letters.elementAt(letterIndex),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w900,
                                            color:
                                                ColorPalette.primaryTextColor),
                                      ),
                                      const SizedBox(height: 4),
                                      ListView.separated(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            ScrollController
                                                expandedScrollController =
                                                ScrollController();
                                            PlantData plant = plantsByLetters[
                                                    letters.elementAt(
                                                        letterIndex)]!
                                                .elementAt(index);
                                            bool plantSelected = plantsListState
                                                .selectedPlants
                                                .contains(plant);

                                            return Material(
                                              elevation: 5,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: ColorPalette.cardColor,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                onTap: () {
                                                  context
                                                      .read<PlantsListBloc>()
                                                      .add(
                                                          PlantsListCardClicked(
                                                              plant.latin));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                                style: const TextStyle(
                                                                    color: ColorPalette
                                                                        .primaryTextColor,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                                children: [
                                                                  TextSpan(
                                                                      text: plant
                                                                          .name,
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w700)),
                                                                  const TextSpan(
                                                                      text:
                                                                          " | "),
                                                                  TextSpan(
                                                                      text: plant
                                                                          .latin)
                                                                ]),
                                                          ),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 40,
                                                                height: 40,
                                                                child: Material(
                                                                  elevation: 5,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  color: ColorPalette
                                                                      .primaryTextColor,
                                                                  child:
                                                                      IconButton(
                                                                    style: IconButton
                                                                        .styleFrom(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      debugPrint(
                                                                          "Plant Info Tapped");
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => PlantInfoPage(plantData: plant)));
                                                                    },
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .info_outline_rounded,
                                                                      size: 24,
                                                                      color: ColorPalette
                                                                          .cardColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 8),
                                                              SizedBox(
                                                                width: 40,
                                                                height: 40,
                                                                child: Material(
                                                                  elevation: 5,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  color: !plantSelected
                                                                      ? ColorPalette
                                                                          .primaryColor
                                                                      : ColorPalette
                                                                          .deleteColor,
                                                                  child:
                                                                      IconButton(
                                                                    style: IconButton
                                                                        .styleFrom(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      if (!plantSelected) {
                                                                        debugPrint(
                                                                            "Add Plant Tapped");
                                                                        context
                                                                            .read<PlantsListBloc>()
                                                                            .add(PlantsListPlantSelected(plant));
                                                                      } else {
                                                                        debugPrint(
                                                                            "Remove Plant Tapped");
                                                                        context
                                                                            .read<PlantsListBloc>()
                                                                            .add(PlantsListPlantRemoved(plant));
                                                                      }
                                                                    },
                                                                    icon: Icon(
                                                                        !plantSelected
                                                                            ? Icons
                                                                                .add_rounded
                                                                            : Icons
                                                                                .remove_rounded,
                                                                        size:
                                                                            28,
                                                                        color: ColorPalette
                                                                            .cardColor),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      plant.latin ==
                                                              expandedCard
                                                          ? Container(
                                                              height: 80,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          4),
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  RawScrollbar(
                                                                controller:
                                                                    expandedScrollController,
                                                                thumbVisibility:
                                                                    true,
                                                                thumbColor:
                                                                    ColorPalette
                                                                        .primaryColor,
                                                                radius: Radius
                                                                    .circular(
                                                                        15),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      _grownInCountryWidget(
                                                                          plant),
                                                                      SizedBox(
                                                                          height:
                                                                              4),
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.schedule_rounded,
                                                                            color:
                                                                                ColorPalette.primaryTextColor,
                                                                          ),
                                                                          SizedBox(
                                                                              width: 4),
                                                                          RichText(
                                                                            text:
                                                                                TextSpan(style: const TextStyle(color: ColorPalette.primaryTextColor, fontSize: 14, fontWeight: FontWeight.w700), children: [
                                                                              TextSpan(text: "Growing Time ", style: const TextStyle(fontWeight: FontWeight.w400)),
                                                                              TextSpan(text: "${growingTimeToString(plant.growingTime)}")
                                                                            ]),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              4),
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.thermostat,
                                                                            color:
                                                                                ColorPalette.primaryTextColor,
                                                                          ),
                                                                          SizedBox(
                                                                              width: 4),
                                                                          RichText(
                                                                            text:
                                                                                TextSpan(style: const TextStyle(color: ColorPalette.primaryTextColor, fontSize: 14, fontWeight: FontWeight.w700), children: [
                                                                              TextSpan(text: "Optimal Temp ", style: const TextStyle(fontWeight: FontWeight.w400)),
                                                                              TextSpan(text: "${plant.optimalTemp.min}-${plant.optimalTemp.max}°C")
                                                                            ]),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              4),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {},
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              "Planting Time",
                                                                              style: TextStyle(fontSize: 14, color: ColorPalette.primaryTextColor, fontWeight: FontWeight.w700),
                                                                            ),
                                                                            SizedBox(width: 4),
                                                                            Icon(
                                                                              Icons.info_outline,
                                                                              color: ColorPalette.primaryTextColor,
                                                                              size: 20,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container()
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 8),
                                          itemCount:
                                              plantsByLetters[currentLetter]!
                                                  .length)
                                    ],
                                  ),
                                );
                              },
                              itemCount: plantsByLetters.length);
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[50]!,
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[50]!,
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        );
                        ;
                      },
                    );
                  } else if (firestoreState is PlantsLoading) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[50]!,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[50]!,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (firestoreState is PlantsError) {
                    return const Text("Error loading data");
                  }
                  return const CircularProgressIndicator();
                },
              ),
              SizedBox(height: 100)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BlocBuilder<PlantsListBloc, PlantsListState>(
                builder: (context, plantsListState) {
                  bool? plantsSelected;
                  Iterable<PlantData> selectedPlants = [];
                  if (plantsListState is PlantsListLoaded) {
                    plantsSelected = plantsListState.selectedPlants.length > 0;
                    selectedPlants = plantsListState.selectedPlants;
                  }
                  return Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                        height: 56,
                        child: Material(
                          elevation: plantsSelected == true ? 5 : 0,
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            onTap: plantsSelected == true
                                ? () {
                                    print("Search For Companions Tapped");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchForCompanionsPage(
                                                    plants: selectedPlants)));
                                  }
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 8),
                                Icon(
                                  Icons.search,
                                  size: 40,
                                  color: plantsSelected == true
                                      ? ColorPalette.primaryColor
                                      : ColorPalette.disabledColor,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Search For Companions",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: plantsSelected == true
                                        ? ColorPalette.primaryColor
                                        : ColorPalette.disabledColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                      SizedBox(width: 32),
                      badges.Badge(
                        badgeStyle: badges.BadgeStyle.new(
                            badgeColor: ColorPalette.primaryTextColor,
                            padding: EdgeInsets.all(8)),
                        badgeContent: Text(
                          plantsListState is PlantsListLoaded
                              ? plantsListState.selectedPlants.length.toString()
                              : "-",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: ColorPalette.cardColor),
                        ),
                        position:
                            badges.BadgePosition.topStart(top: -10, start: -10),
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Material(
                            elevation: 5, // Now applies actual elevation
                            borderRadius: BorderRadius.circular(15),
                            color: ColorPalette.cardColor, // Background color
                            child: IconButton(
                              onPressed: _showSelectedPlantsDialog,
                              style: IconButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              icon: const Icon(
                                Icons.book_outlined,
                                size: 40,
                                color:
                                    ColorPalette.primaryTextColor, // Icon color
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    ));
  }

  _showSelectedPlantsDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Selected Plants",
                    style: TextStyles.dialogTitleStyle,
                  ),
                  SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: BlocProvider.of<PlantsListBloc>(context)
                        .selectedPlants
                        .length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(BlocProvider.of<PlantsListBloc>(context)
                              .selectedPlants
                              .elementAt(index)
                              .name),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 8);
                    },
                  ),
                  SizedBox(height: 16),
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: ColorPalette.deleteColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Close"))
                ],
              ),
            ),
          );
        });
  }

  _showFiltersBottomSheet(BuildContext globalContext) {
    showModalBottomSheet(
        context: context,
        builder: (context) => BlocProvider.value(
              value: BlocProvider.of<PlantsListBloc>(globalContext),
              child: BottomSheet(
                  onClosing: () => print("Filters Bottom Sheet Closed"),
                  builder: (context) =>
                      BlocBuilder<PlantsListBloc, PlantsListState>(
                        builder: (context, state) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 16),
                              Container(),
                              Stack(
                                children: [
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Filters",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: ColorPalette.primaryTextColor),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.close_rounded)),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: PlantType.values.length,
                                  itemBuilder: (context, index) {
                                    PlantType plantType =
                                        PlantType.values.elementAt(index);
                                    return RadioMenuButton(
                                        value: plantType,
                                        groupValue: context
                                            .read<PlantsListBloc>()
                                            .filter,
                                        onChanged: (PlantType? newFilter) {
                                          print("Set New Filter: $newFilter");
                                          context.read<PlantsListBloc>().add(
                                              PlantsListFilterChanged(
                                                  newFilter!));
                                        },
                                        child: Text(plantType.name));
                                  }),
                            ],
                          );
                        },
                      )),
            ));
  }

  _showSortingDialog(BuildContext globalContext) {
    showModalBottomSheet(
        context: context,
        builder: (context) => BlocProvider.value(
              value: BlocProvider.of<PlantsListBloc>(globalContext),
              child: BottomSheet(
                  onClosing: () => print("Sorting Bottom Sheet Closed"),
                  builder: (context) =>
                      BlocBuilder<PlantsListBloc, PlantsListState>(
                        builder: (context, state) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 16),
                              Container(),
                              Stack(
                                children: [
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Sorting",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: ColorPalette.primaryTextColor),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.close_rounded)),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              RadioMenuButton(
                                  value: SortingDirection.ascending,
                                  groupValue: context
                                      .read<PlantsListBloc>()
                                      .sortingDirection,
                                  onChanged:
                                      (SortingDirection? newSortingDirection) {
                                    print(
                                        "Set Sorting Direction: $newSortingDirection");
                                    context.read<PlantsListBloc>().add(
                                        PlantsListSortingChanged(
                                            newSortingDirection!));
                                  },
                                  child: const Text("Ascending")),
                              RadioMenuButton(
                                  value: SortingDirection.descending,
                                  groupValue: context
                                      .read<PlantsListBloc>()
                                      .sortingDirection,
                                  onChanged:
                                      (SortingDirection? newSortingDirection) {
                                    print(
                                        "Set Sorting Direction: $newSortingDirection");
                                    context.read<PlantsListBloc>().add(
                                        PlantsListSortingChanged(
                                            newSortingDirection!));
                                  },
                                  child: const Text("Descending"))
                            ],
                          );
                        },
                      )),
            ));
  }

  Widget _grownInCountryWidget(PlantData plant) {
    IsPlantGrown? grownInUserCountry = isPlantGrown(plant);
    switch (grownInUserCountry) {
      case IsPlantGrown.grown:
        {
          return Row(
            children: [
              Icon(
                Icons.check,
                color: ColorPalette.primaryColor,
              ),
              SizedBox(width: 4),
              Text(
                "Grown In Your Country",
                style: TextStyle(
                    fontSize: 14,
                    color: ColorPalette.primaryColor,
                    fontWeight: FontWeight.w700),
              ),
            ],
          );
        }
      case IsPlantGrown.notGrown:
        {
          return Row(
            children: [
              Icon(
                Icons.check,
                color: ColorPalette.deleteColor,
              ),
              SizedBox(width: 4),
              Text(
                "Not Grown In Your Country",
                style: TextStyle(
                    fontSize: 14,
                    color: ColorPalette.deleteColor,
                    fontWeight: FontWeight.w700),
              ),
            ],
          );
        }
      default:
        return Container();
    }
  }
}
