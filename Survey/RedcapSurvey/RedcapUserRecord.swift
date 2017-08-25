//
//  RedcapUserRecord.swift
//  LongitudinalStudy1
//
//  Created by Ritter, Dean on 8/24/17.
//  Copyright © 2017 Ritter, Dean. All rights reserved.
//

import Foundation

struct RedcapUserRecord {

    // Core Attributes
    //var redapEventName: Int { get { return base.attributeAsInt(key: "arm_num") } }
    var redcapEventName: String { get { return base.attributeAsString(key: "redcap_event_name") } }

    /////////////////////////////////
    
    // Other Attributes
    var currentEventId: String { return redcapEventName }
    
    init() {
        
    }

    init(data: Dictionary<String, Any>) {
        
        base.coreAttributes = data
    }
    
    private var base = RedcapItemBase()
}

/*
 
 [
 [
    "vob14":,
    "withdraw_reason":,
    "creat_4":,
    "gym___3":0,
    "cpq9":,
    "vbw8":,
    "vbw9":,
    "pmq4":,
    "aerobics___0":0,
    "cpq8":,
    "npcr_b":,
    "last_name":12,
    "eat___2":0,
    "eat___0":0,
    "cpq5":,
    "vld5":,
    "subject_comments":,
    "aerobics___3":0,
    "vbw4":,
    "vbw2":,
    "cpq4":,
    "vob8":,
    "address":13,
    "height":23,
    "vob2":,
    "redcap_event_name":enrollment_arm_1,
    "gym___4":0,
    "num_children":,
    "vob11":,
    "vbw6":,
    "weight2":,
    "baseline_data_complete":0,
    "drink___1":0,
    "drink___3":0,
    "cpq11":,
    "cpq1":,
    "ethnicity":1,
    "cpq12":,
    "vld2":,
    "eat___3":0,
    "cpq7":,
    "dialysis_schedule_days":,
    "meds___4":0,
    "drink___4":0,
    "withdraw_date":,
    "prealb_b":,
    "visit_observed_behavior_complete":,
    "creat_b":,
    "vob12":,
    "specify_mood":0,
    "vld1":,
    "dialysis_unit_phone":,
    "drink___2":0,
    "dialysis_schedule_time":,
    "etiology_esrd":,
    "comments":Zzz,
    "vob13":,
    "completion_project_questionnaire_complete":,
    "vob1":,
    "gym___1":0,
    "sex":1,
    "aerobics___1":0,
    "aerobics___2":0,
    "completion_data_complete":,
    "gym___0":0,
    "vld4":,
    "meds___2":0,
    "meds___1":1,
    "given_birth":,
    "aerobics___4":0,
    "gym___2":0,
    "vob3":,
    "drink___0":0,
    "study_id":23      C837A0-E9CE-4A25-81E6-EC21D5E26674,
    "discharge_summary_4":,
    "vbw1":,
    "alb_4":,
    "vbw7":,
    "date_enrolled":2017-08      -17,
    "date_visit_4":,
    "pmq3":,
    "npcr_4":,
    "eat___1":0,
    "first_name":11,
    "eat___4":0,
    "cpq2":,
    "vbw3":,
    "weight":100,
    "dob":2017-08      -18,
    "discharge_date_4":,
    "bmi":1890.4,
    "chol_4":,
    "cpq10":,
    "vob5":,
    "age":0,
    "study_comments":,
    "vld3":,
    "transferrin_b":,
    "prealb_4":,
    "cpq13":,
    "vob6":,
    "vob9":,
    "patient_document":,
    "bmi2":,
    "meds___5":0,
    "vob4":,
    "patient_morale_questionnaire_complete":,
    "complete_study":,
    "cpq6":,
    "telephone_1":(267) 394-1108,
    "dialysis_unit_name":,
    "race":1,
    "pmq2":,
    "height2":,
    "meds___3":0,
    "email":a@b.com,
    "demographics_complete":0,
    "vob10":,
    "pmq1":,
    "visit_lab_data_complete":,
    "cpq3":,
    "contact_info_complete":0,
    "visit_blood_workup_complete":,
    "chol_b":,
    "vob7":,
    "vbw5":
 ]
 ]
 
 */
