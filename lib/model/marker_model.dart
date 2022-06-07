class marker_model {
  final String markerId;
  final double latitude;
  final double longitude;
  final String title;
  final List customer;
  final String business_id;
  final String ImageUrl;
  final String type;
  final String Address;
  final String Descritpion;

  marker_model(
      {this.Descritpion,
      this.customer,
      this.type,
      this.Address,
      this.business_id,
      this.ImageUrl,
      this.markerId,
      this.latitude,
      this.longitude,
      this.title});
}
