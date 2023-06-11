class QRModel {
  final String? studentID;
  final String? sectionID;

  QRModel(this.studentID, this.sectionID);

  QRModel.fromJson(Map<String, dynamic> json)
      : studentID = json['id'],
        sectionID = json['sectionId'];

  Map<String, dynamic> toJson() => {
    'id': studentID,
    'studentId': sectionID,
  };
}

