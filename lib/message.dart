
class Messages{
  String id;
  String from_id;
  String from_name;
  String to_id;
  String to_name;
  String msg;
  //DateTime created_at;

  Messages(String id,
  String from_id,
  String from_name,
  String to_id,
  String to_name,
  String msg/*,DateTime created_at*/)
  {
    this.id=id;
    this.from_id=from_id;
    this.from_name=from_name;
    this.to_id=to_id;
    this.to_name=to_name;
    this.msg=msg;
   // this.created_at=created_at;
  }

  static fromMap(Map<dynamic,dynamic>hm,String key)
  {
    return Messages(key, hm['from_id'], hm['from_name'], hm['to_id'], hm['to_name'], hm['msg']);
  }
}