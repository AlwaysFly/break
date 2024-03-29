# Change Log

Hi, below is all the changes from my project, ~~Herakles~~ Break, after version 0.3.0.

## Unreleased (0.3.8)
### New Features & Screens

### Bug Fix & Refactor

## [0.3.7] - October 26th, 2021
### New Features & Screens
- Enable users to edit [Nutrition] entry
- Implement Material You Theme with Android

### Bug Fix & Refactor
- Fix Android's back button issue
- Fix Miniplayer's size issue for all devices
- Fix Android (especially Pixel)'s full screen issue

## [0.3.6] - October 8th, 2021
### New Features & Screens
- Combined [SearchTab] and [WatchTab] to one and named it [ExploreTab]
- Created [EatsTab] that displays the nutritions
- Create [SecondPreviewScreen]
- Update [PreviewScreen] to display more features

### Bug Fix & Refactor
- Refactored and redesigned RoutineDetailScreen 
- Refactored and redesigned EditRoutineScreen
- Updated to Flutter 2.5.0
- Update dependencies (major updates):
  - Provider from 5.0.0 to 6.0.0
  - kakao_flutter_sdk from 0.6.3 to 0.8.1
  - firebase_core from 1.6.0 to 1.7.0
- Added label to [BottomNavigationBar]
- Changed the name of the app to Break from Herakles
- Changed the app's logo
- Created `theme_colors.dart` and `custom_theme_data.dart` for stypes
- Update `README.md`
- Change iOS's package name to `com.nextsportif.break`  

## [0.3.5] - September 4th, 2021
### New Features
- Added Watch Tab, where users can find YouTube videos to workout with. 

### Bug Fix & Refactor
- Rearchitectured the entire project to implement (kind of?) MVVM architecture.
- Created exports to simplify imports list
- Use flutter_lints for more flutter specific linting rules
- Refactored Miniplayer so that it works with video as well
- Fixed automaticallyImplyBackButton issue on Search Tab
- Update Readme.md
- Removed Settings tab from TabItem and put under Library Tab

## [0.3.4] - August 8th, 2021
### New Features
- Added features to add calories, carbs, fat amount in AddNutritionScreen
- Added more widgets to progressTab: WeeklyCarbsChart, WeeklyFatChart, WeeklyCaloriesChart

### Bug Fix & Refactor
- Refactored AddMeasurementsScreen with ChangeNotifierProvider (riverpod)
- Refactored AddNutritionScreen with ChangeNotifierProvider (riverpod)
- Added unitOfMassEnum to User class
- Refactoed some logic for Nutrition class to take mealType as enum rather than string
- Refactored weeklyBarChart and personalGoalScreen to act as templates so that I can easily add new screen/widgets
- Changed the way user select goals in personalGoalScreen
- Implemented staggered transition to signInScreen using SlideAnimation and Opacity
- Updated README.md
- Created reusable TextFieldWidget and TextFieldModels
- Refactored and added some animation to CreateRoutineScreen
- Created resuable `OffsetOpacityAnimatedContainer` and `AnimatedListViewBuilder` widgets
- Build custom fade route transition
- Changed ui and refactored email signin/signUp page
- Delete health package and HealthKit related configs from the project
- Refactor LogRoutineScreen
- Create Formatter for routine, unitOfMass related stuff

## [0.3.3] - July 22nd, 2021
### New Features
- Added Weekly Workout Widget (smaller and simpler version than before)
- Enabled users to reorder progress tab's widgets using reorderables package
- Added Recent Workout Wiget
- Added Recent Body Fat Widget and Bodyweight widget
- Changed preview widget (remove pageview and use AnimatedSwitcher to automatically showcase different widgets every 4 seconds)
- Enabled users to add multiple workouts to routine at once
- Enabed users to add or remove progress tab widgets

### Bug Fix & Refactor
- Refactored CreateNewRoutineScreen with ChangeNotifierProvider (riverpod)
- Refactored ProgressTab's widgets with ChangeNotifierProvider (riverpod)
- Combined 6 streams on progress tab with RxDart
- Stopped using implicitly_animated_reorderable_list because of an error
- Fixed layour problems with smaller-screened phones
- Refactored RoutineWorkoutCard and WorkoutSetWidget with ChangeNotifierProvider (riverpod)
- Changed ui of charts when there is no data
- Refactored HomeScreen with ChangeNotifierProvider (riverpod) 

## [0.3.2] - July 13th, 2021
### New Feautres
- Added button and screen to reorder routine workouts on routines
- Added features to set weight goal & added RecentWeightWidget on ProgressTab
- Added features to set Body Fat Percentage goal & added RecentBodyFatWidget on ProgressTab

### Bug Fix & Refactor
- Refactored AddWorkoutToRoutineScreen with ChangeNotifierProvider (riverpod)
- Changed the layout of progress tab to fit like a grid
- Used RxDart to combine two streams on DailyActivityRing
- Used ImplicitlyAnimatedList to list WorkoutSets and RoutineWorkoutCard
- Refactored WeeklyNutritionCard and WeeklyNutritionChart
- Refactored WeeklyMeasurementsCard and WeeklyMeasurementsChart

## [0.3.1] - July 2nd, 2021
### New Features
- Changed preview screen (simpler than before)
- Enable users to pick date for daily progress tab using table_calendar library
- Show MaterialBanner if protein goal or lifting goal is not set
- Added screens and features to add daily protein and lifting goal
- Showed horizontal line of the goal on the weekly chart
- Enable users to choose different background for progress tab

### Bug Fix & Refactor
- Fixed search bar error (went from Algolia Premium to basic so had to disable personalization)
- Implemented Sign In screen model with riverpod and ChangeNotifier (separated model and ui code)
- Added InfoPlist.strings to localize iOS messages
- Refactored styles files to create TextStyles.dart

[0.3.7]: https://github.com/heeyunlee/break/compare/57c61659ebbd5b9743f01c7e7ef0c263888441d8..400012cdcc0766a30df9c3fd16a02b8708dcb5a9
[0.3.6]: https://github.com/heeyunlee/break/compare/054a3316c3963866a36a2a6a8ea155120acbfd78..57c61659ebbd5b9743f01c7e7ef0c263888441d8
[0.3.5]: https://github.com/heeyunlee/herakless/compare/054a3316c3963866a36a2a6a8ea155120acbfd78..c308a8db5953b879f62334f6b045e489058e23f7
[0.3.4]: https://github.com/heeyunlee/herakless/compare/054a3316c3963866a36a2a6a8ea155120acbfd78..c308a8db5953b879f62334f6b045e489058e23f7
[0.3.3]: https://github.com/heeyunlee/herakless/compare/ea1d7a2abec9c652e2e508e1326df011b1ab2e8b..054a3316c3963866a36a2a6a8ea155120acbfd78
[0.3.2]: https://github.com/heeyunlee/herakless/compare/db5c6992dcc41fd9f5f11160333509e97fa42019..ea1d7a2abec9c652e2e508e1326df011b1ab2e8b
[0.3.1]: https://github.com/heeyunlee/herakless/compare/42acc8b1464d163177826bd24b6bd69e9f883173..db5c6992dcc41fd9f5f11160333509e97fa42019