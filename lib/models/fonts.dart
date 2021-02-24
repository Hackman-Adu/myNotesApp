class CustomFonts {
  String fontName;
  String family;
  CustomFonts({this.fontName, this.family});

  List<CustomFonts> getFonts() {
    return [
      CustomFonts(fontName: "Default Style", family: "OpenSans-Light"),
      CustomFonts(fontName: "Style 1", family: "Alice-Regular"),
      CustomFonts(fontName: "Style 2", family: "Bentham-Regular"),
      CustomFonts(fontName: "Style 3", family: "Roboto-Black"),
      CustomFonts(fontName: "Style 4", family: "Bulletto Killa"),
      CustomFonts(fontName: "Style 5", family: "Gruppo-Regular"),
      CustomFonts(fontName: "Style 6", family: "Niconne-Regular"),
      CustomFonts(fontName: "Style 7", family: "Pacifico-Regular"),
      CustomFonts(fontName: "Style 8", family: "Parisienne-Regular"),
      CustomFonts(fontName: "Style 9", family: "PoiretOne-Regular"),
      CustomFonts(fontName: "Style 10", family: "Tangerine-Regular"),
    ];
  }
}
