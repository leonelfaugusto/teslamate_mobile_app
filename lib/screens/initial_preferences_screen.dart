import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslamate/classes/preferences.dart';
import 'package:teslamate/utils/mqtt_client_wrapper.dart';
import 'package:teslamate/utils/routes.dart';

class InitialPreferencesScreen extends StatefulWidget {
  const InitialPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<InitialPreferencesScreen> createState() => _InitialPreferencesScreenState();
}

class _InitialPreferencesScreenState extends State<InitialPreferencesScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, String?> data = {};
  late String mqtt;
  late String api;

  Future onSave() async {
    _formKey.currentState?.save();
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    MqttServerClient client = Provider.of<MqttClientWrapper>(context, listen: false).client;
    client.disconnect();
    if (data['api'] != null && data['mqtt'] != null) {
      await _prefs.setString("api", data['api'] as String);
      await _prefs.setString("mqtt", data['mqtt'] as String);
      await _prefs.setBool("prefsExist", true);
    }
    await fetchPreferences(context);
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  @override
  void initState() {
    Preferences preferences = Provider.of(context, listen: false);
    api = preferences.api;
    mqtt = preferences.mqqt;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: api,
                decoration: const InputDecoration(
                  labelText: 'API',
                ),
                onSaved: (newValue) {
                  data['api'] = newValue;
                },
              ),
              TextFormField(
                initialValue: mqtt,
                decoration: const InputDecoration(
                  labelText: 'MQTT',
                ),
                onSaved: (newValue) {
                  data['mqtt'] = newValue;
                },
              ),
              ElevatedButton(
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
            ],
          ),
        ),
      ),
    );
  }
}
