import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../resources/service_locator.dart';
import '../../domain/entities/session.dart';
import '../../domain/usecases/get_sessions_usecase.dart';
import 'session_details_page.dart';

class SessionsHistoryPage extends StatefulWidget {
  final String playerUid; // ✅ Player ID received from CoachHomePage

  const SessionsHistoryPage({super.key, required this.playerUid});

  @override
  _SessionsHistoryPageState createState() => _SessionsHistoryPageState();
}

class _SessionsHistoryPageState extends State<SessionsHistoryPage> {
  List<Session> sessions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    final getSessions = sl<GetSessionsUseCase>();
    try {
      final result = await getSessions.call(playerUid: widget.playerUid);
      result.fold(
            (error) {
          setState(() {
            errorMessage = error;
            isLoading = false;
          });
        },
            (fetchedSessions) {
          setState(() {
            sessions = fetchedSessions;
            isLoading = false;
          });
        },
      );
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sessions History')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text('Error: $errorMessage'))
          : sessions.isEmpty
          ? const Center(child: Text('No sessions available'))
          : ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text('Session Date: ${session.date}'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionDetailsPage(
                      session: session,
                      playerId: widget.playerUid, // ✅ Pass playerUid to SessionDetailsPage
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
