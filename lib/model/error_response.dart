class ErrorResponse {
  final String documentation_url;
  final List<Error> errors;
  final String message;
  ErrorResponse(this.documentation_url, this.errors, this.message);
}