class Publisher {
  int id;
  String name;
  String city;

  Publisher({
    this.id = 0,
    this.name = '',
    this.city = ''
    });

    factory Publisher.fromJson(Map<String, dynamic> item) {
      return  Publisher(
            id: item['id'],
            name: item['name'],
            city: item['city']
            );

    }

    Map<String, dynamic> toJson() {
      return {
         'name': name,
         'city': city

      };
    }

}