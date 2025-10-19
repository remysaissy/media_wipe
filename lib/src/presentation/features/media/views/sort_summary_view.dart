import 'package:app/src/presentation/features/media/blocs/media/media_bloc.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_event.dart';
import 'package:app/src/presentation/features/media/blocs/session/session_cubit.dart';
import 'package:app/src/presentation/features/media/blocs/session/session_state.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_cubit.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SortSummaryView extends StatelessWidget {
  final int year;
  final int month;

  const SortSummaryView({super.key, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary $year/$month'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, state) {
          if (state is SessionFinished) {
            final session = state.session;
            final toDropCount = session.assetsToDrop.length;
            final refinedCount = session.refineAssetsToDrop.length;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.summarize, size: 80, color: Colors.blue),
                  const SizedBox(height: 24),
                  const Text(
                    'Review Complete',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildStatRow(
                            'Assets to Delete',
                            toDropCount.toString(),
                            Colors.red,
                            Icons.delete_outline,
                          ),
                          const Divider(height: 32),
                          _buildStatRow(
                            'Assets to Keep',
                            refinedCount.toString(),
                            Colors.green,
                            Icons.check_circle_outline,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (toDropCount > 0) ...[
                    ElevatedButton.icon(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: Text(
                              'Are you sure you want to delete $toDropCount ${toDropCount == 1 ? 'item' : 'items'}? This cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true && context.mounted) {
                          final settingsCubit = context.read<SettingsCubit>();
                          final isDryRun =
                              (settingsCubit.state is SettingsLoaded)
                              ? (settingsCubit.state as SettingsLoaded)
                                    .settings
                                    .debugDryRemoval
                              : false;

                          context.read<MediaBloc>().add(
                            DeleteMediaEvent(
                              assets: session.assetsToDrop,
                              isDryRun: isDryRun,
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Deleting $toDropCount ${toDropCount == 1 ? 'item' : 'items'}...',
                              ),
                            ),
                          );

                          context.go('/media');
                        }
                      },
                      icon: const Icon(Icons.delete),
                      label: Text(
                        'Delete $toDropCount ${toDropCount == 1 ? 'Item' : 'Items'}',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  OutlinedButton.icon(
                    onPressed: () {
                      context.go('/media');
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Media'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  if (refinedCount > 0) ...[
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () {
                        context.read<SessionCubit>().startSession(
                          year: year,
                          month: month,
                          isWhiteListMode: true,
                        );
                        context.go('/media/$year/$month/swipe?mode=refine');
                      },
                      icon: const Icon(Icons.replay),
                      label: const Text('Review Kept Items'),
                    ),
                  ],
                ],
              ),
            );
          }

          return const Center(child: Text('No session data available'));
        },
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
