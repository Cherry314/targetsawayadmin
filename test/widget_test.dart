

/// Sample events for the NRA competitions database
/// This list can be edited manually and the database refreshed from Admin panel
List<Event> sampleEvents = [
  // Event 1: 25m Precision - Complete example with all fields









  // Event 6: 50m Precision Muzzle Loading----------------------------------------------------------------------------------------------------
  Event(
    eventNumber: 99,
    name: '100',
    applicableFirearmIds: [5, 6, 7],
    baseContent: EventContent(
      targets: [
        Target(text: 'DP7', qtyNeeded: 1),
      ],
      sights: [
        Sight(text: 'As-issued iron sights or approved service optics only'),
      ],
      positions: [
        Position(text: 'Standing unsupported'),
      ],
      readyPositions: [
        ReadyPosition(text: 'Standing position, rifle at port arms, magazine inserted but bolt locked back'),
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
