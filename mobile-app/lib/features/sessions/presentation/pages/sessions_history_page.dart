import 'package:flutter/material.dart';
import 'package:ai_cricket_coach/core/network/dio_client.dart';
import 'package:ai_cricket_coach/features/sessions/data/network/sessions_api_service.dart';
import 'package:ai_cricket_coach/features/sessions/data/data_sources/sessions_remote_data_source.dart';
import 'package:ai_cricket_coach/features/sessions/data/repositories/session_repository_impl.dart';
import 'package:ai_cricket_coach/features/sessions/domain/usecases/get_sessions.dart';
import 'package:ai_cricket_coach/features/sessions/domain/entities/session.dart';
import 'session_details_page.dart';

class SessionsHistoryPage extends StatefulWidget {
  const SessionsHistoryPage({super.key});

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
    final dioClient = DioClient('https://my-app-image-174827312206.us-central1.run.app');
    final apiService = SessionApiService(dioClient);
    final remoteDataSource = SessionsRemoteDataSource(apiService);
    final repository = SessionRepositoryImpl(remoteDataSource: remoteDataSource);
    final getSessions = GetSessions(repository);

    const testUid = 'user123';

    try {
      final fetchedSessions = await getSessions.execute(testUid);
      setState(() {
        sessions = fetchedSessions;
        isLoading = false;
      });
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
          return ListTile(
            title: Text('Session Date: ${session.date}'),
            subtitle: Text(
              'Average Accuracy: ${session.averageAccuracy}%\n'
                  'Average Execution Rating: ${session.averageExecutionRating} / 10',
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SessionDetailsPage(session: session),
                ),
              );
            },
          );
        },
      ),
    );
  }
}