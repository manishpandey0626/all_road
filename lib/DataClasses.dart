

import 'dart:io';

import 'package:all_road/Break.dart';

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
  String priority;

  PreCheckQuestion({this.question,this.option1,this.option2,this.answer,this.myanswer,this.priority});
  factory PreCheckQuestion.fromJson(Map<String, dynamic> parsedJson,{status=false}) {
    return PreCheckQuestion(
        question: parsedJson["question"] as String,
        option1: parsedJson["option_1"] as String,
        option2: parsedJson["option_2"] as String,
        answer: parsedJson["answer"] as String,
        priority: parsedJson["priority"] as String,
        myanswer: status? parsedJson["answer"] : null
    );
  }


  Map<String, dynamic> toJson() => {
    "question": question,
    "option1": option1,
    "option2": option2,
    "answer": answer,
    "myanswer":myanswer,
    "priority":priority

  };
}

class TrailerQuestion {
  String question;
  String option1;
  String option2;
  String answer;
  String myanswer;
  String priority;

  TrailerQuestion({this.question,this.option1,this.option2,this.answer,this.myanswer,this.priority});
  factory TrailerQuestion.fromJson(Map<String, dynamic> parsedJson,{status=false}) {
    return TrailerQuestion(
        question: parsedJson["question"] as String,
        option1: parsedJson["option_1"] as String,
        option2: parsedJson["option_2"] as String,
        answer: parsedJson["answer"] as String,
        priority: parsedJson["priority"] as String,
        myanswer: status? parsedJson["answer"] : null
    );
  }

  Map<String, dynamic> toJson() => {
    "question": question,
    "option1": option1,
    "option2": option2,
    "answer": answer,
    "myanswer":myanswer,
    "priority":priority,

  };
}

class JobDetailData {
  String job_id;
  String start_time;
  String start_km;
  String worksite;
  String loads_done;
  String loads_comment;
  String status;
  String truck_id;
  String trailer1_id;
  String trailer2_id;
  String rego;
  String truck_cat;
  String total_run;

  JobDetailData({this.job_id,
    this.start_time,
    this.start_km,
    this.worksite,
    this.loads_done,
    this.loads_comment,
    this.status,
    this.truck_id,
    this.rego,
    this.truck_cat,
    this.trailer1_id,
    this.trailer2_id,
    this.total_run});

  factory JobDetailData.fromJson(Map<String, dynamic> parsedJson) {
    return JobDetailData(
        start_time: parsedJson["shift_start_time"] as String,
        start_km: parsedJson["start_km"] as String,
        worksite: parsedJson["worksite"] as String,
        loads_done: parsedJson["loads_done"] as String,
        loads_comment: parsedJson["loads_comment"] as String,
        job_id: parsedJson["id"] as String,
        status: parsedJson["type_status"] as String,
        truck_id: parsedJson["truck_id"] as String,
        rego: parsedJson["rego"] as String,
        truck_cat: parsedJson["truck_cat"] as String,
        trailer1_id: parsedJson["trailer_id_1"] as String,
        trailer2_id: parsedJson["trailer_id_2"] as String,
        total_run: parsedJson["total_run"] as String

    );
  }
}

class Worksite
{
  String id;
  String name;
  String document;
  Worksite(
      {
        this.id,
        this.name,
        this.document,
      });

  factory Worksite.fromJson(Map<String, dynamic> parsedJson) {
    return Worksite(
      name: parsedJson["category_name"] as String,
      document: parsedJson["document_type"] as String,
      id: parsedJson["id"] as String,


    );
  }

}


class Load
{
  String id;
  String name;

  Load(
      {
        this.id,
        this.name,

      });

  factory Load.fromJson(Map<String, dynamic> parsedJson) {
    return Load(
      name: parsedJson["load_type"] as String,
      id: parsedJson["id"] as String,


    );
  }

}


class JobListingData
{
  String id;
  String rego_no;
  String start_date;
  JobListingData(
      {
        this.id,
        this.rego_no,
        this.start_date,
      });

  factory JobListingData.fromJson(Map<String, dynamic> parsedJson) {
    return JobListingData(
      id: parsedJson["id"] as String,
      rego_no: parsedJson["rego"] as String,
      start_date: parsedJson["start_date"] as String,


    );
  }

}

class ImportantLinksData
{
  String id;
  String name;
  String links;
  ImportantLinksData(
      {
        this.id,
        this.name,
        this.links,
      });

  factory ImportantLinksData.fromJson(Map<String, dynamic> parsedJson) {
    return ImportantLinksData(
      id: parsedJson["id"] as String,
      name: parsedJson["category_name"] as String,
      links: parsedJson["link"] as String,


    );
  }

}


class JobWorksheetData
{
  String id;
  String name;
  String links;
  JobWorksheetData(
      {
        this.id,
        this.name,
        this.links,
      });

  factory JobWorksheetData.fromJson(Map<String, dynamic> parsedJson) {
    return JobWorksheetData(
      id: parsedJson["id"] as String,
      name: parsedJson["worksheet_name"] as String,
      links: parsedJson["worksheet"] as String,


    );
  }

}


class BreakTimeData
{
  String id;
  String time;
  String display_time;
  BreakTimeData(
      {
        this.id,
        this.time,
        this.display_time,
      });

  factory BreakTimeData.fromJson(Map<String, dynamic> parsedJson) {
    return BreakTimeData(
      time: parsedJson["timer"] as String,
      id: parsedJson["id"] as String,
      display_time: parsedJson["display_time"] as String,


    );
  }

}




class WorksheetAttachmentData
{
  String id;
  String name;
  File file;
  WorksheetAttachmentData(
      {
        this.id,
        this.name,
        this.file,
      });

  factory WorksheetAttachmentData.fromJson(Map<String, dynamic> parsedJson) {
    return WorksheetAttachmentData(
      name: parsedJson["category_name"] as String,
      id: parsedJson["id"] as String,
      file:null

    );
  }



}



class Declaration {
  String question;
  bool flag;

  Declaration({this.question,this.flag});
  factory Declaration.fromJson(Map<String, dynamic> parsedJson,{status=false}) {
    return Declaration(
        question: parsedJson["question"] as String,
        flag:false,
    );
  }


}

