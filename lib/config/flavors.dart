enum Flavor {
  dev,
  prod,
  staging,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'MyApp Dev';
      case Flavor.prod:
        return 'MyApp Prod';
      case Flavor.staging:
        return 'MyApp Staging';
      default:
        return 'title';
    }
  }
}
