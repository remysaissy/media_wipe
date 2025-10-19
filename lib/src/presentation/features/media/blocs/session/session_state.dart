import 'package:app/src/domain/entities/session.dart';
import 'package:equatable/equatable.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {
  const SessionInitial();
}

class SessionActive extends SessionState {
  final Session session;
  final bool isWhiteListMode;

  const SessionActive({required this.session, this.isWhiteListMode = false});

  @override
  List<Object?> get props => [session, isWhiteListMode];
}

class SessionFinished extends SessionState {
  final Session session;

  const SessionFinished(this.session);

  @override
  List<Object?> get props => [session];
}

class SessionError extends SessionState {
  final String message;

  const SessionError(this.message);

  @override
  List<Object?> get props => [message];
}
