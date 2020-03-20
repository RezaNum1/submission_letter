class UtilRTRW {
  static convertDateTime(String date) {
    var months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    var parsedDate = DateTime.parse(date);
    var monthText = months[parsedDate.month - 1];
    var fullDate = "${parsedDate.day} ${monthText} ${parsedDate.year}";
    return fullDate;
  }
}
