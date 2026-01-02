import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/event.dart';
import '../models/firearm.dart';
import '../models/target.dart';
import '../models/ammunition.dart';
import '../models/sight.dart';
import '../models/position.dart';
import '../models/ready_position.dart';
import '../models/practice.dart';
import '../models/sighters.dart';
import '../data/sample_data.dart';
import '../data/firearm_table.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Event? selectedEvent;
  int? selectedFirearmId;

  /// Rebuild database (delete all + reload sample data)
  Future<void> rebuildDatabase() async {
    final box = Hive.box<Event>('events');
    await box.clear();
    for (final event in sampleEvents) {
      await box.put(event.eventNumber, event);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Database rebuilt from sample data")));
    }
    setState(() {
      selectedEvent = null;
      selectedFirearmId = null;
    });
  }

  /// Add sample data without deleting existing
  Future<void> addDataToDatabase() async {
    final box = Hive.box<Event>('events');
    for (final event in sampleEvents) {
      if (!box.containsKey(event.eventNumber)) {
        await box.put(event.eventNumber, event);
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sample data added (no overwrites)")));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final eventBox = Hive.box<Event>('events');
    final events = eventBox.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.warning),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50)),
                label: const Text('Rebuild Database (DELETE & RELOAD)'),
                onPressed: rebuildDatabase,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50)),
                label: const Text('Add Sample Data (No Delete)'),
                onPressed: addDataToDatabase,
              ),
              const SizedBox(height: 16),
              const Text(
                'Show Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButton<Event>(
                hint: const Text("Select Event"),
                value: selectedEvent,
                isExpanded: true,
                items: events.map((e) {
                  return DropdownMenuItem<Event>(
                    value: e,
                    child: Text("${e.name} (${e.eventNumber})"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedEvent = value;
                    selectedFirearmId = null;
                  });
                },
              ),
              const SizedBox(height: 10),
              if (selectedEvent != null)
                DropdownButton<int>(
                  hint: const Text("Select Firearm"),
                  value: selectedFirearmId,
                  isExpanded: true,
                  items: selectedEvent!.applicableFirearmIds.map((id) {
                    // Look up firearm info from master table
                    final firearmInfo = firearmMasterTable.firstWhere(
                      (f) => f.id == id,
                      orElse: () => FirearmInfo(id: id, code: 'Unknown', gunType: 'Unknown'),
                    );
                    return DropdownMenuItem<int>(
                      value: id,
                      child: Text("${firearmInfo.code} (${firearmInfo.gunType})"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFirearmId = value;
                    });
                  },
                ),
              const SizedBox(height: 20),
              if (selectedEvent != null && selectedFirearmId != null)
                _buildEventData(selectedEvent!, selectedFirearmId!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventData(Event event, int firearmId) {
    // Look up firearm info from master table
    final firearmInfo = firearmMasterTable.firstWhere(
      (f) => f.id == firearmId,
      orElse: () => FirearmInfo(id: firearmId, code: 'Unknown', gunType: 'Unknown'),
    );
    
    // Get content for this firearm
    final content = event.getContentForFirearm(Firearm(
      id: firearmId,
      code: firearmInfo.code,
      gunType: firearmInfo.gunType,
    ));

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event and Firearm info stays the same (dropdown area)
            Text("Event: ${event.name} (${event.eventNumber})",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text("Firearm: ${firearmInfo.code} (${firearmInfo.gunType})",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            
            // Targets
            if (content.targets.isNotEmpty) ...[
              _buildFieldRow('Targets', _formatTargets(content.targets)),
              const SizedBox(height: 8),
            ],
            
            // Ammunition
            if (content.ammunition != null && content.ammunition!.isNotEmpty) ...[
              _buildFieldRow('Ammunition', _formatAmmunition(content.ammunition!)),
              const SizedBox(height: 8),
            ],
            
            // Sights
            if (content.sights.isNotEmpty) ...[
              _buildFieldRow('Sights', _formatSights(content.sights)),
              const SizedBox(height: 8),
            ],
            
            // Position
            if (content.positions.isNotEmpty) ...[
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                  children: [
                    const TextSpan(text: 'Position : ', style: TextStyle(fontWeight: FontWeight.bold)),
                    ..._formatPositionsWithLineBreaks(content.positions),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Ready Position
            if (content.readyPositions.isNotEmpty) ...[
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                  children: [
                    const TextSpan(text: 'Ready Position : ', style: TextStyle(fontWeight: FontWeight.bold)),
                    ..._formatReadyPositionsWithTitle(content.readyPositions),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Course of Fire Section
            const Text('Course of Fire', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            
            // Distance
            if (content.courseOfFire.distance != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _buildFieldRow('Distance', '${content.courseOfFire.distance} ${content.courseOfFire.distanceNotes ?? ''}'),
              ),
              const SizedBox(height: 4),
            ],
            
            // Time
            if (content.courseOfFire.totalTime != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _buildFieldRow('Time', '${content.courseOfFire.totalTime} ${content.courseOfFire.timeNotes ?? ''}'),
              ),
              const SizedBox(height: 4),
            ],
            
            // Rounds
            if (content.courseOfFire.totalRounds != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _buildFieldRow('Rounds', '${content.courseOfFire.totalRounds} ${content.courseOfFire.roundsNotes ?? ''}'),
              ),
              const SizedBox(height: 4),
            ],
            
            // Max Score
            if (content.courseOfFire.maxScore != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _buildFieldRow('Max Score', '${content.courseOfFire.maxScore} ${content.courseOfFire.maxScoreNotes ?? ''}'),
              ),
              const SizedBox(height: 4),
            ],
            
            // Notes (from course of fire)
            if (content.courseOfFire.generalNotes != null && content.courseOfFire.generalNotes!.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      const TextSpan(text: 'Notes : ', style: TextStyle(fontWeight: FontWeight.bold)),
                      ..._processNotesText(content.courseOfFire.generalNotes!, style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Sighters
            if (content.sighters != null && content.sighters!.isNotEmpty) ...[
              _buildFieldRow('Sighters', _formatSighters(content.sighters!), bold: true),
              const SizedBox(height: 8),
            ],
            
            // Practices
            ...content.practices.map((practice) => _buildPractice(practice)),
            
            // General Notes (new field)
            if (content.generalNotes != null && content.generalNotes!.text != null && content.generalNotes!.text!.isNotEmpty) ...[
              _buildFieldRow('Notes', content.generalNotes!.text!, bold: true),
              const SizedBox(height: 8),
            ],
            
            // Range Commands
            if (content.rangeCommands.isNotEmpty) ...[
              _buildFieldRow('Range Commands', '', bold: true),
              const SizedBox(height: 4),
              ...content.rangeCommands.map((rc) => 
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: [
                        TextSpan(text: rc.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: rc.text ?? ''),
                      ],
                    ),
                  ),
                )
              ),
              const SizedBox(height: 8),
            ],
            
            // Scoring
            if (content.scoring != null) ...[
              _buildFieldRow('Scoring', content.scoring!.text ?? '', bold: true),
              const SizedBox(height: 8),
            ],
            
            // Loading
            if (content.loading != null) ...[
              _buildFieldRow('Loading', '', bold: true),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      TextSpan(text: content.loading!.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (content.loading!.text != null && content.loading!.text!.isNotEmpty) const TextSpan(text: ' '),
                      if (content.loading!.text != null && content.loading!.text!.isNotEmpty) ..._processNotesText(content.loading!.text, style: const TextStyle(color: Colors.black, fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Reloading
            if (content.reloading != null) ...[
              _buildFieldRow('Reloading', '', bold: true),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      TextSpan(text: content.reloading!.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' ${content.reloading!.text ?? ''}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Equipment
            if (content.equipment != null) ...[
              _buildFieldRow('Equipment', '', bold: true),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      TextSpan(text: content.equipment!.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' ${content.equipment!.text ?? ''}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Range Equipment
            if (content.rangeEquipment != null) ...[
              _buildFieldRow('Range Equipment', '', bold: true),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      TextSpan(text: content.rangeEquipment!.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' ${content.rangeEquipment!.text ?? ''}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Changing Position
            if (content.changingPosition != null) ...[
              _buildFieldRow('Changing position', '', bold: true),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      TextSpan(text: content.changingPosition!.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' ${content.changingPosition!.text ?? ''}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Ties
            if (content.ties != null && content.ties!.isNotEmpty) ...[
              _buildFieldRow('Ties', '', bold: true),
              const SizedBox(height: 4),
              ...content.ties!.map((tie) => 
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: [
                        TextSpan(text: tie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: tie.text ?? ''),
                        if (tie.idx != null && tie.idx!.isNotEmpty)
                          TextSpan(text: '\n${tie.idx}. ${tie.idxText ?? ''}'),
                      ],
                    ),
                  ),
                )
              ),
              const SizedBox(height: 8),
            ],
            
            // Procedural Penalties
            if (content.proceduralPenalties != null && content.proceduralPenalties!.isNotEmpty) ...[
              _buildFieldRow('Procedural Penalties', '', bold: true),
              const SizedBox(height: 4),
              ...content.proceduralPenalties!.map((pp) => 
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: [
                        TextSpan(text: pp.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ': ${pp.text ?? ''}'),
                        if (pp.idx != null && pp.idx!.isNotEmpty)
                          TextSpan(text: '\n${pp.idx}. ${pp.idxText ?? ''}'),
                      ],
                    ),
                  ),
                )
              ),
              const SizedBox(height: 8),
            ],
            
            // Classifications
            if (content.classifications != null && content.classifications!.isNotEmpty) ...[
              _buildFieldRow('Classifications', '', bold: true),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.only(left: 16, bottom: 4),
                child: Text('The classification scores bands are as follows', style: TextStyle(fontSize: 13)),
              ),
              ...content.classifications!.map((classification) => 
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 2),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: [
                        TextSpan(text: classification.className, style: const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '  ${classification.min} - ${classification.max}'),
                      ],
                    ),
                  ),
                )
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  // Helper method to build a field row with bold label
  Widget _buildFieldRow(String label, String value, {bool bold = false}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 13),
        children: [
          TextSpan(text: '$label : ', style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.bold)),
          TextSpan(text: value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
  
  // Helper method to format targets
  String _formatTargets(List<Target> targets) {
    if (targets.isEmpty) return '';
    return targets.map((t) {
      String result = t.text ?? t.title ?? '';
      if (t.qtyNeeded != null) result += ' ${t.qtyNeeded}';
      return result;
    }).join(', ');
  }
  
  // Helper method to format ammunition
  String _formatAmmunition(List<Ammunition> ammunition) {
    if (ammunition.isEmpty) return '';
    return ammunition.map((a) => a.text ?? a.title ?? '').join(', ');
  }
  
  // Helper method to format sights
  String _formatSights(List<Sight> sights) {
    if (sights.isEmpty) return '';
    return sights.map((s) => s.text ?? '').join(', ');
  }
  
  // Helper method to format positions
  String _formatPositions(List<Position> positions) {
    if (positions.isEmpty) return '';
    return positions.map((p) => p.text ?? p.title ?? '').join(', ');
  }
  
  // Helper method to format positions with line breaks for <> characters
  List<InlineSpan> _formatPositionsWithLineBreaks(List<Position> positions) {
    if (positions.isEmpty) return [];
    
    final List<InlineSpan> spans = [];
    for (int i = 0; i < positions.length; i++) {
      final position = positions[i];
      final text = position.text ?? position.title ?? '';
      
      // Process text for <> line breaks
      spans.addAll(_processNotesText(text, style: const TextStyle(color: Colors.black, fontSize: 13)));
      
      // Add comma separator if not the last item
      if (i < positions.length - 1) {
        spans.add(const TextSpan(text: ', '));
      }
    }
    
    return spans;
  }
  
  // Helper method to format ready positions
  String _formatReadyPositions(List<ReadyPosition> readyPositions) {
    if (readyPositions.isEmpty) return '';
    return readyPositions.map((rp) => rp.text ?? '').join(', ');
  }
  
  // Helper method to format ready positions with title in bold
  List<InlineSpan> _formatReadyPositionsWithTitle(List<ReadyPosition> readyPositions) {
    if (readyPositions.isEmpty) return [];
    
    final List<InlineSpan> spans = [];
    for (int i = 0; i < readyPositions.length; i++) {
      final readyPosition = readyPositions[i];
      
      // Add title in bold if it exists
      if (readyPosition.title != null && readyPosition.title!.isNotEmpty) {
        spans.add(TextSpan(
          text: readyPosition.title,
          style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
        ));
        // Add space between title and text if text exists
        if (readyPosition.text != null && readyPosition.text!.isNotEmpty) {
          spans.add(const TextSpan(text: ' '));
        }
      }
      
      // Add text in normal weight
      if (readyPosition.text != null && readyPosition.text!.isNotEmpty) {
        spans.add(TextSpan(
          text: readyPosition.text,
          style: const TextStyle(color: Colors.black, fontSize: 13),
        ));
      }
      
      // Add comma separator if not the last item
      if (i < readyPositions.length - 1) {
        spans.add(const TextSpan(text: ', '));
      }
    }
    
    return spans;
  }
  
  // Helper method to format sighters
  String _formatSighters(List<Sighters> sighters) {
    if (sighters.isEmpty) return '';
    return sighters.map((s) => s.text).join(', ');
  }
  
  // Helper method to process notes text - replaces <> with line breaks
  List<InlineSpan> _processNotesText(String? text, {TextStyle? style}) {
    if (text == null || text.isEmpty) return [];
    
    final parts = text.split('<>');
    final List<InlineSpan> spans = [];
    
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(text: parts[i], style: style));
      }
      // Add line break after each part except the last one
      if (i < parts.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }
    
    return spans;
  }
  
  // Helper method to build practice section
  Widget _buildPractice(Practice practice) {
    final hasMultipleStages = practice.stages.length > 1;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Practice header
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 13),
            children: [
              const TextSpan(text: 'Practice ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '${practice.practiceNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: ' :', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        
        // Stages
        ...practice.stages.map<Widget>((stage) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stage header (only show if multiple stages)
                if (hasMultipleStages) ...[
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: [
                        const TextSpan(text: 'Stage ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '${stage.stageNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: ' :', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                
                // Distance
                if (stage.distance != null) ...[
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: [
                        TextSpan(text: '${stage.distance}'),
                        if (stage.distanceText != null) TextSpan(text: ' ${stage.distanceText}'),
                      ],
                    ),
                  ),
                ],
                
                // Rounds
                if (stage.rounds != null) ...[
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: [
                        TextSpan(text: '${stage.rounds}'),
                        if (stage.roundsText != null) TextSpan(text: ' ${stage.roundsText}'),
                      ],
                    ),
                  ),
                ],
                
                // Time
                if (stage.time != null) ...[
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: [
                        TextSpan(text: '${stage.time}'),
                        if (stage.timeText != null) TextSpan(text: ' ${stage.timeText}'),
                      ],
                    ),
                  ),
                ],
                
                // Notes
                if (stage.notesHeader != null) ...[
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: [
                        TextSpan(text: stage.notesHeader!, style: const TextStyle(fontStyle: FontStyle.italic)),
                        if (stage.notes != null) const TextSpan(text: ' '),
                        if (stage.notes != null) ..._processNotesText(stage.notes, style: const TextStyle(color: Colors.black, fontSize: 13)),
                      ],
                    ),
                  ),
                ] else if (stage.notes != null) ...[
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: _processNotesText(stage.notes, style: const TextStyle(color: Colors.black, fontSize: 13)),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }

}
