import 'package:flutter/material.dart';
import 'package:productapp/constants/constants.dart';

class ShareNavgiationBar extends StatelessWidget {
  final int currIndex;
  const ShareNavgiationBar({super.key, required this.currIndex});
  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (currIndex != index) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        break;
      case 1:
        if (currIndex != index) {
          Navigator.pushReplacementNamed(context, '/catalog');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final consts = Constants();
    return BottomNavigationBar(
      selectedItemColor: consts.primaryColor,
      unselectedItemColor: consts.secondColor,
      backgroundColor: consts.barColor,
      currentIndex: currIndex,
      onTap: (index) => _onTap(context, index),
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: consts.primaryColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.more),
            label: "Catalog",
            backgroundColor: consts.primaryColor),
      ],
    );
  }
}
