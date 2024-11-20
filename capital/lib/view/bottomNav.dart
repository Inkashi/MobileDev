import 'package:flutter/material.dart';
import 'package:capital/constants/constants.dart';

class ShareNavgiationBar extends StatelessWidget {
  final int currIndex;
  const ShareNavgiationBar({super.key, required this.currIndex});
  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 1:
        if (currIndex != index) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        break;
      case 0:
        if (currIndex != index) {
          Navigator.pushReplacementNamed(
            context,
            '/money',
            arguments: {
              'criteria': true,
            },
          );
        }
        break;
      case 2:
        if (currIndex != index) {
          Navigator.pushReplacementNamed(
            context,
            '/money',
            arguments: {
              'criteria': false,
            },
          );
        }
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
            icon: const Icon(Icons.trending_up),
            label: "Доходы",
            backgroundColor: consts.primaryColor),
        BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: "Главная",
            backgroundColor: consts.primaryColor),
        BottomNavigationBarItem(
            icon: const Icon(Icons.trending_down),
            label: "Траты",
            backgroundColor: consts.primaryColor),
      ],
    );
  }
}
