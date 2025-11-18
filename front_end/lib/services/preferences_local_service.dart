import 'package:shared_preferences/shared_preferences.dart';

class PreferencesLocalService {
  static const _keyCity = "pref_city";
  static const _keyBudget = "pref_budget";
  static const _keyCategory = "pref_category";

  
  static Future<void> savePreferences({
    required String city,
    required int budget,
    required String category,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyCity, city);
    await prefs.setInt(_keyBudget, budget);
    await prefs.setString(_keyCategory, category);
  }

 
  static Future<Map<String, dynamic>> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "city": prefs.getString(_keyCity) ?? "Toronto",
      "budget": prefs.getInt(_keyBudget) ?? 100,
      "category": prefs.getString(_keyCategory) ?? "Music",
    };
  }
}
