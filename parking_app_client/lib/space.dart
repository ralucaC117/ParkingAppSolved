class Space {
  final int? id;
  final String number;
  final String address;
  final String? status;
  final int? count;

  const Space(
      {required this.number,
      required this.id,
      required this.address,
      required this.status,
      required this.count});

  factory Space.fromJson(Map<String, dynamic> json) {
    return Space(
        id: json['id'],
        number: json['number'],
        address: json['address'],
        status: json['status'],
        count: json['count']);
  }

  @override
  String toString() {
    return 'Space{id: $id, number: $number, address: $address, status: $status, count: $count}';
  }

  static Space fromMap(Map<String, dynamic> res) {
    final space = Space(
        id: res['id'],
        number: res['number'],
        address: res["address"],
        status: res["status"],
        count: res["count"]);
    return space;
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'number': number,
      'address': address,
      'status': status,
      'count': count
    };
  }
}
