import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/preferences.dart';
import 'package:teslamate/screens/home.dart';
import 'package:teslamate/utils/custom_colors.dart';
import 'package:teslamate/utils/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, String?> data = {};
  late bool isAnonymous;
  late bool isApiProtected;
  late String username;
  late String password;
  late String wwwusername;
  late String wwwpassword;
  late String api;

  Future onSave() async {
    _formKey.currentState?.save();
    Preferences preferences = Provider.of<Preferences>(context, listen: false);
    if (data['api'] != null) {
      await preferences.setApi(data['api'] ?? "");
      await preferences.setIsApiProtected(isApiProtected);
      if (isApiProtected && data['wwwpassword'] != null && data['wwwusername'] != null) {
        await preferences.setApiUsername(data['wwwusername'] ?? "");
        await preferences.setApiPassword(data['wwwpassword'] ?? "");
      }
      await preferences.setPrefsExist(true);
    }
    Navigator.of(context).pushReplacement(createRoute(const Home()));
  }

  @override
  void initState() {
    Preferences preferences = Provider.of(context, listen: false);
    api = preferences.api;
    isApiProtected = preferences.isApiProtected;
    wwwusername = preferences.apiUsername;
    wwwpassword = preferences.apiPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.apiOptions,
                  style: Theme.of(context).textTheme.headline6,
                ),
                TextFormField(
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.url,
                  initialValue: api,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.apiLink,
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CustomColors.red)),
                    floatingLabelStyle: const TextStyle(color: CustomColors.red),
                  ),
                  onSaved: (newValue) {
                    data['api'] = newValue;
                  },
                ),
                Row(
                  children: [
                    Text(AppLocalizations.of(context)!.protectedApi),
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith((states) => CustomColors.red),
                      value: isApiProtected,
                      onChanged: (bool? value) {
                        setState(() {
                          isApiProtected = value!;
                        });
                      },
                    ),
                  ],
                ),
                if (isApiProtected)
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(right: 2),
                          child: TextFormField(
                            enableSuggestions: false,
                            autocorrect: false,
                            initialValue: wwwusername,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.username,
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CustomColors.red)),
                              floatingLabelStyle: const TextStyle(color: CustomColors.red),
                            ),
                            onSaved: (newValue) {
                              data['wwwusername'] = newValue;
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(left: 2),
                          child: TextFormField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            initialValue: wwwpassword,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.password,
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: CustomColors.red)),
                              floatingLabelStyle: const TextStyle(color: CustomColors.red),
                            ),
                            onSaved: (newValue) {
                              data['wwwpassword'] = newValue;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                Container(margin: const EdgeInsets.only(top: 40)),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: ElevatedButton(
                    onPressed: () async {
                      await onSave();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        AppLocalizations.of(context)!.save,
                        textAlign: TextAlign.center,
                      ),
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
}
