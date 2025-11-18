import 'package:flutter/material.dart';
import 'package:front_end/main.dart';
import 'package:front_end/services/auth_service.dart';
import 'package:front_end/widgets/dashboard/filter.dart';
import 'package:front_end/widgets/dashboard/navigation.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
  
}

class _DashboardScreenState extends State<DashboardScreen> {
  String username = "User";
  @override
  void initState() {
    super.initState();
    loadUser();
  }
  void loadUser() async {
    final profile = await AuthService.getProfile();
    if (profile != null){
      setState(() {
        final fullName = profile['full_name'] ?? "User";
        username = fullName.split(' ')[0];
      });
    }
    
  }
 
 
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Hello, $username',
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(color: Colors.black),
            ),
            const Spacer(),
            InkWell(
              onTap: () {},
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profil.png'),
                radius: 20,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.surface,
                filled: true,
                labelText: 'Search Events',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                prefixIcon: Icon(Icons.search),
                hintText: 'Search for events,  venues, or categories ...',
              ),
            ),
           
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Upcoming Events',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor:
                          Theme.of(context).colorScheme.surface,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (context) => FilterBottomSheet(),
                    );
                  }, 
                  icon: Icon(Icons.filter_list, color: Theme.of(context).colorScheme.primary,)),
              ],
            ),
            const SizedBox(height: 20),
            // Placeholder for event cards
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Categories',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Placeholder for categories
          ],
        ),
      ),
      bottomNavigationBar: NavigateBar(),
    );
  }
}
