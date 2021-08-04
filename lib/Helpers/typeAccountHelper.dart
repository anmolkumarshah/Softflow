typeAccount(value) {
  switch (value) {
    case 0:
      return "Admin";
    case 1:
      return "Traffic Master";
    case 2:
      return "Supervisor";
    case 3:
      return "User Account";
    default:
      return "Error";
  }
}
