class UserData {
  final String name;
  final double score;
  final bool verified;
  final String imageUrl;
  final String _atService;
  final String phone;

  UserData(
      {this.name = 'John E.',
      this.score = 4.9,
      this.verified = true,
      this.imageUrl =
          'http://89.253.237.166/v1/storage/buckets/64abdd27c9326a1cdfde/files/64abe12a025c0060fe51/view?project=64987d0f7f186b7e2b45',
      String createdAt = '2022-10-01',
      this.phone = '12345678910'})
      : _atService = createdAt;

  UserData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        score = 4.9,
        verified = json['verified'],
        imageUrl = json['image'] ?? 'http://89.253.237.166/v1/storage/buckets/64abdd27c9326a1cdfde/files/64abe12a025c0060fe51/view?project=64987d0f7f186b7e2b45',
        _atService = json['\$createdAt'],
        phone = json['phone'];

  String get atService {
    final gotData = DateTime.parse(_atService);
    final int year = gotData.year;
    final String month = _addZeroInStart(gotData.month);
    final String day = _addZeroInStart(gotData.day);
    return '$year.$month.$day';
  }

  String _addZeroInStart(int num) => num.toString().length > 1 ? num.toString() : '0$num';
}
