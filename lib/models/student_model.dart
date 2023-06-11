class StudentModel {
  final String? studentID;
  final String? sectionID;

  StudentModel(this.studentID, this.sectionID);

  StudentModel.fromJson(Map<String, dynamic> json)
      : studentID = json['id'],
        sectionID = json['sectionId'];

  Map<String, dynamic> toJson() => {
    'id': studentID,
    'studentId': sectionID,
  };
}

