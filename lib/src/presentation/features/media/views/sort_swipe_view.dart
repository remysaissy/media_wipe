import 'package:app/src/core/routing/app_router.dart';
import 'package:app/src/presentation/features/media/blocs/session/session_cubit.dart';
import 'package:app/src/presentation/features/media/blocs/session/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SortSwipeView extends StatefulWidget {
  final int year;
  final int month;
  final String? mode;

  const SortSwipeView({
    super.key,
    required this.year,
    required this.month,
    this.mode,
  });

  @override
  State<SortSwipeView> createState() => _SortSwipeViewState();
}

class _SortSwipeViewState extends State<SortSwipeView> {
  @override
  void initState() {
    super.initState();
    final isWhiteList = widget.mode == 'refine';
    context.read<SessionCubit>().startSession(
      year: widget.year,
      month: widget.month,
      isWhiteListMode: isWhiteList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.year}/${widget.month}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () {
              context.read<SessionCubit>().undoLastOperation();
            },
          ),
        ],
      ),
      body: BlocConsumer<SessionCubit, SessionState>(
        listener: (context, state) {
          if (state is SessionFinished) {
            final route = AppRouter.sortSummary
                .replaceAll(':year', widget.year.toString())
                .replaceAll(':month', widget.month.toString());
            context.pushReplacement(route);
          }

          if (state is SessionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SessionInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SessionActive) {
            final asset = state.session.assetInReview;

            if (asset == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Review Complete!',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<SessionCubit>().finishSession();
                      },
                      child: const Text('View Summary'),
                    ),
                  ],
                ),
              );
            }

            return GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! > 0) {
                    // Swipe right - Keep
                    context.read<SessionCubit>().keepAsset();
                  } else if (details.primaryVelocity! < 0) {
                    // Swipe left - Drop
                    context.read<SessionCubit>().dropAsset();
                  }
                }
              },
              child: Stack(
                children: [
                  // Asset display (placeholder - would show actual media)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 300,
                          height: 400,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.photo, size: 64),
                              const SizedBox(height: 16),
                              Text('Asset ID: ${asset.assetId}'),
                              const SizedBox(height: 8),
                              Text(
                                asset.creationDate.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back, size: 32),
                            SizedBox(width: 16),
                            Text('Swipe to sort'),
                            SizedBox(width: 16),
                            Icon(Icons.arrow_forward, size: 32),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Progress indicator
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: _calculateProgress(state.session),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${state.session.assetsToDrop.length} to drop • ${state.session.refineAssetsToDrop.length} refined',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  // Action buttons
                  Positioned(
                    bottom: 32,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                          heroTag: 'drop',
                          onPressed: () {
                            context.read<SessionCubit>().dropAsset();
                          },
                          backgroundColor: Colors.red,
                          child: const Icon(Icons.delete),
                        ),
                        FloatingActionButton(
                          heroTag: 'keep',
                          onPressed: () {
                            context.read<SessionCubit>().keepAsset();
                          },
                          backgroundColor: Colors.green,
                          child: const Icon(Icons.check),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is SessionFinished) {
            return const Center(child: Text('Session finished'));
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  double _calculateProgress(dynamic session) {
    final totalAssets =
        session.assetsToDrop.length +
        session.refineAssetsToDrop.length +
        (session.assetInReview != null ? 1 : 0);
    final reviewed =
        session.assetsToDrop.length + session.refineAssetsToDrop.length;
    return totalAssets > 0 ? reviewed / totalAssets : 0;
  }
}
