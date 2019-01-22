class Contact {
  int id;
  String name;
  DateTime dob;
  String phone = '';
  String email = '';
  String favoriteColor = '';

  Contact(this.name, this.email, this.phone, this.favoriteColor, this.dob);

  Contact.origin() {
    name = '';
    email = '';
    phone = '';
    favoriteColor = '';
    dob = DateTime.now();
  }
}