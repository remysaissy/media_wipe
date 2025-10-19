import 'package:app/src/domain/usecases/settings/request_in_app_review_usecase.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_cubit.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SettingsListView extends StatelessWidget {
  const SettingsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsLoaded) {
            return ListView(
              children: [
                _buildSectionHeader('Appearance'),
                ListTile(
                  leading: const Icon(Icons.palette),
                  title: const Text('Theme'),
                  subtitle: Text(_getThemeName(state.settings.themeMode)),
                  trailing: DropdownButton<ThemeMode>(
                    value: state.settings.themeMode,
                    onChanged: (ThemeMode? newValue) {
                      if (newValue != null) {
                        context.read<SettingsCubit>().updateTheme(newValue);
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                _buildSectionHeader('Permissions'),
                ListTile(
                  leading: Icon(
                    Icons.photo_library,
                    color: state.settings.hasPhotosAccess
                        ? Colors.green
                        : Colors.grey,
                  ),
                  title: const Text('Photo Library Access'),
                  subtitle: Text(
                    state.settings.hasPhotosAccess ? 'Granted' : 'Not granted',
                  ),
                  trailing: state.settings.hasPhotosAccess
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : TextButton(
                          onPressed: () {
                            // Navigate to authorize view or request permission
                            context.read<SettingsCubit>().completeOnboarding();
                          },
                          child: const Text('Grant'),
                        ),
                ),
                const Divider(),
                _buildSectionHeader('Developer'),
                SwitchListTile(
                  secondary: const Icon(Icons.bug_report),
                  title: const Text('Debug Mode (Dry Run)'),
                  subtitle: const Text(
                    'Simulate deletions without actually removing files',
                  ),
                  value: state.settings.debugDryRemoval,
                  onChanged: (value) {
                    context.read<SettingsCubit>().updateDebugFlag(value);
                  },
                ),
                const Divider(),
                _buildSectionHeader('Feedback'),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text('Rate This App'),
                  subtitle: const Text('Help us improve with your feedback'),
                  onTap: () async {
                    try {
                      await GetIt.I<RequestInAppReviewUseCase>().execute();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Thank you for your feedback!'),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
                const Divider(),
                _buildSectionHeader('About'),
                const ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Version'),
                  subtitle: Text('1.0.0'),
                ),
              ],
            );
          }

          return const Center(child: Text('Loading settings...'));
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System default';
      case ThemeMode.light:
        return 'Light mode';
      case ThemeMode.dark:
        return 'Dark mode';
    }
  }
}
