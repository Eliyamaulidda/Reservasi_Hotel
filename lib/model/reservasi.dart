
class Reservasi {
  final int? id;
  final String nama;
  final String telepon;
  final String photo;

  const Reservasi({this.id, required this.nama, required this.telepon, required this.photo});
  Map<String, dynamic> toList() {
    return {'id': id, 'nama': nama, 'telepon': telepon,'photo': photo };
  }

  @override
  String toString() {
   return "{'id': id, 'nama': nama, 'telepon': telepon,'photo': photo }";
  }
}
