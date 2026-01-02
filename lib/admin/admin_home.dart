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
      body: SafeArea(
        child: Padding(
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
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                  children: [
                    const TextSpan(text: 'Targets : ', style: TextStyle(fontWeight: FontWeight.bold)),
                    ..._formatTargetsRich(content.targets, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Ammunition
            if (content.ammunition != null && content.ammunition!.isNotEmpty) ...[
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                  children: [
                    const TextSpan(text: 'Ammunition : ', style: TextStyle(fontWeight: FontWeight.bold)),
                    ..._formatAmmunitionRich(content.ammunition!, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Sights
            if (content.sights.isNotEmpty) ...[
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                  children: [
                    const TextSpan(text: 'Sights : ', style: TextStyle(fontWeight: FontWeight.bold)),
                    ..._formatSightsRich(content.sights, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Position
            if (content.positions.isNotEmpty) ...[
              _buildIndentedFieldWithRichText('Position', _formatPositionsWithLineBreaks(content.positions)),
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
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      const TextSpan(text: 'Distance : ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${content.courseOfFire.distance}'),
                      if (content.courseOfFire.distanceNotes != null && content.courseOfFire.distanceNotes!.isNotEmpty) ...[
                        const TextSpan(text: ' '),
                        ..._processRichText(content.courseOfFire.distanceNotes, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
            
            // Time
            if (content.courseOfFire.totalTime != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      const TextSpan(text: 'Time : ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${content.courseOfFire.totalTime}'),
                      if (content.courseOfFire.timeNotes != null && content.courseOfFire.timeNotes!.isNotEmpty) ...[
                        const TextSpan(text: ' '),
                        ..._processRichText(content.courseOfFire.timeNotes, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
            
            // Rounds
            if (content.courseOfFire.totalRounds != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      const TextSpan(text: 'Rounds : ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${content.courseOfFire.totalRounds}'),
                      if (content.courseOfFire.roundsNotes != null && content.courseOfFire.roundsNotes!.isNotEmpty) ...[
                        const TextSpan(text: ' '),
                        ..._processRichText(content.courseOfFire.roundsNotes, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
            
            // Max Score
            if (content.courseOfFire.maxScore != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      const TextSpan(text: 'Max Score : ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${content.courseOfFire.maxScore}'),
                      if (content.courseOfFire.maxScoreNotes != null && content.courseOfFire.maxScoreNotes!.isNotEmpty) ...[
                        const TextSpan(text: ' '),
                        ..._processRichText(content.courseOfFire.maxScoreNotes, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                      ],
                    ],
                  ),
                ),
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
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                  children: [
                    const TextSpan(text: 'Sighters : ', style: TextStyle(fontWeight: FontWeight.bold)),
                    ..._formatSightersRich(content.sighters!, baseStyle: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Practices
            ...content.practices.map((practice) => _buildPractice(practice)),
            
            // General Notes (new field)
            if (content.generalNotes != null && content.generalNotes!.text != null && content.generalNotes!.text!.isNotEmpty) ...[
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                  children: [
                    const TextSpan(text: 'Notes : ', style: TextStyle(fontWeight: FontWeight.bold)),
                    ..._processRichText(content.generalNotes!.text!, baseStyle: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
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
                        ..._processRichText(rc.title, baseStyle: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                        if (rc.text != null && rc.text!.isNotEmpty) ..._processRichText(rc.text, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                      ],
                    ),
                  ),
                )
              ),
              const SizedBox(height: 8),
            ],
            
            // Scoring
            if (content.scoring != null) ...[
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                  children: [
                    const TextSpan(text: 'Scoring : ', style: TextStyle(fontWeight: FontWeight.bold)),
                    ..._processRichText(content.scoring!.text ?? '', baseStyle: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
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
                      if (content.loading!.title != null && content.loading!.title!.isNotEmpty) ..._processRichText(content.loading!.title, baseStyle: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                      if (content.loading!.text != null && content.loading!.text!.isNotEmpty) const TextSpan(text: ' '),
                      if (content.loading!.text != null && content.loading!.text!.isNotEmpty) ..._processRichText(content.loading!.text, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
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
                      if (content.reloading!.title != null && content.reloading!.title!.isNotEmpty) ..._processRichText(content.reloading!.title, baseStyle: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                      if (content.reloading!.text != null && content.reloading!.text!.isNotEmpty) const TextSpan(text: ' '),
                      if (content.reloading!.text != null && content.reloading!.text!.isNotEmpty) ..._processRichText(content.reloading!.text, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
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
                      if (content.equipment!.title != null && content.equipment!.title!.isNotEmpty) ..._processRichText(content.equipment!.title, baseStyle: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                      if (content.equipment!.text != null && content.equipment!.text!.isNotEmpty) const TextSpan(text: ' '),
                      if (content.equipment!.text != null && content.equipment!.text!.isNotEmpty) ..._processRichText(content.equipment!.text, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
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
                      if (content.rangeEquipment!.title != null && content.rangeEquipment!.title!.isNotEmpty) ..._processRichText(content.rangeEquipment!.title, baseStyle: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                      if (content.rangeEquipment!.text != null && content.rangeEquipment!.text!.isNotEmpty) const TextSpan(text: ' '),
                      if (content.rangeEquipment!.text != null && content.rangeEquipment!.text!.isNotEmpty) ..._processRichText(content.rangeEquipment!.text, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
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
                      if (content.changingPosition!.title != null && content.changingPosition!.title!.isNotEmpty) ..._processRichText(content.changingPosition!.title, baseStyle: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                      if (content.changingPosition!.text != null && content.changingPosition!.text!.isNotEmpty) const TextSpan(text: ' '),
                      if (content.changingPosition!.text != null && content.changingPosition!.text!.isNotEmpty) ..._processRichText(content.changingPosition!.text, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
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
                        ..._processRichText(tie.title, baseStyle: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                        if (tie.text != null && tie.text!.isNotEmpty) ..._processRichText(tie.text, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                        if (tie.idx != null && tie.idx!.isNotEmpty) ...[
                          const TextSpan(text: '\n'),
                          TextSpan(text: '${tie.idx}. '),
                          if (tie.idxText != null && tie.idxText!.isNotEmpty) ..._processRichText(tie.idxText, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                        ],
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
                        ..._processRichText(pp.title, baseStyle: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                        const TextSpan(text: ': '),
                        if (pp.text != null && pp.text!.isNotEmpty) ..._processRichText(pp.text, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                        if (pp.idx != null && pp.idx!.isNotEmpty) ...[
                          const TextSpan(text: '\n'),
                          TextSpan(text: '${pp.idx}. '),
                          if (pp.idxText != null && pp.idxText!.isNotEmpty) ..._processRichText(pp.idxText, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                        ],
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
  
  // Helper method to build a field with rich text that properly indents continuation lines
  Widget _buildIndentedFieldWithRichText(String label, List<InlineSpan> contentSpans) {
    // Calculate the width of the label to determine indent
    const labelStyle = TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold);
    final labelText = '$label : ';
    
    // Use a custom approach: wrap in a Row with Expanded to handle line breaks with indent
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: labelStyle),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 13),
              children: contentSpans,
            ),
          ),
        ),
      ],
    );
  }
  
  // Helper method to format targets with rich text support
  List<InlineSpan> _formatTargetsRich(List<Target> targets, {TextStyle? baseStyle}) {
    if (targets.isEmpty) return [];
    
    final List<InlineSpan> spans = [];
    for (int i = 0; i < targets.length; i++) {
      final target = targets[i];
      String text = target.text ?? target.title ?? '';
      if (target.qtyNeeded != null) text += ' ${target.qtyNeeded}';
      
      spans.addAll(_processRichText(text, baseStyle: baseStyle));
      
      if (i < targets.length - 1) {
        spans.add(const TextSpan(text: ', '));
      }
    }
    return spans;
  }
  
  // Legacy method for backward compatibility
  String _formatTargets(List<Target> targets) {
    if (targets.isEmpty) return '';
    return targets.map((t) {
      String result = t.text ?? t.title ?? '';
      if (t.qtyNeeded != null) result += ' ${t.qtyNeeded}';
      return result;
    }).join(', ');
  }
  
  // Helper method to format ammunition with rich text support
  List<InlineSpan> _formatAmmunitionRich(List<Ammunition> ammunition, {TextStyle? baseStyle}) {
    if (ammunition.isEmpty) return [];
    
    final List<InlineSpan> spans = [];
    for (int i = 0; i < ammunition.length; i++) {
      final ammo = ammunition[i];
      final text = ammo.text ?? ammo.title ?? '';
      
      spans.addAll(_processRichText(text, baseStyle: baseStyle));
      
      if (i < ammunition.length - 1) {
        spans.add(const TextSpan(text: ', '));
      }
    }
    return spans;
  }
  
  // Legacy method for backward compatibility
  String _formatAmmunition(List<Ammunition> ammunition) {
    if (ammunition.isEmpty) return '';
    return ammunition.map((a) => a.text ?? a.title ?? '').join(', ');
  }
  
  // Helper method to format sights with rich text support
  List<InlineSpan> _formatSightsRich(List<Sight> sights, {TextStyle? baseStyle}) {
    if (sights.isEmpty) return [];
    
    final List<InlineSpan> spans = [];
    for (int i = 0; i < sights.length; i++) {
      final sight = sights[i];
      final text = sight.text ?? '';
      
      spans.addAll(_processRichText(text, baseStyle: baseStyle));
      
      if (i < sights.length - 1) {
        spans.add(const TextSpan(text: ', '));
      }
    }
    return spans;
  }
  
  // Legacy method for backward compatibility
  String _formatSights(List<Sight> sights) {
    if (sights.isEmpty) return '';
    return sights.map((s) => s.text ?? '').join(', ');
  }
  
  // Helper method to format positions
  String _formatPositions(List<Position> positions) {
    if (positions.isEmpty) return '';
    return positions.map((p) => p.text ?? p.title ?? '').join(', ');
  }
  
  // Helper method to format positions with rich text support
  List<InlineSpan> _formatPositionsWithLineBreaks(List<Position> positions) {
    if (positions.isEmpty) return [];
    
    final List<InlineSpan> spans = [];
    for (int i = 0; i < positions.length; i++) {
      final position = positions[i];
      final text = position.text ?? position.title ?? '';
      
      // Process text for rich formatting
      spans.addAll(_processRichText(text, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)));
      
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
  
  // Helper method to format ready positions with title in bold and rich text support
  List<InlineSpan> _formatReadyPositionsWithTitle(List<ReadyPosition> readyPositions) {
    if (readyPositions.isEmpty) return [];
    
    final List<InlineSpan> spans = [];
    for (int i = 0; i < readyPositions.length; i++) {
      final readyPosition = readyPositions[i];
      
      // Add title in bold if it exists (with rich text processing)
      if (readyPosition.title != null && readyPosition.title!.isNotEmpty) {
        spans.addAll(_processRichText(
          readyPosition.title,
          baseStyle: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
          alreadyBold: true,
        ));
        // Add space between title and text if text exists
        if (readyPosition.text != null && readyPosition.text!.isNotEmpty) {
          spans.add(const TextSpan(text: ' '));
        }
      }
      
      // Add text in normal weight (with rich text processing)
      if (readyPosition.text != null && readyPosition.text!.isNotEmpty) {
        spans.addAll(_processRichText(
          readyPosition.text,
          baseStyle: const TextStyle(color: Colors.black, fontSize: 13),
        ));
      }
      
      // Add comma separator if not the last item
      if (i < readyPositions.length - 1) {
        spans.add(const TextSpan(text: ', '));
      }
    }
    
    return spans;
  }
  
  // Helper method to format sighters with rich text support
  List<InlineSpan> _formatSightersRich(List<Sighters> sighters, {TextStyle? baseStyle}) {
    if (sighters.isEmpty) return [];
    
    final List<InlineSpan> spans = [];
    for (int i = 0; i < sighters.length; i++) {
      final sighter = sighters[i];
      
      spans.addAll(_processRichText(sighter.text, baseStyle: baseStyle));
      
      if (i < sighters.length - 1) {
        spans.add(const TextSpan(text: ', '));
      }
    }
    return spans;
  }
  
  // Legacy method for backward compatibility
  String _formatSighters(List<Sighters> sighters) {
    if (sighters.isEmpty) return '';
    return sighters.map((s) => s.text).join(', ');
  }
  
  // Universal text processor - handles <> for line breaks and {} for bold text
  List<InlineSpan> _processRichText(String? text, {TextStyle? baseStyle, bool alreadyBold = false}) {
    if (text == null || text.isEmpty) return [];
    
    final List<InlineSpan> spans = [];
    
    // First split by <> for line breaks
    final lineParts = text.split('<>');
    
    for (int lineIndex = 0; lineIndex < lineParts.length; lineIndex++) {
      final line = lineParts[lineIndex];
      
      if (line.isNotEmpty) {
        // Now process each line for {} bold markers
        spans.addAll(_processBoldMarkers(line, baseStyle: baseStyle, alreadyBold: alreadyBold));
      }
      
      // Add line break after each part except the last one
      if (lineIndex < lineParts.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }
    
    return spans;
  }
  
  // Helper to process {} bold markers within a text segment
  List<InlineSpan> _processBoldMarkers(String text, {TextStyle? baseStyle, bool alreadyBold = false}) {
    final List<InlineSpan> spans = [];
    final RegExp boldPattern = RegExp(r'\{([^}]*)\}');
    
    int lastEnd = 0;
    for (final match in boldPattern.allMatches(text)) {
      // Add text before the match (normal or already bold)
      if (match.start > lastEnd) {
        final normalText = text.substring(lastEnd, match.start);
        spans.add(TextSpan(
          text: normalText,
          style: baseStyle,
        ));
      }
      
      // Add the matched text in bold
      final boldText = match.group(1) ?? '';
      if (boldText.isNotEmpty) {
        spans.add(TextSpan(
          text: boldText,
          style: baseStyle?.copyWith(fontWeight: FontWeight.bold) ?? 
                 const TextStyle(fontWeight: FontWeight.bold),
        ));
      }
      
      lastEnd = match.end;
    }
    
    // Add remaining text after last match
    if (lastEnd < text.length) {
      final remainingText = text.substring(lastEnd);
      spans.add(TextSpan(
        text: remainingText,
        style: baseStyle,
      ));
    }
    
    // If no matches were found, return the original text
    if (spans.isEmpty && text.isNotEmpty) {
      spans.add(TextSpan(text: text, style: baseStyle));
    }
    
    return spans;
  }
  
  // Legacy method name for backward compatibility
  List<InlineSpan> _processNotesText(String? text, {TextStyle? style}) {
    return _processRichText(text, baseStyle: style);
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
                        if (stage.distanceText != null && stage.distanceText!.isNotEmpty) ...[
                          const TextSpan(text: ' '),
                          ..._processRichText(stage.distanceText, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                        ],
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
                        if (stage.roundsText != null && stage.roundsText!.isNotEmpty) ...[
                          const TextSpan(text: ' '),
                          ..._processRichText(stage.roundsText, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                        ],
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
                        if (stage.timeText != null && stage.timeText!.isNotEmpty) ...[
                          const TextSpan(text: ' '),
                          ..._processRichText(stage.timeText, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                        ],
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
                        ..._processRichText(stage.notesHeader, baseStyle: const TextStyle(color: Colors.black, fontSize: 13, fontStyle: FontStyle.italic)),
                        if (stage.notes != null) const TextSpan(text: ' '),
                        if (stage.notes != null) ..._processRichText(stage.notes, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
                      ],
                    ),
                  ),
                ] else if (stage.notes != null) ...[
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: _processRichText(stage.notes, baseStyle: const TextStyle(color: Colors.black, fontSize: 13)),
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
