import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gardener/bloc/firestore_bloc.dart';

import 'colors.dart';
import 'drawer.dart';

class PlantsHandbookPage extends StatefulWidget {
  const PlantsHandbookPage({super.key});

  @override
  State<PlantsHandbookPage> createState() => _PlantsHandbookPageState();
}

class _PlantsHandbookPageState extends State<PlantsHandbookPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  void initState() {
    BlocProvider.of<FirestoreBloc>(context).add(LoadPlants());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreBloc _firestoreBloc =
        BlocProvider.of<FirestoreBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      backgroundColor: ColorPalette.backgroundColor,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
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
                hintText: "Find your plant",
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
                              Icon(Icons.filter_list_rounded),
                              SizedBox(width: 8),
                              Text(
                                "Filter",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: ColorPalette.primaryTextColor),
                              )
                            ])),
                  ),
                ),
              ),
              SizedBox(
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
                    },
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
          SizedBox(height: 24),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          String.fromCharCode(index + 65),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: ColorPalette.primaryTextColor),
                        ),
                        SizedBox(height: 4),
                        BlocBuilder<FirestoreBloc, FirestoreState>(
                            builder: (context, state) {
                          return ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Material(
                                    elevation: 5,
                                    borderRadius: BorderRadius.circular(15),
                                    color: ColorPalette.cardColor,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                                style: TextStyle(
                                                    color: ColorPalette
                                                        .primaryTextColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w300),
                                                children: [
                                                  TextSpan(
                                                      text: "Apple",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                  TextSpan(text: " | "),
                                                  TextSpan(text: "Malus pumila")
                                                ]),
                                          ),
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Material(
                                              elevation: 5,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: ColorPalette.primaryColor,
                                              child: IconButton(
                                                onPressed: () {
                                                  debugPrint(
                                                      "Plant Info Tapped");
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  size: 24,
                                                  color: ColorPalette.cardColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 8),
                              itemCount: 5);
                        })
                      ],
                    ),
                  ),
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemCount: 26)
        ],
      ),
    );
  }
}
