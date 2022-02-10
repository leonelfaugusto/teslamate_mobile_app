import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/preferences.dart';
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
  late String api;

  Future onSave() async {
    _formKey.currentState?.save();
    MqttServerClient client = Provider.of<MqttClientWrapper>(context, listen: false).client;
    Preferences preferences = Provider.of<Preferences>(context, listen: false);
    client.disconnect();
    if (data['api'] != null && data['mqtt'] != null) {
      await preferences.setApi(data['api'] ?? "");
      await preferences.setMqqt(data["mqtt"] ?? "");
      await preferences.setPrefsExist(true);
    }
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  @override
  void initState() {
    Preferences preferences = Provider.of(context, listen: false);
    api = preferences.api;
    mqtt = preferences.mqtt;
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
      ),
    );
  }
}
