// TODO: Maybe instead of putting "Edit Abraham's interests", just put "NEXT"

extension StringTruncator on String {
  String truncateWithEllipsis(int length) {
    final String firstName = this.split(" ").first;
    return (firstName.length <= length)
        ? firstName
        : "${firstName.substring(0, length)}...";
  }
}
