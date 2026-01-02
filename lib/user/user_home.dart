import 'package:flutter/material.dart';
import '../models/event.dart';
import 'package:hive_flutter/hive_flutter.dart';


class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Event>('events');

    return Scaffold(
      appBar: AppBar(title: const Text("Events")),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Event> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No events available"));
          }

          return ListView(
            children: box.values.map((e) {
              return ListTile(
                title: Text(e.name),
                subtitle: Text("ID: ${e.eventNumber}"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
