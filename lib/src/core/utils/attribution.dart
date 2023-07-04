class Attribution {
  static generateUrlAttribution(String path) {
    String initial = path.split("/").last.substring(0, 2);
    String value = "";
    switch (initial) {
      case "01":
        return "https://www.tiktok.com/@homem.aranha.alvinegro";
      case "02":
        return "https://twitter.com/Botafogo";
      case "03":
        return "https://www.tiktok.com/@gordin_rj";
      case "04":
        return "https://www.tiktok.com/@botafogo";
      case "05":
        return "https://www.tiktok.com/@mcjackbrabo_";
    }
    return value;
  }

  static generateNameAttribution(String path) {
    String initial = path.split("/").last.substring(0, 2);
    String value = "";
    switch (initial) {
      case "01":
        value = "Sigam o tiktok do @homem.aranha.alvinegro";
        break;
      case "02":
        value = "Sigam o twitter do @Botafogo";
        break;
      case "03":
        value = "Sigam o tiktok do @gordin_rj";
        break;
      case "04":
        value = "Sigam o tiktok do @Botafogo";
        break;
      case "05":
        value = "Sigam o tiktok do @mcjackbrabo_";
        break;
    }
    return value;
  }
}
