/// This object is a representation of the api response coming from our base project
class DjangoAuthenticationResponse {
  final String username;
  final int id;
  final String token;

  DjangoAuthenticationResponse({required this.username, required this.id, required this.token});

  factory DjangoAuthenticationResponse.fromJson(Map<String, dynamic> json) => DjangoAuthenticationResponse(
      username: json["username"],
      id: json["id"],
      token: json["token"]
  );
}
