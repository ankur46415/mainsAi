class AppVoiceConfig {
  String? sId;
  String? sourcetype;
  List<Models>? models;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AppVoiceConfig({
    this.sId,
    this.sourcetype,
    this.models,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  AppVoiceConfig.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sourcetype = json['sourcetype'];
    if (json['models'] != null) {
      models = <Models>[];
      json['models'].forEach((v) {
        models!.add(new Models.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['sourcetype'] = this.sourcetype;
    if (this.models != null) {
      data['models'] = this.models!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Models {
  String? key;
  String? sourcename;
  String? modelname;
  String? description;
  String? status;
  String? sId;

  Models({
    this.key,
    this.sourcename,
    this.modelname,
    this.description,
    this.status,
    this.sId,
  });

  Models.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    sourcename = json['sourcename'];
    modelname = json['modelname'];
    description = json['description'];
    status = json['status'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['sourcename'] = this.sourcename;
    data['modelname'] = this.modelname;
    data['description'] = this.description;
    data['status'] = this.status;
    data['_id'] = this.sId;
    return data;
  }
}
