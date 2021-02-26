class Notes {
  String title;
  String content;
  String noteDate;
  String titleColor;
  int titleFontSize;
  int contentFontSize;
  int noteID;
  String contentFont;
  String contentItalic;
  String contentBold;
  String contentColor;
  Notes(
      {this.title,
      this.content,
      this.noteID,
      this.noteDate,
      this.titleColor,
      this.titleFontSize,
      this.contentItalic,
      this.contentBold,
      this.contentFontSize,
      this.contentFont,
      this.contentColor});

  factory Notes.fromJSON(Map<String, dynamic> json) {
    return Notes(
        title: json['title'] ?? '',
        titleFontSize: json['titleFontSize'] ?? 15,
        titleColor: json['titleColor'] ?? '#f5f5f5',
        noteDate: json['noteDate'],
        contentItalic: json['isItalic'],
        contentBold: json['isBold'],
        contentFont: json['contentFont'],
        contentColor: json['contentColor'],
        contentFontSize: json['contentFontSize'],
        content: json['content'] ?? '',
        noteID: json['noteID']);
  }

  Map<String, dynamic> toJSON() {
    var map = {
      "title": this.title,
      "content": this.content,
      "noteID": this.noteID,
      "noteDate": this.noteDate,
      "titleColor": this.titleColor,
      "titleFontSize": this.titleFontSize,
      "contentFont": this.contentFont,
      "isBold": this.contentBold,
      "isItalic": this.contentItalic,
      "contentFontSize": this.contentFontSize,
      "contentColor": this.contentColor
    };
    return map;
  }
}
