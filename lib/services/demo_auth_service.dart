// Demo Auth Service - Works without Firebase for testing
class DemoUser {
  final String uid;
  final String email;
  final String displayName;

  DemoUser({required this.uid, required this.email, required this.displayName});
}

class DemoAuthService {
  static DemoUser? _currentUser;

  // Demo credentials
  static const String demoEmail = 'demo@netapro.com';
  static const String demoPassword = 'demo123';
  static const String demoName = 'Demo User';

  DemoUser? get currentUser => _currentUser;

  Future<DemoUser> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
    _currentUser = DemoUser(
      uid: 'demo_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: name,
    );
    return _currentUser!;
  }

  Future<DemoUser> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network

    // Accept demo credentials or any credentials for demo
    if (email == demoEmail && password == demoPassword) {
      _currentUser = DemoUser(
        uid: 'demo_user_123',
        email: demoEmail,
        displayName: demoName,
      );
    } else {
      // For demo, accept any email/password
      _currentUser = DemoUser(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: email.split('@').first,
      );
    }
    return _currentUser!;
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }
}
