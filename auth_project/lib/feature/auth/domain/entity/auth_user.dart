class AuthUser {
  final String accessToken;
  final String refreshToken;
  final String? idToken;
  final String tokenType;
  final Duration expiresIn;

  const AuthUser({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.idToken,
    required this.expiresIn,
  });
}
