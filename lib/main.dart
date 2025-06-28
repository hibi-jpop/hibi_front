import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidi/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  runApp(ProviderScope(child: Hidi()));
}

class Hidi extends ConsumerWidget {
  const Hidi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.read(routerProvider),
      title: 'Hibi',
    );
  }
}
