bool isEmpty(String value) {
  return value == null || value.isEmpty;
}

bool isBlank(String s) => s == null || s.trim().isEmpty;
