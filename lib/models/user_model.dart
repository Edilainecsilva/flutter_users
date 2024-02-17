class UserModel {
   String ? id = "";
   String nameUser = "";
   String email = "";
   String ? urlAvatar;

   UserModel ({
    this.id,
    required this.nameUser,
    required this.email,
     this.urlAvatar,
  });

  UserModel.fromJson(Map<String, dynamic>json){
    id = json['id'];
    nameUser = json['nameUser'];
    email = json['email'];
    urlAvatar = json['urlAvatar'];
  }

  Map<String, dynamic> toJson(){
    final  Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nameUser'] = nameUser;
    data['email'] = email;
    data['urlAvatar'] = urlAvatar;
    return data;
  }
}