class Notes {
  String title;
  String content;
  String noteDate;
  String titleColor;
  int titleFontSize;
  int noteID;
  Notes(
      {this.title,
      this.content,
      this.noteID,
      this.noteDate,
      this.titleColor,
      this.titleFontSize});

  factory Notes.fromJSON(Map<String, dynamic> json) {
    return Notes(
        title: json['title'] ?? '',
        titleFontSize: json['titleFontSize'] ?? 15,
        titleColor: json['titleColor'] ?? '#f5f5f5',
        noteDate: json['noteDate'],
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
      "titleFontSize": this.titleFontSize
    };
    return map;
  }
}