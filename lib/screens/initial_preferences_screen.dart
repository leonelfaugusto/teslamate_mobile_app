import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslamate/utils/routes.dart';

class InitialPreferencesScreen extends StatefulWidget {
  const InitialPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<InitialPreferencesScreen> createState() => _InitialPreferencesScreenState();
}

class _InitialPreferencesScreenState extends State<InitialPreferencesScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, String?> data = {};

  Future onSave() async {
    _formKey.currentState?.save();
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (data['api'] != null && data['mqtt'] != null) {
      await _prefs.setString("api", data['api'] as String);
      await _prefs.setString("mqtt", data['mqtt'] as String);
      await _prefs.setBool("prefsExist", true);
    }
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  Future<Map<String, dynamic>> getData() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return {
      "api": _prefs.getString("api") ?? "",
      "mqtt": _prefs.getString("mqtt") ?? "",
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<Map<String, dynamic>>(
        future: getData(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: snapshot.data?['api'],
                      decoration: const InputDecoration(
                        labelText: 'API',
                      ),
                      onSaved: (newValue) {
                        data['api'] = newValue;
                      },
                    ),
                    TextFormField(
                      initialValue: snapshot.data?['mqtt'],
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
            );
          } else {
            return Text("data");
          }
        },
      ),
    );
  }
}
