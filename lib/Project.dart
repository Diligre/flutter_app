
class Project {
  final String description;
  final String small;
  final String full;
  final String name;

  Project._({this.description,this.name, this.small,this.full});

  factory Project.fromJson(Map<String, dynamic> json) {
    return new Project._(
      description: json['description'] ?? '',
      name: json['user']['name'] ?? '',
      small: json['urls']['small'] ?? 'https://images.unsplash.com/photo-1593642633279-1796119d5482?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjMyNDU2fQ',
      full: json['urls']['full'] ?? 'https://images.unsplash.com/photo-1593642633279-1796119d5482?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjMyNDU2fQ'
    );
  }
}
