import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/sessions_cubit.dart';
import '../cubit/sessions_state.dart';
import 'session_details_page.dart';

class SessionsHistoryPage extends StatelessWidget {
  const SessionsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions History'),
      ),
      body: BlocBuilder<SessionsCubit, SessionsState>(
        builder: (context, state) {
          if (state is SessionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SessionsError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is SessionsLoaded) {
            final sessions = state.sessions;
            return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return ListTile(
                  title: Text('Session ${session.sessionId}'),
                  subtitle: Text('Date: ${session.date.toString()}'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SessionDetailsPage(sessionId: session.sessionId),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const Center(child: Text('No sessions available.'));
        },
      ),
    );
  }
}
