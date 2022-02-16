import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/preferences.dart';
import 'package:teslamate/screens/home.dart';
import 'package:teslamate/utils/custom_colors.dart';
import 'package:teslamate/utils/mqtt_client_wrapper.dart';
import 'package:teslamate/utils/routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, String?> data = {};
  late String mqtt;
  late int mqttPort;
  late bool isAnonymous;
  late bool isApiProtected;
  late String username;
  late String password;
  late String wwwusername;
  late String wwwpassword;
  late String api;

  Future onSave() async {
    _formKey.currentState?.save();
    MqttClientWrapper clientWapper = Provider.of<MqttClientWrapper>(context, listen: false);
    Preferences preferences = Provider.of<Preferences>(context, listen: false);
    if (clientWapper.connected) clientWapper.client.disconnect();
    if (data['api'] != null && data['mqtt'] != null && data['mqttPort'] != null) {
      await preferences.setApi(data['api'] ?? "");
      await preferences.setMqqt(data["mqtt"] ?? "");
      await preferences.setMqqtPort(int.parse(data["mqttPort"] ?? ""));
      await preferences.setMqttIsAnonymous(!isAnonymous);
      if (isAnonymous && data['password'] != null && data['username'] != null) {
        await preferences.setMqttUsername(data['username'] ?? "");
        await preferences.setMqttPassword(data['password'] ?? "");
      }
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
    mqtt = preferences.mqtt;
    mqttPort = preferences.mqttPort;
    isAnonymous = !preferences.mqttIsAnonymous;
    isApiProtected = preferences.isApiProtected;
    username = preferences.mqttUsername;
    password = preferences.mqttPassword;
    wwwusername = preferences.apiUsername;
    wwwpassword = preferences.apiPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(RoutesTabNames.settings)),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "API options",
                  style: Theme.of(context).textTheme.headline6,
                ),
                TextFormField(
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.url,
                  initialValue: api,
                  decoration: const InputDecoration(
                    labelText: 'API',
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: CustomColors.red)),
                    floatingLabelStyle: TextStyle(color: CustomColors.red),
                  ),
                  onSaved: (newValue) {
                    data['api'] = newValue;
                  },
                ),
                Row(
                  children: [
                    const Text("API com login de proteção"),
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
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: CustomColors.red)),
                              floatingLabelStyle: TextStyle(color: CustomColors.red),
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
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: CustomColors.red)),
                              floatingLabelStyle: TextStyle(color: CustomColors.red),
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
                Text(
                  "MQTT options",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.only(right: 2),
                        child: TextFormField(
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.url,
                          initialValue: mqtt,
                          decoration: const InputDecoration(
                            labelText: 'MQTT url',
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: CustomColors.red)),
                            floatingLabelStyle: TextStyle(color: CustomColors.red),
                          ),
                          onSaved: (newValue) {
                            data['mqtt'] = newValue;
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 2),
                        child: TextFormField(
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          initialValue: mqttPort.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Port',
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: CustomColors.red)),
                            floatingLabelStyle: TextStyle(color: CustomColors.red),
                          ),
                          onSaved: (newValue) {
                            data['mqttPort'] = newValue;
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("MQTT com login"),
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith((states) => CustomColors.red),
                      value: isAnonymous,
                      onChanged: (bool? value) {
                        setState(() {
                          isAnonymous = value!;
                        });
                      },
                    ),
                  ],
                ),
                if (isAnonymous)
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(right: 2),
                          child: TextFormField(
                            enableSuggestions: false,
                            autocorrect: false,
                            initialValue: username,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: CustomColors.red)),
                              floatingLabelStyle: TextStyle(color: CustomColors.red),
                            ),
                            onSaved: (newValue) {
                              data['username'] = newValue;
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
                            initialValue: password,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: CustomColors.red)),
                              floatingLabelStyle: TextStyle(color: CustomColors.red),
                            ),
                            onSaved: (newValue) {
                              data['password'] = newValue;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: ElevatedButton(
                    onPressed: () async {
                      await onSave();
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Gravar',
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
