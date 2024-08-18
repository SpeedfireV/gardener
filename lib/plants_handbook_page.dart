import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gardener/models/plant_data.dart';
import 'package:gardener/plant_info_page.dart';
import 'package:gardener/utils/formatting.dart';
import 'package:gardener/utils/location.dart';

import 'bloc/plants_handbook_page/firestore_bloc.dart';
import 'bloc/plants_handbook_page/search_bloc.dart';
import 'constants/colors.dart';
import 'constants/enums.dart';
import 'drawer.dart';

class PlantsHandbookPage extends StatefulWidget {
  const PlantsHandbookPage({super.key});

  @override
  State<PlantsHandbookPage> createState() => _PlantsHandbookPageState();
}

class _PlantsHandbookPageState extends State<PlantsHandbookPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    // Dispatch the event here, after the Bloc has been provided

    BlocProvider.of<FirestoreBloc>(context).add(LoadPlants());

    searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    searchController.text = context.read<SearchBloc>().query;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      backgroundColor: ColorPalette.backgroundColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(15),
                  color: ColorPalette.cardColor,
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
                      color: ColorPalette.primaryTextColor,
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
                  context.read<SearchBloc>().add(SearchQueryChanged(query));
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  bool filtered =
                      context.read<SearchBloc>().filter == PlantType.all;
                  return Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(15),
                      color: ColorPalette.cardColor,
                      child: InkWell(
                        onTap: () {
                          debugPrint("Filter Tapped");
                          _showFiltersDialog(context);
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.filter_list_rounded,
                                    color: !filtered
                                        ? ColorPalette.primaryColor
                                        : ColorPalette.primaryTextColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Filter",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: !filtered
                                          ? ColorPalette.primaryColor
                                          : ColorPalette.primaryTextColor,
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
          const SizedBox(height: 8),
          BlocBuilder<FirestoreBloc, FirestoreState>(
            builder: (context, firestoreState) {
              if (firestoreState is PlantsLoaded) {
                context.read<SearchBloc>().setPlants(firestoreState.plants);
                context
                    .read<SearchBloc>()
                    .add(SearchFilterChanged(PlantType.all));
                return BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, searchState) {
                    if (searchState is SearchFiltered) {
                      Map<String, List<PlantData>> plantsByLetters =
                          dividePlantsByFirstLetter(searchState.filteredPlants);
                      Iterable<String> letters = plantsByLetters.keys;
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, letterIndex) {
                            String currentLetter =
                                letters.elementAt(letterIndex);
                            String? expandedCard =
                                context.read<SearchBloc>().expanded;
                            return Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    letters.elementAt(letterIndex),
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: ColorPalette.primaryTextColor),
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
                                                letters.elementAt(letterIndex)]!
                                            .elementAt(index);

                                        return Material(
                                          elevation: 5,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: ColorPalette.cardColor,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            onTap: () {
                                              context.read<SearchBloc>().add(
                                                  SearchCardClicked(
                                                      plant.latin));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
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
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                            children: [
                                                              TextSpan(
                                                                  text: plant
                                                                      .name,
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700)),
                                                              const TextSpan(
                                                                  text: " | "),
                                                              TextSpan(
                                                                  text: plant
                                                                      .latin)
                                                            ]),
                                                      ),
                                                      SizedBox(
                                                        width: 40,
                                                        height: 40,
                                                        child: Material(
                                                          elevation: 5,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: ColorPalette
                                                              .primaryColor,
                                                          child: IconButton(
                                                            style: IconButton
                                                                .styleFrom(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                            ),
                                                            onPressed: () {
                                                              debugPrint(
                                                                  "Plant Info Tapped");
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          PlantInfoPage(
                                                                              plantData: plant)));
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .arrow_forward_ios_rounded,
                                                              size: 28,
                                                              color: ColorPalette
                                                                  .cardColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  plant.latin == expandedCard
                                                      ? Container(
                                                          height: 80,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 4),
                                                          width:
                                                              double.infinity,
                                                          child: RawScrollbar(
                                                            controller:
                                                                expandedScrollController,
                                                            thumbVisibility:
                                                                true,
                                                            thumbColor:
                                                                ColorPalette
                                                                    .primaryColor,
                                                            radius:
                                                                Radius.circular(
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
                                                                        Icons
                                                                            .schedule_rounded,
                                                                        color: ColorPalette
                                                                            .primaryTextColor,
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              4),
                                                                      RichText(
                                                                        text: TextSpan(
                                                                            style: const TextStyle(
                                                                                color: ColorPalette.primaryTextColor,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w700),
                                                                            children: [
                                                                              TextSpan(text: "Growing Time ", style: const TextStyle(fontWeight: FontWeight.w400)),
                                                                              TextSpan(text: "${plant.growingTime.min.toInt()}-${plant.growingTime.max.toInt()} weeks")
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
                                                                        Icons
                                                                            .thermostat,
                                                                        color: ColorPalette
                                                                            .primaryTextColor,
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              4),
                                                                      RichText(
                                                                        text: TextSpan(
                                                                            style: const TextStyle(
                                                                                color: ColorPalette.primaryTextColor,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w700),
                                                                            children: [
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
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "Planting Time",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: ColorPalette.primaryTextColor,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                4),
                                                                        Icon(
                                                                          Icons
                                                                              .info_outline,
                                                                          color:
                                                                              ColorPalette.primaryTextColor,
                                                                          size:
                                                                              20,
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
                                      itemCount: plantsByLetters[currentLetter]!
                                          .length)
                                ],
                              ),
                            );
                          },
                          itemCount: plantsByLetters.length);
                    } else if (searchState is SearchError) {
                      return const Text("Error occured while filtering");
                    }
                    return const Text("Different Bloc State");
                  },
                );
              } else if (firestoreState is PlantsLoading) {
                return const CircularProgressIndicator();
              } else if (firestoreState is PlantsError) {
                return const Text("Error loading data");
              }
              return const CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }

  _showFiltersDialog(BuildContext globalContext) {
    showModalBottomSheet(
        context: context,
        builder: (context) => BlocProvider.value(
              value: BlocProvider.of<SearchBloc>(globalContext),
              child: BottomSheet(
                  onClosing: () => print("Filters Bottom Sheet Closed"),
                  builder: (context) => BlocBuilder<SearchBloc, SearchState>(
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
                              RadioMenuButton(
                                  value: PlantType.all,
                                  groupValue: context.read<SearchBloc>().filter,
                                  onChanged: (PlantType? newFilter) {
                                    print("Set New Filter: $newFilter");
                                    context
                                        .read<SearchBloc>()
                                        .add(SearchFilterChanged(newFilter!));
                                  },
                                  child: const Text("All")),
                              RadioMenuButton(
                                  value: PlantType.vegetable,
                                  groupValue: context.read<SearchBloc>().filter,
                                  onChanged: (PlantType? newFilter) {
                                    print("Set New Filter: $newFilter");
                                    context
                                        .read<SearchBloc>()
                                        .add(SearchFilterChanged(newFilter!));
                                  },
                                  child: const Text("Vegetables")),
                              RadioMenuButton(
                                  value: PlantType.fruit,
                                  groupValue: context.read<SearchBloc>().filter,
                                  onChanged: (PlantType? newFilter) {
                                    print("Set New Filter: $newFilter");
                                    context
                                        .read<SearchBloc>()
                                        .add(SearchFilterChanged(newFilter!));
                                  },
                                  child: const Text("Fruits"))
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
              value: BlocProvider.of<SearchBloc>(globalContext),
              child: BottomSheet(
                  onClosing: () => print("Sorting Bottom Sheet Closed"),
                  builder: (context) => BlocBuilder<SearchBloc, SearchState>(
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
                                      .read<SearchBloc>()
                                      .sortingDirection,
                                  onChanged:
                                      (SortingDirection? newSortingDirection) {
                                    print(
                                        "Set Sorting Direction: $newSortingDirection");
                                    context.read<SearchBloc>().add(
                                        SearchSortingChanged(
                                            newSortingDirection!));
                                  },
                                  child: const Text("Ascending")),
                              RadioMenuButton(
                                  value: SortingDirection.descending,
                                  groupValue: context
                                      .read<SearchBloc>()
                                      .sortingDirection,
                                  onChanged:
                                      (SortingDirection? newSortingDirection) {
                                    print(
                                        "Set Sorting Direction: $newSortingDirection");
                                    context.read<SearchBloc>().add(
                                        SearchSortingChanged(
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
