import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';

import '../../../view_models/home_screen_model.dart';
import 'tab_item.dart';

class BottomNavigationTab extends ConsumerWidget {
  const BottomNavigationTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(homeScreenModelProvider);
    final miniplayerModel = watch(miniplayerModelProvider);

    final size = MediaQuery.of(context).size;

    return ValueListenableBuilder<double>(
      valueListenable: miniplayerModel.valueNotifier,
      builder: (context, height, child) => Transform.translate(
        offset: Offset(
          0.0,
          miniplayerModel.getYOffset(
            min: miniplayerMinHeight,
            max: size.height,
            value: miniplayerModel.valueNotifier.value,
          ),
        ),
        child: child,
      ),
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey[800]!,
                width: 0.5,
              ),
            ),
          ),
          child: BottomNavigationBar(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.white,
            currentIndex: model.currentTabIndex,
            selectedLabelStyle: TextStyles.overline_primary,
            unselectedLabelStyle: TextStyles.overline,
            backgroundColor: kBottomNavBarColor,
            selectedItemColor: kPrimaryColor,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              _buildItem(TabItem.progress),
              _buildItem(TabItem.search),
              _buildItem(TabItem.watch),
              _buildItem(TabItem.library),
              // _buildItem(TabItem.settings),
            ],
            onTap: model.onSelectTab,
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem]!;

    return BottomNavigationBarItem(
      label: '',
      icon: Padding(
        padding: EdgeInsets.only(
          left: itemData.leftPadding,
          right: itemData.rightPadding,
        ),
        child: Icon(
          itemData.selectedIcon as IconData,
          size: itemData.size,
        ),
      ),
    );
  }
}