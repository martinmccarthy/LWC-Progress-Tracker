public with sharing class ProgressTrackerController {
    public class TrackerObjectSetting {
        Id id;
        String strName;
        Boolean boolIsActive;
        String strObjectName;
        FieldSetting[] listProgressTrackerFieldSettings;
    }

    public class FieldSetting {
        Id id;
        String strName;
        String strFieldAPIName;
        Boolean boolIsActive;
        Boolean boolIsComplete;
        Integer intOrder;
        Resource[] listProgressTrackerResources;
    }

    public class Resource {
        String strLabel;
        String strLink;
        Boolean boolIsActive;
        Integer intOrder;
    }

    @AuraEnabled(cacheable=false)
    public static String getProgressTrackerObjectSettings(String ObjectSettingId, String recordId){
        Id progressTrackerObjectSettingKey = ObjectSettingId;
        Progress_Tracker_Object_Setting__mdt queriedObjectSetting = 
            [SELECT Id, IsActive__c, 
             Object_Name__c, Label 
             FROM Progress_Tracker_Object_Setting__mdt WHERE Id = :progressTrackerObjectSettingKey];
        
        List<Progress_Tracker_Field_Setting__mdt> listProgressTrackerFieldSettings = 
            [SELECT Id, IsActive__c, Label, Field_API_Name__c, IsComplete__c, Order__c, Progress_Tracker_Object_Setting__c 
             FROM Progress_Tracker_Field_Setting__mdt 
             WHERE Progress_Tracker_Object_Setting__r.Id = :progressTrackerObjectSettingKey];
        
        TrackerObjectSetting trackerObjectSetting = new TrackerObjectSetting();
        trackerObjectSetting.id = queriedObjectSetting.Id;
        trackerObjectSetting.strName = queriedObjectSetting.Label;
        trackerObjectSetting.boolIsActive = queriedObjectSetting.IsActive__c;
        trackerObjectSetting.strObjectName = queriedObjectSetting.Object_Name__c;
        trackerObjectSetting.listProgressTrackerFieldSettings = new List<FieldSetting>();
        
        String fieldAPINames = '';
        for(Progress_Tracker_Field_Setting__mdt currentFieldSetting : listProgressTrackerFieldSettings) {
            if(fieldAPINames == '') {
                fieldAPINames += currentFieldSetting.Field_API_Name__c;
            }
            else {
                fieldAPINames +=  ', ' + currentFieldSetting.Field_API_Name__c;
            }
        }

        List<SObject> listRecordPageFields;
        SObject currentRecordPageField;
        if(fieldAPINames.length() > 0) {
            try {
                listRecordPageFields = Database.query('SELECT ' + fieldAPINames + ' FROM ' + trackerObjectSetting.strObjectName + ' WHERE Id =\'' + recordId + '\'');
                if(listRecordPageFields.size() > 0) {
                    currentRecordPageField = listRecordPageFields[0];
                }
            }
            catch(Exception ex) {
                System.debug(ex);
            }
        }
        
        for(Progress_Tracker_Field_Setting__mdt currentFieldSetting : listProgressTrackerFieldSettings) {
            FieldSetting newProgressTrackerFieldSetting = new FieldSetting();
            newProgressTrackerFieldSetting.id = currentFieldSetting.Id;
            newProgressTrackerFieldSetting.boolIsActive = currentFieldSetting.IsActive__c;
            
            if(currentRecordPageField == null) {
                newProgressTrackerFieldSetting.boolIsComplete = false;
            }
            else if(currentRecordPageField.getSobjectType().getDescribe().fields.getMap().progressTrackerObjectSettingKeySet().contains(currentFieldSetting.Field_API_Name__c.toLowerCase())) {
                if(currentRecordPageField.get(currentFieldSetting.Field_API_Name__c) == true) {
                    newProgressTrackerFieldSetting.boolIsComplete = true;
                }
                else {
                    newProgressTrackerFieldSetting.boolIsComplete = false;
                }    
            }
            else { // Fail case
                newProgressTrackerFieldSetting.boolIsComplete = false;
            }

            newProgressTrackerFieldSetting.strName = currentFieldSetting.Label;
            newProgressTrackerFieldSetting.intOrder = Integer.valueOf(currentFieldSetting.Order__c);
            newProgressTrackerFieldSetting.strFieldAPIName = currentFieldSetting.Field_API_Name__c;
            newProgressTrackerFieldSetting.listProgressTrackerResources = new List<Resource>();
            // Queries the Resources associated with the current Progress Tracker Field Setting
            List<Progress_Tracker_Resource__mdt> listProgressTrackerResources = [SELECT Id, Label, Link__c, IsActive__c, Order__c
                                                                      FROM Progress_Tracker_Resource__mdt
                                                                      WHERE Progress_Tracker_Field_Setting__r.Id =: currentFieldSetting.id];
            for(Progress_Tracker_Resource__mdt currentResource : listProgressTrackerResources) {
                Resource newResource = new Resource();
                newResource.strLabel = currentResource.Label;
                newResource.strLink = currentResource.Link__c;
                newResource.boolIsActive = currentResource.IsActive__c;
                newResource.intOrder = Integer.valueOf(currentResource.Order__c);
                newProgressTrackerFieldSetting.listProgressTrackerResources.add(newResource);
            }
            trackerObjectSetting.listProgressTrackerFieldSettings.add(newProgressTrackerFieldSetting);
        }
        return JSON.serialize(trackerObjectSetting);
    }
}
