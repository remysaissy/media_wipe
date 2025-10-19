import 'package:app/src/domain/usecases/media/authorize_photos_usecase.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class AuthorizeView extends StatelessWidget {
  const AuthorizeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Library Access'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.photo_library, size: 100, color: Colors.blue),
            const SizedBox(height: 32),
            const Text(
              'Photo Library Access Required',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'This app needs access to your photo library to help you organize and manage your media files.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildPermissionItem(
                      Icons.visibility,
                      'View Your Photos',
                      'Browse and review your photo library',
                    ),
                    const SizedBox(height: 16),
                    _buildPermissionItem(
                      Icons.delete_outline,
                      'Delete Photos',
                      'Remove unwanted media files',
                    ),
                    const SizedBox(height: 16),
                    _buildPermissionItem(
                      Icons.security,
                      'Privacy Protected',
                      'Your photos stay on your device',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await GetIt.I<AuthorizePhotosUseCase>().execute();

                  // Update settings to reflect permission grant
                  if (context.mounted) {
                    context.read<SettingsCubit>().completeOnboarding();

                    // Navigate to media view
                    context.go('/media');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                        action: SnackBarAction(
                          label: 'Retry',
                          textColor: Colors.white,
                          onPressed: () {
                            // Retry authorization
                          },
                        ),
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.check_circle),
              label: const Text('Grant Access'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Limited Functionality'),
                    content: const Text(
                      'Without photo library access, this app cannot function. You can grant access later in Settings.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Not Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
