import 'package:flutter/material.dart';
import 'package:gardener/complementary_planting_page.dart';
import 'package:gardener/constants/colors.dart';
import 'package:gardener/home_page.dart';
import 'package:gardener/plants_handbook_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorPalette.primaryColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  DrawerButton(
                      label: "Home",
                      iconData: Icons.home_outlined,
                      function: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      }),
                  SizedBox(height: 24),
                  DrawerButton(
                    label: "Plants Handbook",
                    iconData: Icons.book_sharp,
                    function: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlantsHandbookPage()));
                    },
                  ),
                  SizedBox(height: 24),
                  DrawerButton(
                      label: "Complementary Plants",
                      iconData: Icons.add_rounded,
                      function: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ComplementaryPlantingPage()));
                      }),
                  // SizedBox(height: 24),
                  // DrawerButton(
                  //   label: "Sensors",
                  //   iconData: Icons.sensors,
                  //   function: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => HomePage()));
                  //   },
                  // ),
                  // SizedBox(height: 24),
                  // DrawerButton(
                  //     label: "Gardener Shop",
                  //     iconData: Icons.shopping_bag_outlined,
                  //     function: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => HomePage()));
                  //     }),
                ],
              ),
            ),
            DrawerButton(
              label: "Settings",
              iconData: Icons.settings,
              function: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            )
          ],
        ),
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  const DrawerButton(
      {super.key,
      required this.label,
      required this.iconData,
      required this.function});
  final String label;
  final IconData iconData;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: ColorPalette.complementaryColor,
      child: InkWell(
        onTap: function,
        child: SizedBox(
          height: 70,
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                iconData,
                size: 40,
                color: ColorPalette.cardColor,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                    fontSize: 18,
                    color: ColorPalette.cardColor,
                    fontWeight: FontWeight.w900),
              )
            ],
          ),
        ),
      ),
    );
  }
}
