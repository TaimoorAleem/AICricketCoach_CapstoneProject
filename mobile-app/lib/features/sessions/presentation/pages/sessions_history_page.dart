import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/data/data_sources/session_cache.dart';
import '../../../../resources/service_locator.dart';
import '../../domain/entities/session.dart';
import '../../domain/usecases/get_sessions_usecase.dart';
import '../widgets/SessionCard.dart';

class SessionsHistoryPage extends StatefulWidget {
  final String playerId;

  const SessionsHistoryPage({super.key, required this.playerId});

  @override
  State<SessionsHistoryPage> createState() => _SessionsHistoryPageState();
}

class _SessionsHistoryPageState extends State<SessionsHistoryPage> {
  bool isLoading = true;
  String errorMessage = '';
  List<Session> sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final usecase = sl<GetSessionsUseCase>();

    final result = await usecase(playerUid: widget.playerId);

    result.fold(
          (error) {
        setState(() {
          isLoading = false;
          errorMessage = error;
        });
      },
          (fetchedSessions) {
        SessionCache().storeSessions(fetchedSessions);
        setState(() {
          sessions = fetchedSessions;
          isLoading = false;
        });
      },
    );
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
          ? const Center(child: Text('No sessions found'))
          : RefreshIndicator(
        onRefresh: _loadSessions,
        child: ListView.builder(
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            return SessionCard(
              session: sessions[index],
              playerId: widget.playerId,
            );
          },
        ),
      ),
    );
  }
}
