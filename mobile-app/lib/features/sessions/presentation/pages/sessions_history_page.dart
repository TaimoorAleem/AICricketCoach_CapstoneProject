import 'package:ai_cricket_coach/features/sessions/presentation/pages/session_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../resources/service_locator.dart';
import '../../domain/usecases/get_sessions_usecase.dart';
import '../bloc/sessions_cubit.dart';
import '../bloc/sessions_state.dart';

class SessionsHistoryPage extends StatelessWidget {
  const SessionsHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = SessionsCubit(getSessionsUseCase: sl<GetSessionsUseCase>());
        cubit.getSessions(); // Fetch sessions immediately
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sessions History'),
        ),
        body: BlocBuilder<SessionsCubit, SessionsState>(
          builder: (context, state) {
            if (state is SessionsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SessionsLoaded) {
              if (state.sessions.isEmpty) {
                return const Center(child: Text('No sessions available.'));
              }
              return ListView.builder(
                itemCount: state.sessions.length,
                itemBuilder: (context, index) {
                  final session = state.sessions[index];
                  return ListTile(
                    title: Text('Session on ${session.date}'),
                    subtitle: Text('Session ID: ${session.sessionId}'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navigate to session details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SessionDetailsPage(session: session),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is SessionsError) {
              return Center(child: Text(state.errorMessage));
            } else {
              return const Center(child: Text('No sessions found.'));
            }
          },
        ),
      ),
    );
  }
}
