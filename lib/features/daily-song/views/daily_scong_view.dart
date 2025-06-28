import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailySongView extends ConsumerStatefulWidget {
  const DailySongView({super.key});

  @override
  ConsumerState<DailySongView> createState() => _DailySongViewState();
}

class _DailySongViewState extends ConsumerState<DailySongView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [SliverAppBar(centerTitle: true, title: Text("오늘의 곡"))],
        ),
      ),
    );
  }
}
