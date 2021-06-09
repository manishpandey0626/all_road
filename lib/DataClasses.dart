class DriverManualData {
  String name;
  String file_name;
  DriverManualData({this.name, this.file_name});
  factory DriverManualData.fromJson(Map<String, dynamic> parsedJson) {
    return DriverManualData(
        name: parsedJson["name"] as String,
        file_name: parsedJson["pdf"] as String,

    );
  }
}

class AudioData {
  String name;
  String file_name;
  String disp_img_url;
  AudioData({this.name, this.file_name,this.disp_img_url});
  factory AudioData.fromJson(Map<String, dynamic> parsedJson) {
    return AudioData(
      name: parsedJson["name"] as String,
      file_name: parsedJson["category_name"] as String,
      disp_img_url: parsedJson["cat_img"] as String,
    );
  }
}

class VideoData {
  String name;
  String file_name;
  String disp_img_url;
  VideoData({this.name, this.file_name,this.disp_img_url});
  factory VideoData.fromJson(Map<String, dynamic> parsedJson) {
    return VideoData(
      name: parsedJson["name"] as String,
      file_name: parsedJson["category_name"] as String,
      disp_img_url: parsedJson["cat_img"] as String,

    );
  }
}

class DriverTestData {
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  String answer;
  String myanswer;

  DriverTestData({this.question,this.option1,this.option2,this.option3,this.option4,this.answer,this.myanswer});
  factory DriverTestData.fromJson(Map<String, dynamic> parsedJson) {
    return DriverTestData(
      question: parsedJson["question"] as String,
      option1: parsedJson["option_1"] as String,
      option2: parsedJson["option_2"] as String,
      option3: parsedJson["option_3"] as String,
      option4: parsedJson["option_4"] as String,
      answer: parsedJson["answer"] as String,
      myanswer:null
    );
  }
}


class TruckCatetory {
  String id;
  String name;
  String question;
  TruckCatetory({this.id, this.name,this.question});
  factory TruckCatetory.fromJson(Map<String, dynamic> parsedJson) {
    return TruckCatetory(
      id: parsedJson["id"] as String,
      name: parsedJson["category_name"] as String,
      question: parsedJson["question"] as String,

    );
  }
}


class Truck
{

  String id;
  String truck_cat;
  String make;
  String model;
  String truck_image;
  String rego;
  String registration_expiry;
  String registration_certificate;
  String total_run;
  String insurance_expiry_date;
  String fifth_wheel_expiry_date;
  String speed_expiry_date;
  String total_run_service;
  String total_run_previous;

  Truck(
  {this.id,
      this.truck_cat,
      this.make,
      this.model,
      this.truck_image,
      this.rego,
      this.registration_expiry,
      this.registration_certificate,
      this.total_run,
      this.insurance_expiry_date,
      this.fifth_wheel_expiry_date,
      this.speed_expiry_date,
      this.total_run_service,
      this.total_run_previous}
      );

  factory Truck.fromJson(Map<String, dynamic> parsedJson) {
    return Truck(
      id: parsedJson["id"] as String,
      truck_cat: parsedJson["truck_cat"] as String,
      make: parsedJson["make"] as String,
      model: parsedJson["model"] as String,
      truck_image: parsedJson["truck_image"] as String,
      rego: parsedJson["rego"] as String,
      registration_expiry: parsedJson["registration_expiry"] as String,
      registration_certificate: parsedJson["registration_certificate"] as String,
      total_run: parsedJson["total_run"] as String,
      insurance_expiry_date: parsedJson["insurance_expiry_date"] as String,
      fifth_wheel_expiry_date: parsedJson["fifth_wheel_expiry_date"] as String,
      speed_expiry_date: parsedJson["speed_expiry_date"] as String,
      total_run_service: parsedJson["total_run_service"] as String,
      total_run_previous: parsedJson["total_run_previous"] as String,

    );
  }
}


class PreCheckQuestion {
  String question;
  String option1;
  String option2;
  String answer;
  String myanswer;

  PreCheckQuestion({this.question,this.option1,this.option2,this.answer,this.myanswer});
  factory PreCheckQuestion.fromJson(Map<String, dynamic> parsedJson,{status=false}) {
    return PreCheckQuestion(
        question: parsedJson["question"] as String,
        option1: parsedJson["option_1"] as String,
        option2: parsedJson["option_2"] as String,
        answer: parsedJson["answer"] as String,
        myanswer: status? parsedJson["answer"] : null
    );
  }


  Map<String, dynamic> toJson() => {
    "question": question,
    "option1": option1,
    "option2": option2,
    "answer": answer,
    "myanswer":myanswer,

  };
}

class TrailerQuestion {
  String question;
  String option1;
  String option2;
  String answer;
  String myanswer;

  TrailerQuestion({this.question,this.option1,this.option2,this.answer,this.myanswer});
  factory TrailerQuestion.fromJson(Map<String, dynamic> parsedJson,{status=false}) {
    return TrailerQuestion(
        question: parsedJson["question"] as String,
        option1: parsedJson["option_1"] as String,
        option2: parsedJson["option_2"] as String,
        answer: parsedJson["answer"] as String,
        myanswer: status? parsedJson["answer"] : null
    );
  }

  Map<String, dynamic> toJson() => {
    "question": question,
    "option1": option1,
    "option2": option2,
    "answer": answer,
    "myanswer":myanswer,

  };
}

class JobDetailData
{
  String job_id;
  String start_time;
  String start_km;
  String worksite;
  String loads_done;
  String loads_comment;
  String status;

  JobDetailData({this.job_id,this.start_time,this.start_km,this.worksite,this.loads_done,this.loads_comment,this.status});
  factory JobDetailData.fromJson(Map<String, dynamic> parsedJson) {
    return JobDetailData(
      start_time : parsedJson["shift_start_time"] as String,
      start_km : parsedJson["start_km"] as String,
      worksite : parsedJson["worksite"] as String,
      loads_done : parsedJson["loads_done"] as String,
      loads_comment : parsedJson["loads_comment"] as String,
      job_id : parsedJson["id"] as String,
      status:parsedJson["type_status"] as String
    );
  }

}




