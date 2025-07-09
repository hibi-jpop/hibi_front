class Artist {
  final int id;
  final String nameKor;
  final String nameEng;
  final String nameJp;

  Artist({
    required this.id,
    required this.nameKor,
    required this.nameEng,
    required this.nameJp,
  });

  Artist.empty() : id = 0, nameKor = "히비", nameEng = "Hibi", nameJp = "日々";
  Artist copyWith({int? id, String? nameKor, String? nameEng, String? nameJp}) {
    return Artist(
      id: id ?? this.id,
      nameKor: nameKor ?? this.nameKor,
      nameEng: nameEng ?? this.nameEng,
      nameJp: nameJp ?? this.nameJp,
    );
  }

  Artist.fromJson(Map<String, dynamic> data)
    : id = data['id'],
      nameKor = data["nameKor"],
      nameEng = data["nameEng"],
      nameJp = data["nameJp"];

  Map<String, dynamic> toJson() {
    return {"id": id, "nameKor": nameKor, "nameEng": nameEng, "nameJp": nameJp};
  }
}
