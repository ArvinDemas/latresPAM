class Amiibo {
  final String amiiboSeries;
  final String character;
  final String gameSeries;
  final String head;
  final String image;
  final String name;
  final String tail;
  final String type;
  final Map<String, String>? release;

  Amiibo({
    required this.amiiboSeries,
    required this.character,
    required this.gameSeries,
    required this.head,
    required this.image,
    required this.name,
    required this.tail,
    required this.type,
    this.release,
  });

  factory Amiibo.fromJson(Map<String, dynamic> json) {
    return Amiibo(
      // Menggunakan toString() untuk memastikan aman jika API mengembalikan angka/boolean
      amiiboSeries: json['amiiboSeries']?.toString() ?? 'Unknown',
      character: json['character']?.toString() ?? 'Unknown',
      gameSeries: json['gameSeries']?.toString() ?? 'Unknown',
      head: json['head']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      tail: json['tail']?.toString() ?? '',
      type: json['type']?.toString() ?? 'Unknown',
      
      // --- BAGIAN YANG DIPERBAIKI ---
      // Kita map manual agar jika value-nya null, diganti jadi strip (-)
      release: json['release'] != null
          ? (json['release'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key, 
                value?.toString() ?? '-', // Jika null, ganti jadi '-'
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amiiboSeries': amiiboSeries,
      'character': character,
      'gameSeries': gameSeries,
      'head': head,
      'image': image,
      'name': name,
      'tail': tail,
      'type': type,
      'release': release,
    };
  }
}