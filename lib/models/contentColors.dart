class ContentColors {
  String colorCodes;
  String colorName;
  ContentColors({this.colorCodes, this.colorName});

  List<ContentColors> getColors() {
    return [
      ContentColors(colorCodes: "#ffffff", colorName: "White (Default)"),
      ContentColors(colorCodes: "#f88379", colorName: "Coral"),
      ContentColors(colorCodes: "#ff69b4", colorName: "Hot Pink"),
      ContentColors(colorCodes: "#eba832", colorName: "Marigold"),
      ContentColors(colorCodes: "#9acd32", colorName: "Yellow Green"),
      ContentColors(colorCodes: "#f4c430", colorName: "Saffron Yellow"),
      ContentColors(colorCodes: "#de5d83", colorName: "Blush"),
      ContentColors(colorCodes: "#fbceb1", colorName: "Apricot"),
      ContentColors(colorCodes: "#e1ad01", colorName: "Mustard Yellow"),
      ContentColors(colorCodes: "#ffffe0", colorName: "Light Yellow"),
      ContentColors(colorCodes: "#aaf0d1", colorName: "Mint"),
      ContentColors(colorCodes: "#fff5ee", colorName: "Seashell"),
      ContentColors(colorCodes: "#FF6700", colorName: "Neon Orange"),
      ContentColors(colorCodes: "#ff4f00", colorName: "International Orange")
    ];
  }
}
