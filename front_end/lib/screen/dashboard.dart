import 'package:flutter/material.dart';
import 'package:front_end/main.dart';
import 'package:front_end/widgets/dashboard/navigation.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Hello, User!',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.filter_list_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Upcoming Events',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                  fontSize: 20,
                ),
              ),
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
