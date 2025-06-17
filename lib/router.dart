import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hidi/features/authentication/repos/authentication_auth.dart';
import 'package:hidi/features/authentication/views/login_in_view.dart';
import 'package:hidi/features/authentication/views/sign_up_view.dart';
import 'package:hidi/features/main-screen/views/main_navigation_view.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: '/${MainNavigationView.initialTab}',
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final isLoggIned = ref.read(authRepo).isLoggedIn;
        if (!isLoggIned) {
          if (state.matchedLocation != SignUpView.routeURL &&
              state.matchedLocation != LoginView.routeURL) {
            return SignUpView.routeURL;
          }
        }
        return null;
      },
      routes: [
        GoRoute(
          path: LoginView.routeURL,
          name: LoginView.routeName,
          builder: (context, state) {
            return const LoginView();
          },
        ),
        GoRoute(
          path: SignUpView.routeURL,
          name: SignUpView.routeName,
          builder: (context, state) {
            return const SignUpView();
          },
        ),
      ],
    );
  },
);