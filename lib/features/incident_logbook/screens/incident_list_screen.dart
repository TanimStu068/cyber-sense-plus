import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';
import 'incident_detail_screen.dart';
import 'add_edit_incident_screen.dart';

class IncidentListScreen extends StatelessWidget {
  const IncidentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentProvider = Provider.of<IncidentProvider>(context);

    if (incidentProvider.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0E21),
        body: Center(
          child: CircularProgressIndicator(color: Colors.greenAccent),
        ),
      );
    }

    final incidents = incidentProvider.incidents;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21), // Dark cyber theme background
      appBar: AppBar(
        title: const Text(
          "Incident Logbook",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        backgroundColor: const Color(0xFF1F2233),
        foregroundColor: Colors.cyanAccent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        elevation: 2,
      ),
      body: incidents.isEmpty
          ? const Center(
              child: Text(
                "No incidents logged yet.",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                final incident = incidents[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: const Color(0xFF1F2233),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Status Indicator
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: incident.severity == "High"
                                ? Colors.redAccent
                                : incident.severity == "Medium"
                                ? Colors.orangeAccent
                                : Colors.greenAccent,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Incident Info (tappable for details)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => IncidentDetailScreen(
                                    incidentId: incident.id,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  incident.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  incident.category,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Reported: ${incident.date}",
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Edit Button
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.greenAccent,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AddEditIncidentScreen(incident: incident),
                              ),
                            );
                          },
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white38,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditIncidentScreen()),
          );
        },
        tooltip: "Add New Incident",
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
