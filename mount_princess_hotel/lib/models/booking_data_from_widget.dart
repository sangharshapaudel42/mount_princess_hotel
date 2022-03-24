class DataBookingWidget {
  final String? checkIn;
  final String? checkOut;
  final String? roomType;
  final int? adults;
  final int? childrens;

  DataBookingWidget({
    this.checkIn,
    this.checkOut,
    this.roomType,
    this.adults,
    this.childrens,
  });

  // Map<String, dynamic> toJson() => {
  //       "checkIn": checkIn,
  //       "checkOut": checkOut,
  //       "roomType": roomType,
  //       "adults": adults,
  //       "childrens": childrens,
  //     };
}
