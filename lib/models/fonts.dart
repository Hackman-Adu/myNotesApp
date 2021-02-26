class CustomFonts {
  String fontName;
  String family;
  CustomFonts({this.fontName, this.family});

  List<CustomFonts> getFonts() {
    return [
      CustomFonts(fontName: "Default Style", family: "Manjari-Thin"),
      CustomFonts(fontName: "Style 1", family: "BalooThambi2-Regular"),
      CustomFonts(fontName: "Style 2", family: "AdventPro-Regular"),
      CustomFonts(fontName: "Style 3", family: "Cormorant-Regular"),
      CustomFonts(fontName: "Style 4", family: "Cantarell-Regular"),
      CustomFonts(fontName: "Style 5", family: "Manrope-Regular"),
      CustomFonts(fontName: "Style 6", family: "kalam-Regular"),
      CustomFonts(fontName: "Style 7", family: "Cardo-Regular"),
      CustomFonts(fontName: "Style 8", family: "Archivo-Regular"),
      CustomFonts(fontName: "Style 9", family: "AnnieUseYourTelescope-Regular"),
      CustomFonts(fontName: "Style 10", family: "HiMelody-Regular"),
    ];
  }
}
