import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConditionScreen extends HookConsumerWidget {
  const ConditionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCloudsSelected = useState(false);
    final isRainSelected = useState(false);
    final areAlertsEnabled = useState(false);

    useEffect(() {
      Future<void> loadPreferences() async {
        final prefs = await SharedPreferences.getInstance();
        final conditionsString = prefs.getString('conditions');

        if (conditionsString != null) {
          final conditions = jsonDecode(conditionsString) as List;
          for (var condition in conditions) {
            if (condition['name'] == 'Clouds') {
              isCloudsSelected.value = true;
              areAlertsEnabled.value = condition['isToAlert'];
            } else if (condition['name'] == 'Rain') {
              isRainSelected.value = true;
              areAlertsEnabled.value = condition['isToAlert'];
            }
          }
        }
      }

      loadPreferences();
      return null;
    }, []);

    Future<void> _savePreferences() async {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> conditions = [];

      if (isCloudsSelected.value) {
        conditions.add({'name': 'Clouds', 'isToAlert': areAlertsEnabled.value});
      }
      if (isRainSelected.value) {
        conditions.add({'name': 'Rain', 'isToAlert': areAlertsEnabled.value});
      }

      await prefs.setString('conditions', jsonEncode(conditions));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preferences saved!')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Conditions', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: Text('Clouds'),
                  selected: isCloudsSelected.value,
                  onSelected: (selected) {
                    isCloudsSelected.value = !isCloudsSelected.value;
                    isRainSelected.value = false;
                  },
                ),
                ChoiceChip(
                  label: Text('Rain'),
                  selected: isRainSelected.value,
                  onSelected: (selected) {
                    isRainSelected.value = !isRainSelected.value;
                    isCloudsSelected.value = false;
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Alerts', style: Theme.of(context).textTheme.titleMedium),
                Switch(
                  value: areAlertsEnabled.value,
                  onChanged: (value) {
                    areAlertsEnabled.value = value;
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _savePreferences,
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
