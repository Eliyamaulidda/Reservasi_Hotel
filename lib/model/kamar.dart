
class Kamar {
  final int? id;
  final String nomor;
  final String jeniskamar;
  final String jumlahpesan;
  final String harga;
  final String photo;

  const Kamar({this.id, required this.nomor, required this.jeniskamar, required this.jumlahpesan, required this.harga, required this.photo});
  Map<String, dynamic> toList() {
    return {'id': id, 'nomor': nomor, 'jeniskamar': jeniskamar,'jumlahpesan': jumlahpesan, 'harga': harga, 'photo': photo };
  }

  @override
  String toString() {
   return "{'id': id, 'nomor': nomor, 'jeniskamar': jeniskamar,'jumlahpesan': jumlahpesan, 'harga': harga, 'photo': photo }";
  }
}
