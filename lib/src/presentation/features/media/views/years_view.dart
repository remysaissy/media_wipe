import 'package:app/src/core/routing/app_router.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_bloc.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_event.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class YearsView extends StatefulWidget {
  const YearsView({super.key});

  @override
  State<YearsView> createState() => _YearsViewState();
}

class _YearsViewState extends State<YearsView> {
  @override
  void initState() {
    super.initState();
    context.read<MediaBloc>().add(const LoadMediaEvent());
  }

  Map<int, int> _groupAssetsByYear(MediaLoaded state) {
    final yearCounts = <int, int>{};
    for (final asset in state.assets) {
      final year = asset.creationDate.year;
      yearCounts[year] = (yearCounts[year] ?? 0) + 1;
    }
    return yearCounts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Years'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MediaBloc>().add(const RefreshMediaEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<MediaBloc, MediaState>(
        builder: (context, state) {
          if (state is MediaLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MediaRefreshing) {
            return Stack(
              children: [
                _buildYearsList(MediaLoaded(state.currentAssets)),
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(),
                ),
              ],
            );
          }

          if (state is MediaLoaded) {
            return _buildYearsList(state);
          }

          if (state is MediaError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MediaBloc>().add(const LoadMediaEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('No media loaded'));
        },
      ),
    );
  }

  Widget _buildYearsList(MediaLoaded state) {
    final yearCounts = _groupAssetsByYear(state);

    if (yearCounts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No media found', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
              'Pull to refresh or check your permissions',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final sortedYears = yearCounts.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return RefreshIndicator(
      onRefresh: () async {
        context.read<MediaBloc>().add(const RefreshMediaEvent());
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        itemCount: sortedYears.length,
        itemBuilder: (context, index) {
          final year = sortedYears[index];
          final count = yearCounts[year]!;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(child: Text(year.toString().substring(2))),
              title: Text(
                year.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('$count ${count == 1 ? 'item' : 'items'}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push(
                  AppRouter.mediaForYear.replaceAll(':year', year.toString()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
