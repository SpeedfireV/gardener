import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gardener/bloc/search_for_companions/potential_companions_bloc.dart';
import 'package:gardener/constants/colors.dart';
import 'package:gardener/constants/styles.dart';
import 'package:shimmer/shimmer.dart';

import 'models/plant_data.dart';

class SearchForCompanionsPage extends StatefulWidget {
  const SearchForCompanionsPage({super.key, required this.plants});
  final Iterable<PlantData> plants;

  @override
  State<SearchForCompanionsPage> createState() =>
      _SearchForCompanionsPageState();
}

class _SearchForCompanionsPageState extends State<SearchForCompanionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView(
        children: [
          SizedBox(height: 12),
          Row(
            children: [
              BackButton(),
              Expanded(
                child: Center(
                  child: Text(
                    "Companion Plants",
                    style: TextStyles.titleTextStyle,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          Material(
            color: ColorPalette.cardColor,
            elevation: 5,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  Text(
                    "Selected Plants",
                    style: TextStyles.dialogTitleStyle,
                  ),
                  SizedBox(height: 24),
                  ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        PlantData plant = widget.plants.elementAt(index);
                        return Center(
                          child: RichText(
                            text: TextSpan(
                                style: const TextStyle(
                                    color: ColorPalette.primaryTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                                children: [
                                  TextSpan(
                                      text: plant.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  const TextSpan(text: " | "),
                                  TextSpan(text: plant.latin)
                                ]),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 8),
                      itemCount: widget.plants.length),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Material(
            color: ColorPalette.cardColor,
            elevation: 5,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  Text(
                    "Potential Companions",
                    style: TextStyles.dialogTitleStyle,
                  ),
                  SizedBox(height: 24),
                  BlocBuilder<PotentialCompanionsBloc,
                      PotentialCompanionsState>(builder: (context, state) {
                    if (state is PotentialCompanionsLoaded) {
                      return SizedBox(
                        height: 600,
                        child: Markdown(
                          data: state.gptResponse,
                          styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                  color: ColorPalette.primaryTextColor,
                                  fontWeight: FontWeight.w400)),
                        ),
                      );
                    } else if (state
                        is PotentialCompanionsSearchingForCompanions) {
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
                    } else {
                      return Text("Other State");
                    }
                  })
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PotentialCompanionsBloc>(context)
        .add(PotentialCompanionsFindCompanions(widget.plants));
  }
}
