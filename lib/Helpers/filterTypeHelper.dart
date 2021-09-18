filterType(int value) {
  switch (value) {
    case 0:
      return "All DO";
    case 1:
      return "Truck Not Assigned";
    case 2:
      return "Truck Assigned";
    case 3:
      return "Truck Reached";
    case 4:
      return "Truck Dispatched";
    default:
      return "Error";
  }
}
