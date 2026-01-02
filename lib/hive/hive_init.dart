import 'package:hive_flutter/hive_flutter.dart';



// Import all model files
import '../models/event.dart';
import '../models/event_content.dart';
import '../models/event_override.dart';
import '../models/override_content.dart';
import '../models/firearm.dart';
import '../models/target.dart';
import '../models/target_id.dart';
import '../models/zone.dart';
import '../models/practice.dart';
import '../models/stage.dart';
import '../models/event_notes.dart';
import '../models/sighters.dart';
import '../models/course_of_fire.dart';
import '../models/sight.dart';
import '../models/position.dart';
import '../models/ready_position.dart';
import '../models/range_command.dart';
import '../models/tie.dart';
import '../models/procedural_penalty.dart';
import '../models/classification.dart';
import '../models/target_position.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  // Register adapters - IMPORTANT: Register child types BEFORE parent types!

  // Level 1: Basic types (no nested types)
  Hive.registerAdapter(FirearmAdapter());
  Hive.registerAdapter(ZoneAdapter());

  // Level 2: Types that use Level 1 or are standalone
  Hive.registerAdapter(SightAdapter());
  Hive.registerAdapter(PositionAdapter());
  Hive.registerAdapter(ReadyPositionAdapter());
  Hive.registerAdapter(RangeCommandAdapter());
  Hive.registerAdapter(TieAdapter());
  Hive.registerAdapter(ProceduralPenaltyAdapter());
  Hive.registerAdapter(ClassificationAdapter());
  Hive.registerAdapter(TargetPositionAdapter());
  Hive.registerAdapter(TargetAdapter());
  Hive.registerAdapter(TargetIDAdapter());

  // Level 3: New simple types (text only)
  Hive.registerAdapter(EventNotesAdapter());
  Hive.registerAdapter(SightersAdapter());

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

  // Open boxes
  await Hive.openBox<Event>('events');
  await Hive.openBox<Firearm>('firearms');
  await Hive.openBox<Target>('targets');
  await Hive.openBox<TargetID>('target_ids');
  await Hive.openBox<Practice>('practices');
}
