import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_player/widgets/max_width_raised_button.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../string_validator.dart';

Logger logger = Logger();

const _termsUrl =
    'https://app.termly.io/document/terms-of-use-for-ios-app/94692e31-d268-4f30-b710-2eebe37cc750';
const _privacyServiceUrl =
    'https://app.termly.io/document/privacy-policy/34f278e4-7150-48c6-88c0-ee9a3ee082d1';

void _launchTermsURL() async => await canLaunch(_termsUrl)
    ? await launch(_termsUrl)
    : throw 'Could not launch $_termsUrl';

void _launchPrivacyServiceURL() async => await canLaunch(_privacyServiceUrl)
    ? await launch(_privacyServiceUrl)
    : throw 'Could not launch $_privacyServiceUrl';

class EmailSignUpScreen extends StatefulWidget with EmailAndPasswordValidators {
  final AuthBase auth;
  final Database database;

  EmailSignUpScreen({Key key, this.auth, this.database}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: false).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => EmailSignUpScreen(
          auth: auth,
          database: database,
        ),
      ),
    );
  }

  @override
  _EmailSignUpScreenState createState() => _EmailSignUpScreenState();
}

class _EmailSignUpScreenState extends State<EmailSignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _textController1;
  TextEditingController _textController2;
  TextEditingController _textController3;
  TextEditingController _textController4;

  FocusNode _focusNode1;
  FocusNode _focusNode2;
  FocusNode _focusNode3;
  FocusNode _focusNode4;

  String get _email => _textController1.text;
  String get _firstName => _textController2.text;
  String get _lastName => _textController3.text;
  String get _password => _textController4.text;
  bool submitted = false;

  @override
  void initState() {
    super.initState();
    _textController1 = TextEditingController();
    _textController2 = TextEditingController();
    _textController3 = TextEditingController();
    _textController4 = TextEditingController();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
    _focusNode4 = FocusNode();
  }

  @override
  void dispose() {
    _textController1.dispose();
    _textController2.dispose();
    _textController3.dispose();
    _textController4.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();

    super.dispose();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate() ?? false) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submitLogIn() async {
    print('_submitLogIn pressed');
    if (_validateAndSaveForm()) {
      setState(() {
        submitted = true;
      });

      try {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);

        final firebaseUser = widget.auth.currentUser;
        final uniqueId = UniqueKey().toString();
        final id = 'Player $uniqueId';
        final currentTime = Timestamp.now();
        final locale = Intl.getCurrentLocale();

        final user = User(
          userId: firebaseUser.uid,
          displayName: '$_firstName $_lastName' ?? id,
          userName: firebaseUser.providerData[0].displayName ?? id,
          userEmail: firebaseUser.providerData[0].email,
          signUpDate: currentTime,
          signUpProvider: firebaseUser.providerData[0].providerId,
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: currentTime,
          dailyWorkoutHistories: [],
          dailyNutritionHistories: [],
        );

        await widget.database.setUser(user);
        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        logger.d(e);
        _showSignInError(e, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(S.current.signUp, style: Subtitle2),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: BackgroundColor,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final locale = Intl.getCurrentLocale();

    bool _showEmailErrorText =
        submitted && !widget.validator.isEmailValid(_email);
    String _emailErrorText =
        _showEmailErrorText ? widget.invalidEmailText : null;

    bool _showFirstNameErrorText =
        submitted && !widget.validator.isFirstNameValid(_firstName);
    String _firstNameErrorText =
        _showFirstNameErrorText ? S.current.firstNameValidationText : null;

    bool _showLastNameErrorText =
        submitted && !widget.validator.isLastNameValid(_firstName);
    String _lastNameErrorText =
        _showLastNameErrorText ? S.current.lastNameValidationText : null;

    bool _showPaswordErrorText =
        submitted && !widget.validator.isPasswordValid(_password);
    String _passwordErrorText =
        _showPaswordErrorText ? widget.emptyPasswordText : null;

    return KeyboardActions(
      config: _buildConfig(),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // EMAIL
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.current.emailAddress, style: Subtitle2),
                ),
                TextFormField(
                  autofocus: true,
                  enableSuggestions: false,
                  focusNode: _focusNode1,
                  controller: _textController1,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: SecondaryColor),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    errorText: _emailErrorText,
                    hintText: 'JohnDoe@abc.com',
                    hintStyle: BodyText1Grey,
                    suffixIcon: _focusNode1.hasFocus
                        ? GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              _textController1.clear();
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  style: BodyText1Bold,
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 8),

                // FIRST NAME
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.current.firstName, style: Subtitle2),
                ),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: true,
                  focusNode: _focusNode2,
                  controller: _textController2,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: SecondaryColor),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    errorText: _firstNameErrorText,
                    hintText: S.current.firstNameHintText,
                    hintStyle: BodyText1Grey,
                    suffixIcon: _focusNode2.hasFocus
                        ? GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              _textController2.clear();
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  style: BodyText1Bold,
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 8),

                // LAST NAME
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.current.lastName, style: Subtitle2),
                ),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: true,
                  focusNode: _focusNode3,
                  controller: _textController3,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: SecondaryColor),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    errorText: _lastNameErrorText,
                    hintText: S.current.lastNameHintText,
                    hintStyle: BodyText1Grey,
                    suffixIcon: _focusNode3.hasFocus
                        ? GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              _textController3.clear();
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  style: BodyText1Bold,
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 8),

                // PASSWORD
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.current.passwordAllCap, style: Subtitle2),
                ),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  obscureText: true,
                  focusNode: _focusNode4,
                  controller: _textController4,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: SecondaryColor),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    errorText: _passwordErrorText,
                    hintText: S.current.passwordHintText,
                    hintStyle: BodyText1Grey,
                    suffixIcon: _focusNode4.hasFocus
                        ? GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              _textController4.clear();
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  style: BodyText1Bold,
                  onChanged: (value) => setState(() {}),
                ),

                const SizedBox(height: 8),

                // PasswordStrengthMeter(),

                // Text(
                //   estimatePasswordStrength(_password).toString(),
                //   style: BodyText1,
                // ),

                // SUBMIT BUTTON
                const SizedBox(height: 36),
                MaxWidthRaisedButton(
                  buttonText: S.current.signUp,
                  onPressed: widget.validator.isEmailValid(_email) &&
                          widget.validator.isPasswordValid(_password) &&
                          widget.validator.isFirstNameValid(_firstName) &&
                          widget.validator.isLastNameValid(_lastName)
                      ? _submitLogIn
                      : null,
                  color: Primary600Color,
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: S.current.acceptingTermsEmail,
                      style: OverlineGrey,
                      children: <TextSpan>[
                        TextSpan(
                          text: S.current.terms,
                          style: OverlineGreyUnderlined,
                          recognizer: TapGestureRecognizer()
                            ..onTap = _launchTermsURL,
                        ),
                        TextSpan(text: S.current.and, style: OverlineGrey),
                        TextSpan(
                          text: S.current.privacyPolicy,
                          style: OverlineGreyUnderlined,
                          recognizer: TapGestureRecognizer()
                            ..onTap = _launchPrivacyServiceURL,
                        ),
                        if (locale == 'ko')
                          TextSpan(
                            text: S.current.acepptingTermsKorean,
                            style: OverlineGrey,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardSeparatorColor: Grey700,
      keyboardBarColor: const Color(0xff303030),
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _focusNode1,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: ButtonText),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _focusNode2,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: ButtonText),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _focusNode3,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: ButtonText),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _focusNode4,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: ButtonText),
                ),
              );
            }
          ],
        ),
      ],
    );
  }

  void _showSignInError(FirebaseException exception, BuildContext context) {
    switch (exception.code) {
      case 'user-not-found':
        showAlertDialog(
          context,
          title: S.current.userNotFound,
          content: S.current.userNotFoundMessage,
          defaultActionText: S.current.ok,
        );
        break;
      case 'wrong-password':
        showAlertDialog(
          context,
          title: S.current.wrongPassword,
          content: S.current.wrongPasswordMessage,
          defaultActionText: S.current.ok,
        );
        break;
      case 'email-already-in-use':
        showAlertDialog(
          context,
          title: S.current.emailAlreadyInUse,
          content: S.current.emailAlreadyInUseMessage,
          defaultActionText: S.current.ok,
        );
        break;
      default:
        showAlertDialog(
          context,
          title: exception.code,
          content: exception.toString(),
          defaultActionText: S.current.ok,
        );
    }
  }
}