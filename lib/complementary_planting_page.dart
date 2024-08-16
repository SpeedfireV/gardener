import 'package:flutter/material.dart';

import 'constants/colors.dart';

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
      child: ListView(
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
                      Icons.arrow_back_ios_rounded,
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
                onChanged: (query) {},
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
              Expanded(
                  child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(15),
                      color: ColorPalette.cardColor,
                      child: InkWell(
                        onTap: () {
                          debugPrint("Filter Tapped");
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.filter_list_rounded,
                                    color: ColorPalette.primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Filter",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: ColorPalette.primaryColor,
                                    ),
                                  )
                                ])),
                      ))),
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
        ],
      ),
    ));
  }
}
