class MerchantData {
  final String idx;
  final String tid;
  final String mid;
  final String merchant;
  final String idjo;
  final String? area;
  final String fotoMesin;
  final String fotoStruk;
  final String tidMerchant;

  MerchantData({
    required this.idx,
    required this.tid,
    required this.mid,
    required this.merchant,
    required this.idjo,
    required this.area,
    required this.fotoMesin,
    required this.fotoStruk,
    required this.tidMerchant,
  });

  factory MerchantData.fromJson(Map<String, dynamic> json) {
    return MerchantData(
      idx: json['IDX'],
      tid: json['TID'],
      mid: json['MID'],
      merchant: json['MERCHANT'],
      idjo: json['IDJO'],
      area: json['AREA'],
      fotoMesin: json['FOTO_MESIN'],
      fotoStruk: json['FOTO_STRUK'],
      tidMerchant: json['TID_Merchant'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IDX': idx,
      'TID': tid,
      'MID': mid,
      'MERCHANT': merchant,
      'IDJO': idjo,
      'AREA': area,
      'FOTO_MESIN': fotoMesin,
      'FOTO_STRUK': fotoStruk,
      'TID_Merchant': tidMerchant,
    };
  }
}
