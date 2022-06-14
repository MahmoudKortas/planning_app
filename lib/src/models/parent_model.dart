class Parent {
  String? id;
  String? name;
  String? type;

  Parent({this.id, this.name, this.type});

  Parent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    return data;
  }

  @override
  String toString() => 'Parent(id: $id, name: $name, type: $type)';
}
