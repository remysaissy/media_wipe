import 'package:app/settings/router.dart';
import 'package:app/assets/commands/sessions/drop_all_sessions_command.dart';
import 'package:app/assets/models/asset_model.dart';
import 'package:app/assets/widgets/year.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app/assets/commands/assets/refresh_photos_command.dart';
import 'package:app/shared/utils.dart';
import 'package:app/l10n/app_localizations.dart';

class ListYearsView extends StatefulWidget {
  const ListYearsView({super.key});

  @override
  State<StatefulWidget> createState() => ListYearsViewState();
}

class ListYearsViewState extends State<ListYearsView> {
  late bool _isSortAsc;
  late List<int> _years;

  Future<void> _initState() async {
    await RefreshPhotosCommand(context).run();
  }

  @override
  void initState() {
    _isSortAsc = false;
    WidgetsBinding.instance.addPostFrameCallback((_) => _initState());
    super.initState();
  }

  Future<void> _pullRefresh() async {
    await RefreshPhotosCommand(context).run();
  }

  void _onToggleSort() {
    setState(() => _isSortAsc = !_isSortAsc);
  }

  void _onSettings() {
    if (!mounted) return;
    context.pushNamed(SettingsRouter.list);
  }

  @override
  Widget build(BuildContext context) {
    _years = context.watch<AssetsModel>().listYears(isAsc: _isSortAsc);
    Widget child =
        _years.isEmpty ? Utils.buildLoading(context) : _buildContent(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.listingYearsTitle),
          actions: [
            IconButton(
              onPressed: _onToggleSort,
              icon: Transform.flip(
                  flipY: _isSortAsc,
                  child: const Icon(Icons.filter_list_outlined)),
            ),
            IconButton(
              onPressed: _onSettings,
              icon: const Icon(Icons.settings_outlined),
            ),
            IconButton(
                onPressed: () async {
                  await DropAllSessionsCommand(context).run();
                },
                icon: const Icon(Icons.lock_reset))
          ],
        ),
        body: SafeArea(child: child));
  }

  Widget _buildContent(BuildContext context) {
    return RefreshIndicator.adaptive(
        onRefresh: _pullRefresh,
        child: ListView.builder(
            itemCount: _years.length,
            itemBuilder: (BuildContext context, int index) {
              final year = _years[index];
              return Year(year: year.toString());
            }));
  }
}
