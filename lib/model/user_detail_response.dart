class UserDetailsResponse {
  final String name;
  final String login;
  final String avatar_url;
  final String bio;
  final String location;
  final String html_url;
  final String blog;
  final String email;
  final int public_repos;
  final int public_gists;
  final int followers;
  final int following;
  final String created_at;
  final String updated_at;

  UserDetailsResponse(
      this.name,
      this.login,
      this.avatar_url,
      this.bio,
      this.location,
      this.html_url,
      this.blog,
      this.email,
      this.public_repos,
      this.public_gists,
      this.followers,
      this.following,
      this.created_at,
      this.updated_at,
      );
}