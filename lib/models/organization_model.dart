class OrganizationModel {
  final organizationName;
  final orgPrice;

  OrganizationModel({this.organizationName,this.orgPrice});


  Map<String, dynamic> toJson(){
    Map<String,dynamic> map = {
      'organizationName': organizationName,
      'orgPrice' : orgPrice
    };
    return map;
  }


  factory OrganizationModel.fromJson(Map<String,dynamic> map){
    return OrganizationModel(
      organizationName: map['organizationName'],
      orgPrice: map['orgPrice']
    );
  }
}