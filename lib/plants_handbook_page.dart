import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gardener/bloc/search_bloc.dart';
import 'package:gardener/models/plant_data.dart';

import 'bloc/firestore_bloc.dart';
import 'colors.dart';
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

    debugPrint("Load Plants Event Added");
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
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
                      debugPrint("Sort By Tapped");
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
                                "Sort By",
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
                context.read<SearchBloc>().add(FilterChanged(PlantType.all));
                return BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, searchState) {
                    if (searchState is SearchFiltered) {
                      print(searchState.filteredPlants);
                      Map<String, List<PlantData>> plantsByLetters =
                          _dividePlantsByFirstLetter(
                              searchState.filteredPlants);
                      Iterable<String> letters = plantsByLetters.keys;
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, letterIndex) {
                            String currentLetter =
                                letters.elementAt(letterIndex);
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
                                        print("Current letter: $currentLetter");
                                        return Material(
                                          elevation: 5,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: ColorPalette.cardColor,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            child: Row(
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
                                                              FontWeight.w300),
                                                      children: [
                                                        TextSpan(
                                                            text: plantsByLetters[
                                                                    letters.elementAt(
                                                                        letterIndex)]!
                                                                .elementAt(
                                                                    index)
                                                                .name,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                        const TextSpan(
                                                            text: " | "),
                                                        TextSpan(
                                                            text: plantsByLetters[
                                                                    letters.elementAt(
                                                                        letterIndex)]!
                                                                .elementAt(
                                                                    index)
                                                                .latin)
                                                      ]),
                                                ),
                                                SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: Material(
                                                    elevation: 5,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: ColorPalette
                                                        .primaryColor,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        debugPrint(
                                                            "Plant Info Tapped");
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                        size: 24,
                                                        color: ColorPalette
                                                            .cardColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                debugPrint(firestoreState.errorMessage);
                return const Text("Error loading data");
              }
              return const CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }

  _showFiltersDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => BlocProvider.value(
              value: BlocProvider.of<SearchBloc>(context),
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
                                    print("$newFilter");
                                    context
                                        .read<SearchBloc>()
                                        .add(FilterChanged(newFilter!));
                                  },
                                  child: const Text("All")),
                              RadioMenuButton(
                                  value: PlantType.vegetable,
                                  groupValue: context.read<SearchBloc>().filter,
                                  onChanged: (PlantType? newFilter) {
                                    print("$newFilter");
                                    context
                                        .read<SearchBloc>()
                                        .add(FilterChanged(newFilter!));
                                  },
                                  child: const Text("Vegetables")),
                              RadioMenuButton(
                                  value: PlantType.fruit,
                                  groupValue: context.read<SearchBloc>().filter,
                                  onChanged: (PlantType? newFilter) {
                                    print("$newFilter");
                                    context
                                        .read<SearchBloc>()
                                        .add(FilterChanged(newFilter!));
                                  },
                                  child: const Text("Fruits"))
                            ],
                          );
                        },
                      )),
            ));
  }

  _showSortingDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => BlocProvider.value(
              value: BlocProvider.of<SearchBloc>(context),
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
                                    print("$newSortingDirection");
                                    context.read<SearchBloc>().add(
                                        SortingChanged(newSortingDirection!));
                                  },
                                  child: const Text("Ascending")),
                              RadioMenuButton(
                                  value: SortingDirection.descending,
                                  groupValue: context
                                      .read<SearchBloc>()
                                      .sortingDirection,
                                  onChanged:
                                      (SortingDirection? newSortingDirection) {
                                    print("$newSortingDirection");
                                    context.read<SearchBloc>().add(
                                        SortingChanged(newSortingDirection!));
                                  },
                                  child: const Text("Descending"))
                            ],
                          );
                        },
                      )),
            ));
  }

  Map<String, List<PlantData>> _dividePlantsByFirstLetter(
      Iterable<PlantData> plants) {
    Map<String, List<PlantData>> dividedPlants = {};
    for (PlantData plantData in plants) {
      String firstLetter = plantData.name.substring(0, 1);
      if (dividedPlants.containsKey(firstLetter)) {
        dividedPlants[firstLetter]!.add(plantData);
      } else {
        dividedPlants[firstLetter] = [plantData];
      }
    }
    print(dividedPlants);
    return dividedPlants;
  }
}
