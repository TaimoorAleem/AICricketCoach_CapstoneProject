import 'package:flutter/material.dart';
import '../../../home/data/data_sources/session_cache.dart';
import '../../../../resources/service_locator.dart';
import '../../domain/entities/session.dart';
import '../../domain/usecases/get_sessions_usecase.dart';
import '../widgets/SessionCard.dart';
import '../../../../resources/app_colors.dart';

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
      appBar: AppBar(
        title: const Text(
          'Sessions History',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.secondary,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? _buildMessage('Error: $errorMessage')
          : sessions.isEmpty
          ? _buildMessage('No sessions found')
          : RefreshIndicator(
        onRefresh: _loadSessions,
        child: ListView.builder(
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            return SessionCard(
              session: sessions[index],
              playerId: widget.playerId,
              sessionNumber: sessions.length - index, // 1 is oldest at bottom
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white70,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
