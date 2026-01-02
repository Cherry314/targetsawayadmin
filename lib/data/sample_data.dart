import 'package:targetsawayadmin/models/equipment.dart';

import '../models/loading.dart';
import '../models/range_equipment.dart';
import '../models/scoring.dart';
import '../models/event.dart';
import '../models/event_content.dart';
import '../models/event_override.dart';
import '../models/override_content.dart';
import '../models/target.dart';
import '../models/sight.dart';
import '../models/position.dart';
import '../models/ready_position.dart';
import '../models/range_command.dart';
import '../models/tie.dart';
import '../models/procedural_penalty.dart';
import '../models/classification.dart';
import '../models/target_position.dart';
import '../models/practice.dart';
import '../models/stage.dart';
import '../models/target_id.dart';
import '../models/course_of_fire.dart';
import '../models/event_notes.dart';
import '../models/sighters.dart';
import '../models/ammunition.dart';


/// List of common firearm IDs used across events
List<int> sampleFirearmIds = [1, 2, 3, 4, 5, 6, 7, 8, 21, 22, 23, 24, 25];

/// Sample events for the NRA competitions database
/// This list can be edited manually and the database refreshed from Admin panel
List<Event> sampleEvents = [
  // Event 1: 25m Precision - Complete example with all fields
  Event(
    eventNumber: 1,
    name: '25m Precision',
    applicableFirearmIds: [1, 2, 3, 4, 21, 22, 23],
    baseContent: EventContent(
      targets: [
        Target(text: 'PL14'),
      ],
      sights: [
        Sight(text: 'Any (spotting scopes may also be used)'),
      ],
      positions: [
        Position(text: 'Standing Unsupported'),
      ],
      readyPositions: [
        ReadyPosition(text: '45 degrees'),
      ],
      courseOfFire: CourseOfFire(
        distance: 25,
        distanceNotes: 'Meters',
        totalTime: 45,
        timeNotes: 'Minuets (Approx)',
        totalRounds: 30,
        roundsNotes: 'Rounds, Plus sighters',
        maxScore: 300,
        maxScoreNotes: 'Maximum',
        generalNotes: '',
      ),

      sighters: [
        Sighters(text: 'Unlimited Shots in 5 minuets'),
      ],

      practices: [
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
              stageNumber: 1,
              rounds: 10, roundsText: 'shots',
              time: 5, timeText: 'minutes',
            ),
          ],
        ),
      ],
      rangeCommands: [
        RangeCommand(text: 'The general rules apply with the addition of the following initial command. Having made sure that the range is clear, the CRO commands ‘LOAD AND MAKE READY'),

      ],
      ties: [
        Tie(text: 'Tie breaking rules shall be applied in the order listed below:'),
        Tie(title: 'a.', text: 'By the greatest number of Xs in the event'),
        Tie(title: 'b.', text: 'By the scores in each practice in the order 3,2,1'),
        Tie(title: 'c.', text: 'By the X count in each practice in the order 3,2,1'),
      ],


    ),
    overrides: [
      EventOverride(
        firearmIds: [2, 3, 4, 21, 22, 23],
        changes: OverrideContent(
          targets: [
            Target(title: 'PL7'),
          ],
          //       sights: [Sight(text: 'Telescopic sights permitted for GRCF category')],
        ),
      ),
    ],
  ),
  // Event 2: 25m Precision - Muzzle Loading --------------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 2,
    name: '25m Precision Muzzle Loading',
    applicableFirearmIds: [41,42],
    baseContent: EventContent(
      targets: [
        Target(text: 'PL7'),
      ],
      sights: [
        Sight(text: 'Iron sights (spotting scopes may be used)'),
      ],
      positions: [
        Position(text:'Standing Unsupported, one hand only'),
      ],
      readyPositions: [
        ReadyPosition(text: 'Unloaded'),
      ],
      courseOfFire: CourseOfFire(
        distance: 25,
        distanceNotes: 'Meters',
        totalTime: 45,
        timeNotes: 'Minuets (Approx)',
        totalRounds: 15,
        roundsNotes: 'Rounds, with up to 5 sighters',
        maxScore: 150,
        maxScoreNotes: 'Maximum',
        generalNotes: '',
      ),

      sighters: [
        Sighters(text:'Up to 5 shots in 10 minutes')
      ],
      practices: [
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
              stageNumber: 1,
              rounds: 5, roundsText: 'Rounds with Unlimited sighting shots',
              time: 10, timeText: 'minutes',
            ),
          ],
        ),
        Practice(
          practiceNumber: 2,
          stages: [
            Stage(
              stageNumber: 1,
              rounds: 5, roundsText: 'Rounds with Unlimited sighting shots',
              time: 10, timeText: 'minutes',
            ),
          ],
        ),
        Practice(
          practiceNumber: 3,
          stages: [
            Stage(
              stageNumber: 1,
              rounds: 5, roundsText: 'Rounds with Unlimited sighting shots',
              time: 10, timeText: 'minutes',
            ),
          ],
        ),
      ],
      rangeCommands: [],
      notes: [
        EventNotes(text: 'Scoring will be standard NRA inward gauging rules, i.e. shots touching a scoring ring are awarded the higher of the two values')
      ],
      ties: [
        Tie(text: 'Tie breaking rules shall be applied in the order listed below:'),
        Tie(title: 'a.', text: 'By the greatest number of Xs in the event'),
        Tie(title: 'b.', text: 'By the scores in each practice in the order 3,2,1'),
        Tie(title: 'c.', text: 'By the X count in each practice in the order 3,2,1'),
      ],
      proceduralPenalties: [],
      classifications: [],
      targetPositions: [],
      targetIds: [],

    ),
    overrides: [
      EventOverride(
        firearmIds: [],
        changes: OverrideContent(),
      ),
    ],
  ),
  // Event 3: 25m Precision Benched----------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 3,
    name: '5m Precision Benched',
    applicableFirearmIds: [1, 2, 3, 4],
    baseContent: EventContent(
      targets: [
        Target(text: 'NRSA 25 Yard Benchrest'),
      ],
      sights: [
        Sight(text: 'Any (spotting scopes may also be used)'),
      ],
      positions: [
        Position(title: 'Benched'),
      ],
      readyPositions: [
        ReadyPosition(text: 'Benched'),
      ],
      courseOfFire: CourseOfFire(
        distance: 25,
        distanceNotes: 'Meters',
        totalTime: 45,
        timeNotes: 'Minuets',
        totalRounds: 30,
        roundsNotes: 'rounds, plus sighters',
        maxScore: 300,
        maxScoreNotes: 'Maximum',
        //  generalNotes: 'Olympic-style prone shooting. 6 convertible sighters, then 54 shots for record in 6 series of 9 shots.',
      ),
      sighters: [
        Sighters(text:'Unlimited shots in 5 minuets')
      ],
      practices: [
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
                stageNumber: 1,
                rounds: 10, roundsText: 'Rounds',
                time: 5, timeText: 'minutes',
                notesHeader: 'GRSB: ',
                notes: '1 shot per diagram'),
          ],
        ),
        Practice(
          practiceNumber: 2,
          stages: [
            Stage(
                stageNumber: 1,
                rounds: 10, roundsText: 'Rounds',
                time: 5, timeText: 'minutes',
                notesHeader: 'GRSB: ',
                notes: '1 shot per diagram'),
          ],
        ),
        Practice(
          practiceNumber: 3,
          stages: [
            Stage(
                stageNumber: 1,
                rounds: 10, roundsText: 'Rounds',
                time: 5, timeText: 'minutes',
                notesHeader: 'GRSB: ',
                notes: '1 shot per diagram'),
          ],
        ),
      ],


      rangeCommands: [
        RangeCommand(title: '', text: 'The general rules apply with the addition of the following initial command. Having made sure that the range is clear, the CRO commands ‘LOAD AND MAKE READY’'),

      ],
      ties: [
        Tie(title: '', text: 'Tie breaking rules shall be applied in the order listed below:'),
        Tie(title: 'a.', text: 'By the greatest number of Xs in the event'),
        Tie(title: 'b.', text: 'By the scores in each practice in the order 3,2,1'),
        Tie(title: 'c.', text: 'By the X count in each practice in the order 3,2,1'),
      ],
      proceduralPenalties: [],
      classifications: [],
      targetPositions: [ ],
      targetIds: [],
    ),
    overrides: [
      EventOverride(
        firearmIds: [2, 3, 4],
        changes: OverrideContent(
          targets: [Target(title: 'NRA GR5'),],
          practices: [
            Practice(
              practiceNumber: 1,
              stages: [
                Stage(stageNumber: 1,
                    rounds: 10, roundsText: 'shots',
                    time: 5, timeText: 'minutes',
                    notesHeader: 'GRCF:',
                    notes: '2 shots per diagram'),
              ],
              notesHeader: 'Practice 1,2,3',
              notes: '10 Shots in 5 Minutes',
            ),
            Practice(
              practiceNumber: 2,
              stages: [
                Stage(stageNumber: 1,
                    rounds: 10, roundsText: 'shots',
                    time: 5, timeText: 'minutes',
                    notesHeader: 'GRCF:',
                    notes: '2 shots per diagram'),
              ],
              notesHeader: 'Practice 1,2,3',
              notes: '10 Shots in 5 Minutes',
            ),
            Practice(
              practiceNumber: 3,
              stages: [
                Stage(stageNumber: 1,
                    rounds: 10, roundsText: 'shots',
                    time: 5, timeText: 'minutes',
                    notesHeader: 'GRCF:',
                    notes: '2 shots per diagram'),
              ],
              notesHeader: 'Practice 1,2,3',
              notes: '10 Shots in 5 Minutes',
            ),
          ],
        ),
      ),

    ],
  ),
  // Event 4: 50m Precision----------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 4,
    name: '50m Precision',
    applicableFirearmIds: [1,2,3,4,21,22],
    baseContent: EventContent(
      targets: [
        Target(text: 'PL7'),
      ],

      sights: [
        Sight(text: 'Any (spotting scopes may also be used)'),
      ],
      positions: [
        Position(text: 'Standing unsupported'),
      ],
      readyPositions: [
        ReadyPosition(text: '45 Degrees'),
      ],
      courseOfFire: CourseOfFire(
        distance: 50,
        distanceNotes: 'meters',
        totalTime: 45,
        timeNotes: 'minutes',
        totalRounds: 30,
        roundsNotes: 'rounds plus sighters',
        maxScore: 300,
        maxScoreNotes: 'Maximum',
        generalNotes: '',
      ),
      sighters: [
        Sighters(text:'Unlimited shots in 5 minuets')
      ],
      practices: [
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
              stageNumber: 1,
              rounds: 5, roundsText: 'shots',
              time: 10, timeText: 'minutes',
            ),
          ],
        ),
        Practice(
          practiceNumber: 2,
          stages: [
            Stage(
              stageNumber: 1,
              rounds: 5, roundsText: 'shots',
              time: 10, timeText: 'minutes',
            ),
          ],
        ),
        Practice(
          practiceNumber: 3,
          stages: [
            Stage(
              stageNumber: 1,
              rounds: 5, roundsText: 'shots',
              time: 10, timeText: 'minutes',
            ),
          ],
        ),
      ],
      rangeCommands: [
        RangeCommand(text: 'The general rules apply with the addition of the following initial command. Having made sure that the range is clear, the CRO commands ‘LOAD AND MAKE READY’'),
      ],
      ties: [
        Tie(text: 'Tie breaking rules shall be applied in the order listed below:'),
        Tie(title: 'a.', text: 'By the greatest number of Xs in the event'),
        Tie(title: 'b.', text: 'By the scores in each practice in the order 3,2,1'),
        Tie(title: 'c.', text: 'By the X count in each practice in the order 3,2,1'),
      ],
      proceduralPenalties: [],
      classifications: [],
      targetPositions: [],
      targetIds: [],

    ),
    overrides: [
      EventOverride(
        firearmIds: [5],
        changes: OverrideContent(),
      ),
    ],
  ),
// Event 5: 50m Precision (Shotgun)----------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 5,
    name: '50m Precision (Shotgun)',
    applicableFirearmIds: [35,36],
    baseContent: EventContent(
      targets: [
        Target(text: 'PL7'),
      ],
      ammunition: [
        Ammunition(text:'Solid Slug only')
      ],
      sights: [
        Sight(text: 'Any'),
      ],
      positions: [
        Position(text: 'Standing unsupported'),
      ],
      readyPositions: [
        ReadyPosition(text: '45 Degrees'),
      ],
      courseOfFire: CourseOfFire(
        totalTime: 20,
        timeNotes: 'minutes',
        totalRounds: 10,
        roundsNotes: 'rounds plus sighters',
        maxScore: 100,
        maxScoreNotes: 'Maximum',
        generalNotes: '',
      ),
      sighters: [
        Sighters(text:'Unlimited shots in 3 minuets')
      ],
      practices: [
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
              stageNumber: 1,
              distance: 50, distanceText: 'Meters',
              rounds: 5, roundsText: 'shots',
              time: 3, timeText: 'minutes',
            ),
          ],
        ),
        Practice(
          practiceNumber: 2,
          stages: [
            Stage(
              stageNumber: 1,
              distance: 50, distanceText: 'Meters',
              rounds: 5, roundsText: 'shots',
              time: 3, timeText: 'minutes',
            ),
          ],
        ),

      ],
      rangeCommands: [
        RangeCommand(text: 'The general rules apply with the addition of the following initial command. Having made sure that the range is clear, the CRO commands ‘WITH 5 ROUNDS LOAD AND MAKE READY’'),
      ],
      notes: [
        EventNotes(text:'notes')
      ],
      ties: [
        Tie(text: 'Tie breaking rules shall be applied in the order listed below:'),
        Tie(title: 'a.', text: 'By the greatest number of Xs in the event'),
        Tie(title: 'b.', text: 'By the scores in each practice in the order 3,2,1'),
        Tie(title: 'c.', text: 'By the X count in each practice in the order 3,2,1'),
      ],
      proceduralPenalties: [
        ProceduralPenalty(title: 'Cross-firing'),
      ],
      classifications: [],
      targetPositions: [],
      targetIds: [],

    ),
    overrides: [
      EventOverride(
        firearmIds: [5],
        changes: OverrideContent(),
      ),
    ],
  ),
// Event 6: 50m Precision - Muzzle Loading----------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 6,
    name: '50m Precision - Muzzle Loading',
    applicableFirearmIds: [41,42],
    baseContent: EventContent(
      targets: [
        Target(text: 'DP7', qtyNeeded: 1),
      ],
      sights: [
        Sight(text: 'Any iron (spotting scopes may also be used)'),
      ],
      positions: [
        Position(text: 'Standing unsupported, one hand only'),
      ],
      readyPositions: [
        ReadyPosition(text: 'Unloaded'),
      ],
      courseOfFire: CourseOfFire(
        distance: 50,
        distanceNotes: 'meters',
        totalTime: 60,
        timeNotes: 'minutes',
        totalRounds: 15,
        roundsNotes: 'rounds plus sighters',
        maxScore: 150,
        maxScoreNotes: 'Maximum',
        generalNotes: '',
      ),
      sighters: [
        Sighters(text:'UP to 5 shots in 10 minuets')
      ],
      practices: [
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
              stageNumber: 1,
              rounds: 5, roundsText: 'shots',
              time: 10, timeText: 'minutes',
            ),
          ],
        ),
        Practice(
          practiceNumber: 2,
          stages: [
            Stage(
              stageNumber: 1,
              rounds: 5, roundsText: 'shots',
              time: 10, timeText: 'minutes',
            ),
          ],
        ),
        Practice(
          practiceNumber: 3,
          stages: [
            Stage(
              stageNumber: 1,
              rounds: 5, roundsText: 'shots',
              time: 10, timeText: 'minutes',
            ),
          ],
        ),
      ],
      rangeCommands: [],
      notes: [
        EventNotes(text:'Scoring will be standard NRA inward gauging rules, i.e. shots touching a scoring ring are awarded the higher of the two values')
      ],
      ties: [
        Tie(text: 'Tie breaking rules shall be applied in the order listed below:'),
        Tie(title: 'a.', text: 'By the greatest number of Xs in the event'),
        Tie(title: 'b.', text: 'By the scores in each practice in the order 3,2,1'),
        Tie(title: 'c.', text: 'By the X count in each practice in the order 3,2,1'),
      ],
      proceduralPenalties: [],
      classifications: [],
      targetPositions: [],
      targetIds: [],

    ),
    overrides: [
      EventOverride(
        firearmIds: [5],
        changes: OverrideContent(),
      ),
      EventOverride(
        firearmIds: [6],
        changes: OverrideContent(),
      ),
    ],
  ),
  // Event 7: 50m Precision Muzzle Loading----------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 7,
    name: '50m Precision Benched',
    applicableFirearmIds: [1,2,3,4],
    baseContent: EventContent(
      targets: [
        Target(text: 'NRA 25 yard Benchrest', qtyNeeded: 1),
      ],
      sights: [
        Sight(text: 'Any (spotting scopes may also be used'),
      ],
      positions: [
        Position(text: 'Benched'),
      ],
      readyPositions: [
        ReadyPosition(text: 'Benched'),
      ],
      courseOfFire: CourseOfFire(
        distance: 50,
        distanceNotes: 'meters',
        totalTime: 45,
        timeNotes: 'minutes',
        totalRounds: 30,
        roundsNotes: 'rounds, plus sighters',
        maxScore: 300,
        maxScoreNotes: 'Maximum',
        generalNotes: '',
      ),
      sighters: [
        Sighters(text:'Unlimited shots in 5 minuets')
      ],
      practices: [
        Practice(
          practiceNumber: 2,
          stages: [
            Stage(
              stageNumber: 1,
              rounds: 10, roundsText: 'shots',
              time: 5, timeText: 'minutes',
              notesHeader: 'GRSB:',
              notes: '1 shot per diagram',
            ),
          ],
        ),
        Practice(
          practiceNumber: 2,
          stages: [
            Stage(
              stageNumber: 1,
              rounds: 10, roundsText: 'shots',
              time: 5, timeText: 'minutes',
              notesHeader: 'GRSB:',
              notes: '1 shot per diagram',
            ),
          ],
        ),
        Practice(
          practiceNumber: 3,
          stages: [
            Stage(
              stageNumber: 1,
              rounds: 10, roundsText: 'shots',
              time: 5, timeText: 'minutes',
              notesHeader: 'GRSB:',
              notes: '1 shot per diagram',
            ),
          ],
        ),
      ],


      rangeCommands: [
        RangeCommand(text: 'The general rules apply with the addition of the following initial command. Having made sure that the range is clear, the CRO commands ‘LOAD AND MAKE READY’'),
      ],
      notes: [],
      ties: [
        Tie(text: 'Tie breaking rules shall be applied in the order listed below:'),
        Tie(title: 'a.', text: 'By the greatest number of Xs in the event'),
        Tie(title: 'b.', text: 'By the scores in each practice in the order 3,2,1'),
        Tie(title: 'c.', text: 'By the X count in each practice in the order 3,2,1'),
      ],
      proceduralPenalties: [],
      classifications: [],
      targetPositions: [],
      targetIds: [],

    ),
    overrides: [
      EventOverride(
        firearmIds: [2,3,4],
        changes: OverrideContent(

          practices: [
            Practice(
              practiceNumber: 2,
              stages: [
                Stage(
                  stageNumber: 1,
                  rounds: 10, roundsText: 'shots',
                  time: 5, timeText: 'minutes',
                  notesHeader: 'GRCF:',
                  notes: '2 shot per diagram',
                ),
              ],
            ),
            Practice(
              practiceNumber: 2,
              stages: [
                Stage(
                  stageNumber: 1,
                  rounds: 10, roundsText: 'shots',
                  time: 5, timeText: 'minutes',
                  notesHeader: 'GRCF:',
                  notes: '2 shot per diagram',
                ),
              ],
            ),
            Practice(
              practiceNumber: 3,
              stages: [
                Stage(
                  stageNumber: 1,
                  rounds: 10, roundsText: 'shots',
                  time: 5, timeText: 'minutes',
                  notesHeader: 'GRCF:',
                  notes: '2 shot per diagram',
                ),
              ],
            ),
          ],

        ),
      ),
    ],
  ),
  // Event 8: America Match----------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 8,
    name: 'America Match',
    applicableFirearmIds: [1,2,3,4,21,22],
    baseContent: EventContent(
      targets: [
        Target(text: '50m PL7', qtyNeeded: 1),
        Target(text: '25m NRA GRS', qtyNeeded: 1),
      ],
      sights: [
        Sight(text: 'Any (spotting scopes may also be used)'),
      ],
      positions: [
        Position(text: 'Standing unsupported'),
      ],
      readyPositions: [
        ReadyPosition(text: '45 degrees'),
      ],
      courseOfFire: CourseOfFire(
        totalTime: 45,
        timeNotes: 'minutes',
        totalRounds: 30,
        roundsNotes: 'rounds plus sighters',
        maxScore: 300,
        maxScoreNotes: 'Maximum',
        generalNotes: '',
      ),
      sighters: [
        Sighters(text:'Unlimited shots in 5 minuets, 50 meters')
      ],
      practices: [
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
              stageNumber: 1,
              distance: 50, distanceText: 'Meters',
              rounds: 10, roundsText: 'shots in ONE series',
              time: 10, timeText: 'minutes',
            ),
          ],
        ),
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
              stageNumber: 1,
              distance: 25, distanceText: 'Meters',
              rounds: 10, roundsText: 'shots in TWO series',
              time: 30, timeText: 'Seconds',
            ),
          ],
        ),
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
              stageNumber: 1,
              distance: 25, distanceText: 'Meters',
              rounds: 10, roundsText: 'shots in TWO series',
              time: 20, timeText: 'Seconds',
            ),
          ],
        ),
      ],
      rangeCommands: [
        RangeCommand(text: 'The general rules apply with the addition of the following initial command. Having made sure that the range is clear, the CRO commands ‘WITH 5 ROUNDS LOAD AND MAKE READY’'),
      ],

      scoring: Scoring(text: 'The target will be scored at the end of each Practice, and refreshed with a full size target'),

      ties: [
        Tie(text: 'Tie breaking rules shall be applied in the order listed below:'),
        Tie(title: 'a.', text: 'By the greatest number of Xs in the event'),
        Tie(title: 'b.', text: 'By the scores in each practice in the order 3,2,1'),
        Tie(title: 'c.', text: 'By the X count in each practice in the order 3,2,1'),
      ],
      proceduralPenalties: [],
      classifications: [],
      targetPositions: [],
      targetIds: [],

    ),
    overrides: [
      EventOverride(
        firearmIds: [2,3,4,21,22],
        changes: OverrideContent(
          targets: [Target(title: 'PL7'),],
        ),
      ),
    ],
  ),
  // Event 9: Timed and Precision 1----------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 9,
    name: 'Timed and Precision 1',
    applicableFirearmIds: [1,2,3,4,21,22,24,25],
    baseContent: EventContent(
      targets: [
        Target(text: 'DP2 (Half Size)', qtyNeeded: 1),
      ],
      sights: [
        Sight(text: 'Any (see above)'),
      ],
      positions: [
        Position(text: 'Standing unsupported'),
      ],
      readyPositions: [
        ReadyPosition(text: '45 degrees'),
      ],
      courseOfFire: CourseOfFire(
        totalTime: 30,
        timeNotes: 'minutes',
        totalRounds: 30,
        roundsNotes: 'rounds',
        maxScore: 300,
        maxScoreNotes: 'Maximum',
        generalNotes: '',
      ),
      sighters: [],
      practices: [
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 25, distanceText: 'Meters',
                rounds: 12, roundsText: 'shots',
                time: 2, timeText: 'minutes',
                notes: 'To include reload.'
            ),
          ],
        ),
        Practice(
          practiceNumber: 2,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 15, distanceText: 'Meters',
                rounds: 12, roundsText: 'shots in two strings of 6',
                notes: 'For each string, 6 appearances of 2 seconds with intervals of 5 seconds. One shot only to be fired on each appearance. The Firearms must be returned to the ready position between appearances.'
            ),
          ],
        ),
        Practice(
          practiceNumber: 3,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 10, distanceText: 'Meters',
                rounds: 6, roundsText: 'shots in three strings of two',
                notes: 'The target will make 3 appearances of 3 seconds with intervals of 5 seconds. Two shots only to be fired at each appearance. The firearm must be returned to the ready position between appearances'
            ),
          ],
        ),
      ],
      rangeCommands: [
        RangeCommand(text: 'The general rules apply with the addition of the following initial command. Having made sure that the range is clear, the CRO commands ‘WITH SIX ROUNDS LOAD AND MAKE READY’'),
      ],
      notes: [
        EventNotes(text:'notes')
      ],
      ties: [
        Tie(text: 'Tie breaking rules shall be applied in the order listed below:'),
        Tie(title: 'a.', text: 'By the greatest number of Xs in the event'),
        Tie(title: 'b.', text: 'By the scores at each distance, commencing with the longest distance'),
        Tie(title: 'c.', text: 'By the X count at each distance, commencing with the longest distance'),
      ],
      proceduralPenalties: [
        ProceduralPenalty(text: 'In addition to the usual procedural penalties, the following apply in this event:'),
        ProceduralPenalty(title:'a.',text: 'Firing too many shots during an exposure'),
      ],
      classifications: [
        Classification(className: 'X', min: 300),
        Classification(className: 'A', min: 298, max: 299),
        Classification(className: 'B', min: 294, max: 297),
        Classification(className: 'C', min: 285, max: 293),
        Classification(className: 'D', min: 0, max: 284),
      ],
      targetPositions: [],
      targetIds: [],

    ),
    overrides: [
      EventOverride(
        firearmIds: [2,3,4,21,22,24,25],
        changes: OverrideContent(
          targets: [Target(title: 'DP2'),],
        ),
      ),

      EventOverride(
        firearmIds: [2,3,4],
        changes: OverrideContent(
          targets: [Target(title: 'DP2'),],
          classifications: [
            Classification(className: 'X', min: 300),
            Classification(className: 'A', min: 300, max: 300),
            Classification(className: 'B', min: 299, max: 300),
            Classification(className: 'C', min: 296, max: 298),
            Classification(className: 'D', min: 0, max: 295),
          ],
        ),
      ),

      EventOverride(
        firearmIds: [21],
        changes: OverrideContent(
          targets: [Target(title: 'DP2'),],
          classifications: [
            Classification(className: 'X', min: 299, max: 300),
            Classification(className: 'A', min: 294, max: 298),
            Classification(className: 'B', min: 0, max: 293),
          ],
        ),
      ),

      EventOverride(
        firearmIds: [2,3,4,21,22,24,25],
        changes: OverrideContent(
          targets: [Target(title: 'DP2'),],
          classifications: [
            Classification(className: 'X', min: 298, max: 300),
            Classification(className: 'A', min: 293, max: 297),
            Classification(className: 'B', min: 0, max: 292),
          ],
        ),
      ),
    ],

  ),
  // Event 10: Timed and Precision 1 Air Pistol----------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 10,
    name: 'Timed and Precision 1 Air Pistol',
    applicableFirearmIds: [23],
    baseContent: EventContent(
      targets: [
        Target(text: 'DP2', qtyNeeded: 1),
      ],
      sights: [
        Sight(text: 'Any'),
      ],
      positions: [
        Position(text: 'Standing unsupported, freestyle'),
      ],
      readyPositions: [
        ReadyPosition(text: '45 Degrees'),
      ],
      courseOfFire: CourseOfFire(
        distance: 15,
        distanceNotes: 'meters',
        totalTime: 30,
        timeNotes: 'minutes',
        totalRounds: 30,
        roundsNotes: 'rounds',
        maxScore: 300,
        maxScoreNotes: 'Maximum',
        generalNotes: '',
      ),
      sighters: [],
      practices: [
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
              stageNumber: 1,
              distance: 15, distanceText: 'Meters',
              rounds: 12, roundsText: 'shots',
              time: 2, timeText: 'minutes',

            ),
          ],
          notesHeader: 'Standing Practice',
        ),
        Practice(
          practiceNumber: 2,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 10, distanceText: 'Meters',
                rounds: 12, roundsText: 'shots in three strings of 4',
                notes: 'The target will make 4 appearances of 2 seconds with intervals of about 3 seconds. Two shots only to be fired at each appearance.'
            ),
          ],
          notesHeader: 'Standing Practice',
        ),
        Practice(
          practiceNumber: 3,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 7, distanceText: 'Meters',
                rounds: 6, roundsText: 'shots in three strings of 2',
                notes: 'The target will make 3 appearances of 3 seconds with intervals of about 3 seconds. Two shots only to be fired at each appearance.'
            ),
          ],
          notesHeader: 'Standing Practice',
        ),
      ],
      rangeCommands: [],
      notes: [],
      ties: [],
      proceduralPenalties: [],
      classifications: [],
      targetPositions: [],
      targetIds: [],

    ),
    overrides: [
      EventOverride(
        firearmIds: [5],
        changes: OverrideContent(),
      ),
    ],
  ),
  // Event 11: Timed and Precision 1 Shotgun----------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 11,
    name: 'Timed and Precision 1 Shotgun',
    applicableFirearmIds: [31, 35, 36],
    baseContent: EventContent(
      targets: [
        Target(text: 'DP2', qtyNeeded: 1),
      ],
      sights: [
        Sight(text: 'Any'),
      ],
      positions: [
        Position(text: 'Standing unsupported'),
      ],
      readyPositions: [
        ReadyPosition(text: '45 Degrees'),
      ],
      courseOfFire: CourseOfFire(
        totalTime: 30,
        timeNotes: 'minutes',
        totalRounds: 30,
        roundsNotes: 'rounds plus sighters',
        maxScore: 300,
        maxScoreNotes: 'Maximum',
        generalNotes: '',
      ),
      sighters: [],
      practices: [
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
              stageNumber: 1,
              distance: 25, distanceText: 'Meters',
              rounds: 12, roundsText: 'shots',
              time: 2, timeText: 'minutes, to include reload of at least 6 rounds',
            ),
          ],
        ),
        Practice(
          practiceNumber: 2,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 15, distanceText: 'Meters',
                rounds: 12, roundsText: 'shots, in two strings of six',
                notes: 'The target will make 6 appearances of 2 seconds with intervals of 5 seconds. One shot only to be fired on each appearance. The firearm must be returned to the ready position between appearances.'
            ),
          ],
        ),
        Practice(
          practiceNumber: 3,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 10, distanceText: 'Meters',
                rounds: 6, roundsText: 'shots',
                notes: 'the target will make 3 appearances of 3 seconds with intervals of 5 seconds. Two shots only to be fired at each appearance. The firearm must be returned to the ready position between appearances.'
            ),
          ],
        ),
      ],
      rangeCommands: [
        RangeCommand(text: 'The general rules apply with the addition of the following initial command. Having made sure that the range is clear, the CRO commands ‘LOAD AND MAKE READY’'),
      ],
      notes: [],
      ties: [
        Tie(text: 'Tie breaking rules shall be applied in the order listed below:'),
        Tie(title: 'a.', text: 'By the greatest number of Xs in the event'),
        Tie(title: 'b.', text: 'By the scores at each distance, commencing with the longest distance'),
        Tie(title: 'c.', text: 'By the X count at each distance, commencing with the longest distance'),
      ],
      proceduralPenalties: [
        ProceduralPenalty(text: 'In addition to the usual procedural penalties, the following apply in this event:'),
        ProceduralPenalty(title:'a.', text: 'Firing too many shots during an exposure'),
      ],
      classifications: [],
      targetPositions: [],
      targetIds: [],

    ),
    overrides: [
      EventOverride(
        firearmIds: [5],
        changes: OverrideContent(),
      ),
    ],
  ),
  // Event 12: Timed and Precision 1 Shotgun Classic----------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 12,
    name: 'Timed and Precision 1 Shotgun Classic',
    applicableFirearmIds: [37],
    baseContent: EventContent(
      targets: [
        Target(text: 'DP2', qtyNeeded: 1),
      ],
      sights: [
        Sight(text: 'Any'),
      ],
      positions: [
        Position(text: 'Standing unsupported'),
      ],
      readyPositions: [
        ReadyPosition(text: '45 Degrees'),
      ],
      courseOfFire: CourseOfFire(
        totalTime: 30,
        timeNotes: 'minutes',
        totalRounds: 30,
        roundsNotes: 'rounds',
        maxScore: 300,
        maxScoreNotes: 'Maximum',
        generalNotes: '',
      ),
      sighters: [],
      practices: [
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
              stageNumber: 1,
              distance: 25, distanceText: 'Meters',
              rounds: 12, roundsText: 'shots',
              time: 2, timeText: 'minutes, to include all reloading',
            ),
          ],
        ),
        Practice(
          practiceNumber: 2,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 15, distanceText: 'Meters',
                rounds: 12, roundsText: 'shots, in 1 string of 12 shots',
                notes: 'the target will make 12 appearances of 2 seconds with intervals of 10 seconds. One shot only to be fired on each appearance. The firearm must be reloaded as required and returned to the ready position between appearances.'
            ),
          ],
        ),
        Practice(
          practiceNumber: 3,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 10, distanceText: 'Meters',
                rounds: 6, roundsText: 'shots',
                notes: 'the target will make 6 appearances of 2 seconds with intervals of 10 seconds between appearances. One shot only to be fired at each appearance. The shoter is to reloaded as required and returned to the ready position between appearances.'
            ),
          ],
        ),
      ],
      rangeCommands: [
        RangeCommand(text: 'The general rules apply with the addition of the following initial command. Having made sure that the range is clear, the CRO commands ‘LOAD AND MAKE READY’'),
      ],
      notes: [],
      ties: [
        Tie(text: 'Tie breaking rules shall be applied in the order listed below:'),
        Tie(title: 'a.', text: 'By the greatest number of Xs in the event'),
        Tie(title: 'b.', text: 'By the scores at each distance, commencing with the longest distance'),
        Tie(title: 'c.', text: 'By the X count at each distance, commencing with the longest distance'),
      ],
      proceduralPenalties: [
        ProceduralPenalty(text: 'In addition to the usual procedural penalties, the following apply in this event:'),
        ProceduralPenalty(title:'a.', text: 'Firing too many shots during an exposure'),
      ],
      classifications: [],
      targetPositions: [],
      targetIds: [],
    ),
    overrides: [
      EventOverride(
        firearmIds: [5],
        changes: OverrideContent(),
      ),
    ],
  ),
  // Event 13: Timed and Precision 1 Muzzle Loading----------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 13,
    name: 'Timed and Precision 1 Muzzle Loading',
    applicableFirearmIds: [42],
    baseContent: EventContent(
      targets: [
        Target(text: 'DP2', qtyNeeded: 1),
      ],
      sights: [
        Sight(text: 'Any iron'),
      ],
      positions: [
        Position(text: 'Standing unsupported'),
      ],
      readyPositions: [
        ReadyPosition(text: '45 Degrees, revolver loaded and capped, cocked or uncocked at shooter’s preference'),
      ],
      courseOfFire: CourseOfFire(
        totalTime: 60,
        timeNotes: 'minutes',
        totalRounds: 30,
        roundsNotes: 'rounds plus sighters',
        maxScore: 300,
        maxScoreNotes: 'Maximum',
        generalNotes: '',
      ),
      sighters: [],
      practices: [
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
              stageNumber: 1,
              distance: 25, distanceText: 'Meters',
              rounds: 12, roundsText: 'shots',
              time: 12, timeText: 'minutes, to include reload',
            ),
          ],
        ),
        Practice(
          practiceNumber: 2,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 15, distanceText: 'Meters',
                rounds: 12, roundsText: 'shots, in 2 strings of 6',
                notes: 'the target will make 6 appearances of 2 seconds with intervals of 5 seconds. One shot only to be fired on each appearance.'
            ),
          ],
          notesHeader: 'Standing Practice',
        ),
        Practice(
          practiceNumber: 3,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 10, distanceText: 'Meters',
                rounds: 6, roundsText: 'shots',
                notes: 'the target will make 3 appearances of 4 seconds with intervals of 5 seconds. Two shots only to be fired at each appearance.'
            ),
          ],
          notesHeader: 'Standing Practice',
        ),
      ],
      rangeCommands: [
        RangeCommand(text: 'The general rules apply with the addition of the following initial command. Having made sure that the range is clear, the CRO commands ‘LOAD AND MAKE READY’'),
      ],
      notes: [],
      ties: [
        Tie(text: 'Tie breaking rules shall be applied in the order listed below:'),
        Tie(title: 'a.', text: 'By the greatest number of Xs in the event'),
        Tie(title: 'b.', text: 'By the scores at each distance, commencing with the longest distance'),
        Tie(title: 'c.', text: 'By the X count at each distance, commencing with the longest distance'),
      ],
      proceduralPenalties: [],
      classifications: [],
      targetPositions: [],
      targetIds: [],

    ),
    overrides: [
      EventOverride(
        firearmIds: [5],
        changes: OverrideContent(),
      ),
    ],
  ),
  // Event 14: Timed and Precision 2----------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 14,
    name: 'Timed and Precision 2',
    applicableFirearmIds: [1,2,3,4,21,22,24,25],
    baseContent: EventContent(
      targets: [
        Target(text: 'DP2 (half size)', qtyNeeded: 1),
      ],
      sights: [
        Sight(text: 'Any'),
      ],
      positions: [
        Position(text: 'Standing unsupported<>Standing Using {Barricade}<>Kneeling<>Sitting'),
      ],
      readyPositions: [
        ReadyPosition(text: '45 Degrees'),
      ],
      courseOfFire: CourseOfFire(
        totalTime: 45,
        timeNotes: 'minutes',
        totalRounds: 60,
        roundsNotes: 'rounds',
        maxScore: 600,
        maxScoreNotes: 'Maximum',
        generalNotes: '',
      ),
      sighters: [],
      practices: [
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 10, distanceText: 'Meters',
                rounds: 6, roundsText: 'shots',
                time: 5, timeText: 'seconds',
                notes: 'This practice will be shot twice'
            ),

          ],
          notesHeader: 'Standing Practice',
        ),
        Practice(
          practiceNumber: 2,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 50, distanceText: 'Meters',
                rounds: 24, roundsText: 'shots',
                time: 150, timeText: 'Seconds',
                notes: '6 Shots Kneeling*<>6 shots sitting<>6 shots left shoulder standing unsupported<>6 shots right shoulder standing unsupported'
            ),
          ],

        ),
        Practice(
          practiceNumber: 3,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 25, distanceText: 'Meters',
                rounds: 24, roundsText: 'shots',
                time: 105, timeText: 'seconds',
                notes: '6 Shots Kneeling*<>6 shots sitting<>6 shots left shoulder standing unsupported<>6 shots right shoulder standing unsupported'
            ),
          ],
          notesHeader: '* The competitor should only make ready once they are in the kneeling position. ** When kneeling using the barricade for support, the competitor can ignore the foot-fault line extending to the rear of the barricade',
        ),
      ],
      rangeCommands: [
        RangeCommand(title:'Practice 1', text: 'WITH SIX ROUNDS, RIFLES LOAD AND MAKE READY,HANDGUNS LOAD AND HOLSTER'),
        RangeCommand(title:'Practice 2 & 3', text: 'WITH SIX ROUNDS, RIFLES LOAD BUT DO NOT MAKE READY, HANDGUNS LOAD AND HOLSTER'),
      ],

      loading: Loading(text:'For each individual practice all ammunition for that practice must be carried on the competitor’s person. When shooting with a revolver, only one speedloader may be used'),

      equipment: Equipment(text: 'When shooting this event with a LBP or LBR a holster must be used'),

      rangeEquipment: RangeEquipment(text: 'A barricade will be provided for each competitor using a LBP or LBR for the standing with support position at both 25 and 50 metres. It should be a wooden post, square or rectangular in section, fixed on the firing line and sufficiently strong to remain immobile. It should ideally be at least 100mm square and two metres in height'),

      notes: [],
      ties: [
        Tie(text: 'Tie breaking rules shall be applied in the order listed below:'),
        Tie(title: 'a.', text: 'By the greatest number of Xs in the event'),
        Tie(title: 'b.', text: 'By the scores at each distance, commencing with the longest distance'),
        Tie(title: 'c.', text: 'By the X count at each distance, commencing with the longest distance'),
      ],
      proceduralPenalties: [
        ProceduralPenalty(text: 'In addition to the usual procedural penalties, the following apply in this event:'),
        ProceduralPenalty(title: 'a', text: 'Moving between shooting positions during a practice without following the correct rules for this'),
        ProceduralPenalty(title: 'b', text: 'Allowing part of the firearm to make contact with the barricade when firing'),
        ProceduralPenalty(title: 'c', text: 'Touching any part of the barrel with either the firing hand or supporting hand when firing using the barricade'),

      ],
      classifications: [
        Classification(className: 'X', min: 587, max: 600),
        Classification(className: 'A', min: 572, max: 586),
        Classification(className: 'B', min: 0, max: 571),
      ],
      targetPositions: [],
      targetIds: [],

    ),
    overrides: [
      EventOverride(
        firearmIds: [2,3,4],
        changes: OverrideContent(
          targets: [
            Target(title: 'DP2'),
          ],
          practices: [
            Practice(
              practiceNumber: 1,
              stages: [
                Stage(
                    stageNumber: 1,
                    distance: 10, distanceText: 'Meters',
                    rounds: 6, roundsText: 'shots',
                    time: 8, timeText: 'seconds',
                    notes: 'This practice will be shot twice'
                ),

              ],
              notesHeader: 'Standing Practice',
            ),
            Practice(
              practiceNumber: 2,
              stages: [
                Stage(
                    stageNumber: 1,
                    distance: 50, distanceText: 'Meters',
                    rounds: 24, roundsText: 'shots',
                    time: 180, timeText: 'Seconds',
                    notes: '6 Shots Kneeling*<>6 shots sitting<>6 shots left shoulder standing unsupported<>6 shots right shoulder standing unsupported'
                ),
              ],

            ),
            Practice(
              practiceNumber: 3,
              stages: [
                Stage(
                    stageNumber: 1,
                    distance: 25, distanceText: 'Meters',
                    rounds: 24, roundsText: 'shots',
                    time: 120, timeText: 'seconds',
                    notes: '6 Shots Kneeling*<>6 shots sitting<>6 shots left shoulder standing unsupported<>6 shots right shoulder standing unsupported'
                ),
              ],
              notesHeader: '* The competitor should only make ready once they are in the kneeling position. ** When kneeling using the barricade for support, the competitor can ignore the foot-fault line extending to the rear of the barricade',
            ),
          ],
          classifications: [
            Classification(className: 'X', min: 597, max: 600),
            Classification(className: 'A', min: 587, max: 596),
            Classification(className: 'B', min: 0, max: 586),
          ],

        ),
      ),
      EventOverride(
        firearmIds: [21,24],
        changes: OverrideContent(
          targets: [Target(title: 'DP2'),],
          readyPositions: [
            ReadyPosition(text: 'Holstered Loaded'),
          ],
          practices: [
            Practice(
              practiceNumber: 1,
              stages: [
                Stage(
                    stageNumber: 1,
                    distance: 10, distanceText: 'Meters',
                    rounds: 6, roundsText: 'shots',
                    time: 8, timeText: 'seconds',
                    notes: 'This practice will be shot twice'
                ),
              ],
            ),
            Practice(
              practiceNumber: 2,
              stages: [
                Stage(
                    stageNumber: 1,
                    distance: 50, distanceText: 'Meters',
                    rounds: 24, roundsText: 'shots',
                    time: 150, timeText: 'Seconds',
                    notes: '6 Shots Kneeling* using barricade** (or prone depending on range restrictions)<>6 shots sitting<>6 shots left shoulder standing using barricade<>6 shots right shoulder standing using barricade'
                ),
              ],
            ),
            Practice(
              practiceNumber: 3,
              stages: [
                Stage(
                    stageNumber: 1,
                    distance: 25, distanceText: 'Meters',
                    rounds: 24, roundsText: 'shots',
                    time: 105, timeText: 'Seconds',
                    notes: '6 Shots Kneeling* <> 6 shots sitting<>6 shots right hand standing using barricade revolvers double action only<>6 shots left hand standing using barricade, revolvers double action only'
                ),
              ],
              notesHeader: '* The competitor should only make ready once they are in the kneeling position. ** When kneeling using the barricade for support, the competitor can ignore the foot-fault line extending to the rear of the barricade',
            ),
          ],
        ),
      ),
      EventOverride(
        firearmIds: [22,25],
        changes: OverrideContent(
          targets: [Target(title: 'DP2'),],
          readyPositions: [
            ReadyPosition(text: 'Holstered'),
          ],
          practices: [
            Practice(
              practiceNumber: 1,
              stages: [
                Stage(
                    stageNumber: 1,
                    distance: 10, distanceText: 'Meters',
                    rounds: 6, roundsText: 'shots',
                    time: 8, timeText: 'seconds',
                    notes: 'This practice will be shot twice'
                ),
              ],
            ),
            Practice(
              practiceNumber: 2,
              stages: [
                Stage(
                    stageNumber: 1,
                    distance: 50, distanceText: 'Meters',
                    rounds: 24, roundsText: 'shots',
                    time: 180, timeText: 'Seconds',
                    notes: '6 Shots Kneeling* using barricade** (or prone depending on range restrictions) <> 6 shots sitting <> 6 shots left shoulder standing using barricade <> 6 shots right shoulder standing using barricade'
                ),
              ],
            ),
            Practice(
              practiceNumber: 3,
              stages: [
                Stage(
                    stageNumber: 1,
                    distance: 25, distanceText: 'Meters',
                    rounds: 24, roundsText: 'shots',
                    time: 120, timeText: 'Seconds',
                    notes: '6 Shots Kneeling* <> 6 shots sitting <> 6 shots right hand standing using barricade, revolvers double action only <> 6 shots left hand standing using barricade, revolvers double action only'
                ),
              ],
              notesHeader: '* The competitor should only make ready once they are in the kneeling position. ** When kneeling using the barricade for support, the competitor can ignore the foot-fault line extending to the rear of the barricade',
            ),
          ],





        ),
      ),
    ],
  ),
  // Event 15: Timed and Precision 3----------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 99,
    name: '100',
    applicableFirearmIds: [21,22],
    baseContent: EventContent(
      targets: [
        Target(text: 'DTP3', qtyNeeded: 1),
      ],
      sights: [
        Sight(text: 'Any'),
      ],
      positions: [
        Position(text: 'Standing unsupported<>Standing Using Barricade<>Kneeling<>sitting'),
      ],
      readyPositions: [
        ReadyPosition(title:'',text: 'Standing position, rifle at port arms, magazine inserted but bolt locked back'),
      ],
      courseOfFire: CourseOfFire(
        distance: 50,
        distanceNotes: 'meters',
        totalTime: 45,
        timeNotes: 'minutes',
        totalRounds: 30,
        roundsNotes: 'rounds plus sighters',
        maxScore: 300,
        maxScoreNotes: 'Maximum',
        generalNotes: '',
      ),
      sighters: [
        Sighters(text:'Unlimited shots in 5 minuets')
      ],
      practices: [
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 25, distanceText: 'Meters',
                rounds: 5, roundsText: 'Rounds with Unlimited sighting shots',
                time: 5, timeText: 'minutes',
                notesHeader: 'Sighters',
                notes: 'Unlimited sighting shots within time limit'
            ),
            Stage(
                stageNumber: 1,
                distance: 25, distanceText: 'Meters',
                rounds: 5, roundsText: 'Rounds with Unlimited sighting shots',
                time: 5, timeText: 'minutes',
                notesHeader: 'Sighters',
                notes: 'Unlimited sighting shots within time limit'
            ),
          ],
          notesHeader: 'Standing Practice',
        ),
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 25, distanceText: 'Meters',
                rounds: 5, roundsText: 'Rounds with Unlimited sighting shots',
                time: 5, timeText: 'minutes',
                notesHeader: 'Sighters',
                notes: 'Unlimited sighting shots within time limit'
            ),
            Stage(
                stageNumber: 1,
                distance: 25, distanceText: 'Meters',
                rounds: 5, roundsText: 'Rounds with Unlimited sighting shots',
                time: 5, timeText: 'minutes',
                notesHeader: 'Sighters',
                notes: 'Unlimited sighting shots within time limit'
            ),
          ],
          notesHeader: 'Standing Practice',
        ),
        Practice(
          practiceNumber: 1,
          stages: [
            Stage(
                stageNumber: 1,
                distance: 25, distanceText: 'Meters',
                rounds: 5, roundsText: 'Rounds with Unlimited sighting shots',
                time: 5, timeText: 'minutes',
                notesHeader: 'Sighters',
                notes: 'Unlimited sighting shots within time limit'
            ),
            Stage(
                stageNumber: 1,
                distance: 25, distanceText: 'Meters',
                rounds: 5, roundsText: 'Rounds with Unlimited sighting shots',
                time: 5, timeText: 'minutes',
                notesHeader: 'Sighters',
                notes: 'Unlimited sighting shots within time limit'
            ),
          ],
          notesHeader: 'Standing Practice',
        ),
      ],
      rangeCommands: [
        RangeCommand(text: 'The general rules apply with the addition of the following initial command. Having made sure that the range is clear, the CRO commands ‘LOAD AND MAKE READY’'),
      ],
      notes: [
        EventNotes(text:'notes')
      ],
      ties: [
        Tie(text: 'Tie breaking rules shall be applied in the order listed below:'),
        Tie(title: 'a.', text: 'By the greatest number of Xs in the event'),
        Tie(title: 'b.', text: 'By the scores in each practice in the order 3,2,1'),
        Tie(title: 'c.', text: 'By the X count in each practice in the order 3,2,1'),
      ],
      proceduralPenalties: [
        ProceduralPenalty(title: 'Cross-firing'),
      ],
      classifications: [
        Classification(className: 'Master', min: 95, max: 100),
        Classification(className: 'Expert', min: 88, max: 94),
        Classification(className: 'Sharpshooter', min: 80, max: 87),
        Classification(className: 'Marksman', min: 70, max: 79),
        Classification(className: 'Unclassified', min: 0, max: 69),
      ],
      targetPositions: [
        TargetPosition(title: '100yd Center'),
        TargetPosition(title: '100yd Position 2'),
        TargetPosition(title: '100yd Position 3'),
      ],
      targetIds: [
        TargetID(title: 'Service Rifle Scoring Rings'),
      ],

    ),
    overrides: [
      EventOverride(
        firearmIds: [5],
        changes: OverrideContent(
          targets: [Target(title: 'NRA GR5'),],
        ),
      ),
      EventOverride(
        firearmIds: [6],
        changes: OverrideContent(
          targets: [Target(title: 'NRA GR5'),],
        ),
      ),
    ],
  ),



];
