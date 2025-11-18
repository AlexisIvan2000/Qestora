import 'package:flutter/material.dart';
import 'package:front_end/services/preferences_local_service.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final TextEditingController cityCtrl = TextEditingController();

  double maxBudget = 200;
  String selectedCategory = "";

  final List<Map<String, dynamic>> categories = [
    {"id": "KZFzniwnSyZfZ7v7nJ", "name": "Music", "icon": Icons.music_note},
    {"id": "KZFzniwnSyZfZ7v7nE", "name": "Sports", "icon": Icons.sports_soccer},
    {"id": "KZFzniwnSyZfZ7v7na", "name": "Arts & Theater", "icon": Icons.theater_comedy},
    {"id": "KZFzniwnSyZfZ7v7nn", "name": "Movie", "icon": Icons.movie},
    {"id": "KZFzniwnSyZfZ7v7nv", "name": "Misc", "icon": Icons.star_border},
  ];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  void loadPrefs() async {
    final pref = await PreferencesLocalService.loadPreferences();

    cityCtrl.text = pref["city"];
    maxBudget = pref["budget"].toDouble();
    selectedCategory = pref["category"];

    setState(() => loading = false);
  }

  Future<void> save() async {
    await PreferencesLocalService.savePreferences(
      city: cityCtrl.text,
      budget: maxBudget.toInt(),
      category: selectedCategory,
    );

    Navigator.pop(context, true);
  }

  Widget buildCategoryChip(Map<String, dynamic> cat) {
    bool active = selectedCategory == cat["id"];

    return GestureDetector(
      onTap: () => setState(() => selectedCategory = cat["id"]),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: const EdgeInsets.only(right: 12, bottom: 12),
        decoration: BoxDecoration(
          color: active
              ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: active
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              cat["icon"],
              color: active
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              cat["name"],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: active
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black87,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              
              Text("Location", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),

              TextField(
                controller: cityCtrl,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  hintText: "City (Canada only)",
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 25),

            
              Text("Event Categories",
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),

              Wrap(
                children: [
                  for (var cat in categories) buildCategoryChip(cat),
                ],
              ),

              const SizedBox(height: 20),

              // Budget
              Text("Budget", style: Theme.of(context).textTheme.titleMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("\$0"),
                  Text("\$${maxBudget.toInt()}"),
                ],
              ),

              Slider(
                value: maxBudget,
                min: 20,
                max: 500,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) => setState(() => maxBudget = value),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: save,
                child: const Text("Apply filter"),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
