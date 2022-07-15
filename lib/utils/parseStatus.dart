 String parseStatus(String? status) {
    switch (status) {
      case "PENDING":
        return "Pendiente";
      case "COOKING":
        return "Cocinando";
      case "INTRANSIT":
        return "En transito";
      case "DELIVERED":
        return "Entregado";
      case "CANCELED":
        return "Cancelado";
      default:
        return "Pendiente";
    }
  }