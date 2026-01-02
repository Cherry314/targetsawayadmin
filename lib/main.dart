import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'admin/admin_home.dart';
import 'user/user_home.dart';
import 'models/event.dart';
import 'models/event_content.dart';
import 'models/event_override.dart';
import 'models/override_content.dart';
import 'models/firearm.dart';
import 'models/target.dart';
import 'models/ammunition.dart';
import 'models/sight.dart';
import 'models/position.dart';
import 'models/ready_position.dart';
import 'models/range_command.dart';
import 'models/tie.dart';
import 'models/procedural_penalty.dart';
import 'models/classification.dart';
import 'models/target_position.dart';
import 'models/practice.dart';
import 'models/stage.dart';
import 'models/target_id.dart';
import 'models/zone.dart';
import 'models/course_of_fire.dart';
import 'models/event_notes.dart';
import 'models/sighters.dart';
import 'models/notes.dart';
import 'models/scoring.dart';
import 'models/loading.dart';
import 'models/reloading.dart';
import 'models/equipment.dart';
import 'models/range_equipment.dart';
import 'models/changing_position.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register ALL adapters here
  // IMPORTANT: Register child types BEFORE parent types!

  // Level 1: Basic types (no nested types)
  Hive.registerAdapter(FirearmAdapter());
  Hive.registerAdapter(ZoneAdapter());

  // Level 2: Types that use Level 1 or are standalone
  Hive.registerAdapter(TargetAdapter());
  Hive.registerAdapter(AmmunitionAdapter());
  Hive.registerAdapter(SightAdapter());
  Hive.registerAdapter(PositionAdapter());
  Hive.registerAdapter(ReadyPositionAdapter());
  Hive.registerAdapter(RangeCommandAdapter());
  Hive.registerAdapter(TieAdapter());
  Hive.registerAdapter(ProceduralPenaltyAdapter());
  Hive.registerAdapter(ClassificationAdapter());
  Hive.registerAdapter(TargetPositionAdapter());
  Hive.registerAdapter(TargetIDAdapter());

  // Level 3: New simple types (text only) - MUST be before EventContent
  Hive.registerAdapter(EventNotesAdapter());
  Hive.registerAdapter(SightersAdapter());
  Hive.registerAdapter(NotesAdapter());
  Hive.registerAdapter(ScoringAdapter());
  Hive.registerAdapter(LoadingAdapter());
  Hive.registerAdapter(ReloadingAdapter());
  Hive.registerAdapter(EquipmentAdapter());
  Hive.registerAdapter(RangeEquipmentAdapter());
  Hive.registerAdapter(ChangingPositionAdapter());

  // Level 4: Complex types that use Level 2 and Level 3
  Hive.registerAdapter(CourseOfFireAdapter());
  Hive.registerAdapter(StageAdapter());
  Hive.registerAdapter(PracticeAdapter());

  // Level 5: Content types (use Level 4)
  Hive.registerAdapter(EventContentAdapter());
  Hive.registerAdapter(OverrideContentAdapter());

  // Level 6: Top-level types (use Level 5)
  Hive.registerAdapter(EventOverrideAdapter());
  Hive.registerAdapter(EventAdapter());

  // Open boxes ONCE
  await Hive.openBox<Event>('events');
  await Hive.openBox<Firearm>('firearms');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Target Shooting Rules',
      debugShowCheckedModeBanner: false,
      home: const ModeSelector(),
    );
  }
}

class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Mode")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text("Admin Mode"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminHome()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text("User Mode"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserHome()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
