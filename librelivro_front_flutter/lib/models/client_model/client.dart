
class Client<T> {

  int id;
  String name;
  String email;
  String city;
  String address;

  Client({
    this.id = 0,
    this.name = '',
    this.email = '',
    this.city = '',
    this.address = ''
  });

  factory Client.fromJson(Map<String, dynamic> item) {
      return Client(
            id: item['id'],
            name: item['name'],
            email: item['email'],
            city: item['city'],
            address: item['address'] 
            );

    }

    Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'city': city,
      'address': address
    };
  }

}