import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/dummy_data.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/settings_tab/unit_of_mass_screen.dart';
import 'package:workout_player/screens/settings_tab/user_feedback_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../widgets/show_alert_dialog.dart';
import '../../constants.dart';
import 'change_language_screen.dart';
import 'manage_account_screen.dart';

Logger logger = Logger();

const _termsUrl =
    'https://app.termly.io/document/terms-of-use-for-ios-app/94692e31-d268-4f30-b710-2eebe37cc750';
const _privacyPolicyUrl =
    'https://app.termly.io/document/privacy-policy/34f278e4-7150-48c6-88c0-ee9a3ee082d1';

void _launchTermsURL() async => await canLaunch(_termsUrl)
    ? await launch(_termsUrl)
    : throw 'Could not launch $_termsUrl';

void _launchPrivacyServiceURL() async => await canLaunch(_privacyPolicyUrl)
    ? await launch(_privacyPolicyUrl)
    : throw 'Could not launch $_privacyPolicyUrl';

class SettingsTab extends StatelessWidget {
  Future<void> _signOut(BuildContext context, AuthBase auth) async {
    try {
      // FirebaseCrashlytics.instance.crash();
      await auth.signOut();
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context, AuthBase auth) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: S.current.logout,
      content: S.current.confirmSignOutContext,
      cancelAcitionText: S.current.cancel,
      defaultActionText: S.current.logout,
    );
    if (didRequestSignOut == true) {
      return _signOut(context, auth);
    }
  }

  void _showAboutDialog(BuildContext context) {
    // TODO: Change Version Number
    showAboutDialog(
      context: context,
      applicationName: S.current.applicationName,
      applicationVersion: '0.2.4',
      applicationIcon: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Image.asset(
          'assets/logos/herakless_logo.png',
          width: 36,
          height: 36,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        flexibleSpace: AppbarBlurBG(),
        backgroundColor: Colors.transparent,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.close_rounded,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
        title: Text(S.current.settingsScreenTitle, style: Subtitle1),
      ),
      body: Builder(
        builder: (BuildContext context) => _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<User>(
        initialData: userDummyData,
        stream: database.userStream(auth.currentUser.uid),
        builder: (context, snapshot) {
          final user = snapshot.data;

          return SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: Scaffold.of(context).appBarMaxHeight + 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(S.current.account, style: BodyText2BoldGrey),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: Text(
                      S.current.manageAccount,
                      style: BodyText2,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onTap: () => ManageAccountScreen.show(context, user: user),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.straighten_rounded,
                      color: Colors.white,
                    ),
                    title: Text(S.current.unitOfMass, style: BodyText2),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          UnitOfMass.values[user.unitOfMass].label,
                          style: BodyText2Grey,
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                    onTap: () => UnitOfMassScreen.show(
                      context: context,
                      user: user,
                    ),
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.language_rounded,
                      color: Colors.white,
                    ),
                    title: Text(S.current.launguage, style: BodyText2),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Intl.getCurrentLocale(),
                          style: BodyText2Grey,
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                    onTap: () => ChangeLanguageScreen.show(context),
                  ),

                  // SUPPORT
                  CustomDivider,
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(S.current.support, style: BodyText2BoldGrey),
                  ),
                  ListTile(
                    leading: const Icon(Icons.feedback, color: Colors.white),
                    title: Text(
                      S.current.FeedbackAndFeatureRequests,
                      style: BodyText2,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onTap: () => UserFeedbackScreen.show(context),
                  ),

                  // ABOUT
                  CustomDivider,
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(S.current.about, style: BodyText2BoldGrey),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white,
                    ),
                    title: Text(S.current.about, style: BodyText2),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onTap: () => _showAboutDialog(context),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.policy_outlined,
                      color: Colors.white,
                    ),
                    title: Text(S.current.privacyPolicy, style: BodyText2),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onTap: _launchPrivacyServiceURL,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.description_rounded,
                      color: Colors.white,
                    ),
                    title: Text(S.current.terms, style: BodyText2),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onTap: _launchTermsURL,
                  ),

                  // LOG IN
                  CustomDivider,
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(S.current.logIn, style: BodyText2BoldGrey),
                  ),
                  ListTile(
                    onTap: () => _confirmSignOut(context, auth),
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: Text(S.current.logout, style: BodyText2),
                  ),
                  const Spacer(),
                  // TODO: Change Version HERE
                  Center(child: const Text('v.0.2.4', style: Caption1Grey)),
                  const SizedBox(height: 38),
                ],
              ),
            ),
          );
        });
  }
}