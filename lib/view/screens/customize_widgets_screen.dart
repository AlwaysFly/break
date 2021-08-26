import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/models/combined/auth_and_database.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/customize_widgets_screen_model.dart';

class CustomizeWidgetsScreen extends StatefulWidget {
  final User user;
  final CustomizeWidgetsScreenModel model;
  final AuthAndDatabase authAndDatabase;

  const CustomizeWidgetsScreen({
    Key? key,
    required this.user,
    required this.model,
    required this.authAndDatabase,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required User user,
  }) {
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final database = provider.Provider.of<Database>(context, listen: false);

    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => Consumer(
          builder: (context, watch, child) => CustomizeWidgetsScreen(
            user: user,
            model: watch(customizeWidgetsScreenModelProvider),
            authAndDatabase: AuthAndDatabase(auth: auth, database: database),
          ),
        ),
      ),
    );
  }

  @override
  _CustomizeWidgetsScreenState createState() => _CustomizeWidgetsScreenState();
}

class _CustomizeWidgetsScreenState extends State<CustomizeWidgetsScreen> {
  @override
  void initState() {
    super.initState();

    widget.model.init(widget.authAndDatabase, widget.user);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        flexibleSpace: const AppbarBlurBG(),
        backgroundColor: Colors.transparent,
        leading: const AppBarCloseButton(),
        title: Text(S.current.addOrRemoveWidgets, style: TextStyles.subtitle2),
      ),
      body: Builder(builder: (context) => _buildBody(context)),
      floatingActionButton: SizedBox(
        width: size.width - 32,
        child: FloatingActionButton.extended(
          onPressed: () => widget.model.submit(context),
          label: Text(S.current.submit, style: TextStyles.button1),
          backgroundColor: kPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: Scaffold.of(context).appBarMaxHeight! + 16,
          bottom: 120,
          left: 16,
          right: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.customizeWidgetsTitle,
              style: TextStyles.subtitle1,
            ),
            const SizedBox(height: 8),
            Text(
              S.current.customizeWidgetsMessage,
              style: TextStyles.subtitle2_grey,
            ),
            ...widget.model.currentPreviewWidgetList.map(
              (value) {
                final key =
                    value.key.toString().replaceAll(RegExp(r'[^\w\s]+'), '');
                final hasKey = widget.model.widgetKeysList.contains(key);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Stack(
                    children: [
                      value,
                      Positioned.fill(
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: hasKey
                                ? Border.all(color: kPrimaryColor)
                                : Border.all(width: 0),
                            borderRadius: BorderRadius.circular(24),
                            color: hasKey
                                ? kPrimaryColor.withOpacity(0.1)
                                : Colors.transparent,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () => widget.model.onTap(key),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: hasKey
                                      ? const Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: kPrimaryColor,
                                          size: 32,
                                        )
                                      : const Icon(
                                          Icons.circle_outlined,
                                          size: 32,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ],
        ),
      ),
    );
  }
}