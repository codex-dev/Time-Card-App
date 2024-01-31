class RegexPatterns{
  static final RegExp regexValidPersonName = RegExp(r"^[a-zA-Z]+(([',.-][a-zA-Z ])?[a-zA-Z]*)*$");
  static final RegExp regexValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
}