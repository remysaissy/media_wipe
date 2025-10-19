import 'package:app/src/core/routing/app_router.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_bloc.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_event.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MonthsView extends StatefulWidget {
  final int year;

  const MonthsView({super.key, required this.year});

  @override
  State<MonthsView> createState() => _MonthsViewState();
}

class _MonthsViewState extends State<MonthsView> {
  @override
  void initState() {
    super.initState();
    context.read<MediaBloc>().add(RefreshMediaEvent(year: widget.year));
  }

  Map<int, int> _groupAssetsByMonth(MediaLoaded state) {
    final monthCounts = <int, int>{};
    for (final asset in state.assets) {
      if (asset.creationDate.year == widget.year) {
        final month = asset.creationDate.month;
        monthCounts[month] = (monthCounts[month] ?? 0) + 1;
      }
    }
    return monthCounts;
  }

  String _getMonthName(int month) {
    final date = DateTime(widget.year, month);
    return DateFormat.MMMM().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.year}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MediaBloc>().add(
                RefreshMediaEvent(year: widget.year),
              );
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
                _buildMonthsList(MediaLoaded(state.currentAssets)),
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
            return _buildMonthsList(state);
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
                      context.read<MediaBloc>().add(
                        RefreshMediaEvent(year: widget.year),
                      );
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

  Widget _buildMonthsList(MediaLoaded state) {
    final monthCounts = _groupAssetsByMonth(state);

    if (monthCounts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No media found for this year',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('Pull to refresh', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    final sortedMonths = monthCounts.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return RefreshIndicator(
      onRefresh: () async {
        context.read<MediaBloc>().add(RefreshMediaEvent(year: widget.year));
        await Future.delayed(const Duration(seconds: 1));
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: sortedMonths.length,
        itemBuilder: (context, index) {
          final month = sortedMonths[index];
          final count = monthCounts[month]!;
          final monthName = _getMonthName(month);

          return Card(
            elevation: 2,
            child: InkWell(
              onTap: () {
                final route = AppRouter.sortSwipe
                    .replaceAll(':year', widget.year.toString())
                    .replaceAll(':month', month.toString());
                context.push(route);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      monthName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$count ${count == 1 ? 'item' : 'items'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
