import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/decision_repository.dart';

class DecisionRepositoryImpl implements DecisionRepository {
  @override
  Future<void> saveOptions(List<String> options) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = options.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('decision_options', encoded);
  }

  @override
  Future<List<String>> getOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('decision_options');
    if (list != null && list.isNotEmpty) {
      return list.map((s) => jsonDecode(s) as String).toList();
    }
    // fallback to default
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      'Arabayı mu alırsın?',
      'Kahve mi çay mı?',
      'Film mi dizi mi?',
      'Yazılım mı tasarım mı?'
    ];
  }
}