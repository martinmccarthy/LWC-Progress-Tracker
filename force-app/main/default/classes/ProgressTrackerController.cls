public with sharing class ProgressTrackerController {
    public class TrackerObjectSetting {
        Id id;
        String name;
        Boolean isActive;
        String objectName;
        FieldSetting[] fieldSettings;
    }

    public class FieldSetting {
        Id id;
        String name;
        String fieldAPIName;
        Boolean isActive;
        Boolean isComplete;
        Integer order;
        Resource[] resources;
    }

    public class Resource {
        String info;
        String link;
        Boolean isActive;
        Integer order;
    }

    // Cache issue here
    @AuraEnabled(cacheable=false)
    public static String getProgressTrackerObjectSettings(String ObjectSettingId, String recordId){
        Id key = ObjectSettingId;
        Progress_Tracker_Object_Setting__mdt objectSettings = 
                [SELECT Id, IsActive__c, Object_Name__c, Label
                FROM Progress_Tracker_Object_Setting__mdt
                WHERE Id = :key];
        List<Progress_Tracker_Field_Setting__mdt> fieldSettings = [SELECT Id, IsActive__c, Label, Field_API_Name__c, IsComplete__c, Order__c, Progress_Tracker_Object_Setting__c 
                                                                   FROM Progress_Tracker_Field_Setting__mdt 
                                                                   WHERE Progress_Tracker_Object_Setting__r.Id = :key];
        
        TrackerObjectSetting trackerObjectSetting = new TrackerObjectSetting();
        trackerObjectSetting.id = objectSettings.Id;
        trackerObjectSetting.name = objectSettings.Label;
        trackerObjectSetting.isActive = objectSettings.IsActive__c;
        trackerObjectSetting.objectName = objectSettings.Object_Name__c;
        
        trackerObjectSetting.fieldSettings = new List<FieldSetting>();
        String fieldAPINames = '';
        for(Progress_Tracker_Field_Setting__mdt fieldSetting : fieldSettings) {
            if(fieldAPINames == '') {
                fieldAPINames += fieldSetting.Field_API_Name__c;
            }
            else {
                fieldAPINames +=  ', ' + fieldSetting.Field_API_Name__c;
            }
        }
        List<SObject> objectList;
        SObject currentObject;
        if(fieldAPINames.length() > 0) {
            try {
                objectList = Database.query('SELECT ' + fieldAPINames + ' FROM ' + trackerObjectSetting.objectName + ' WHERE Id =\'' + recordId + '\'');
                if(objectList.size() > 0) {
                    currentObject = objectList[0];
                }
            }
            catch(Exception ex) {
                System.debug(ex);
            }

        }
        
        for(Progress_Tracker_Field_Setting__mdt fieldSetting : fieldSettings) {
            FieldSetting newSetting = new FieldSetting();
            newSetting.id = fieldSetting.Id;
            newSetting.isActive = fieldSetting.IsActive__c;
            
            if(currentObject == null) {
                newSetting.isComplete = false;
            }
            else if(currentObject.getSobjectType().getDescribe().fields.getMap().keySet().contains(fieldSetting.Field_API_Name__c.toLowerCase())) {
                if(currentObject.get(fieldSetting.Field_API_Name__c) == true) {
                    newSetting.isComplete = true;
                }
                else {
                    newSetting.isComplete = false;
                }    
            }
            else {
                newSetting.isComplete = false;
            }
            // query(0065400000HRSkeAAH.fieldAPIName) -> getFields -> if fieldAPIName === true -> isComplete = true;
            newSetting.name = fieldSetting.Label;
            newSetting.order = Integer.valueOf(fieldSetting.Order__c);
            newSetting.fieldAPIName = fieldSetting.Field_API_Name__c;
            newSetting.resources = new List<Resource>();
            List<Progress_Tracker_Resource__mdt> progressResources = [SELECT Id, Label, Link__c, IsActive__c, Order__c
                                                                      FROM Progress_Tracker_Resource__mdt
                                                                      WHERE Progress_Tracker_Field_Setting__r.Id =: fieldSetting.id];
            for(Progress_Tracker_Resource__mdt resource : progressResources) {
                Resource newResource = new Resource();
                newResource.info = resource.Label;
                newResource.link = resource.Link__c;
                newResource.isActive = resource.IsActive__c;
                newResource.order = Integer.valueOf(resource.Order__c);
                newSetting.resources.add(newResource);
            }
            trackerObjectSetting.fieldSettings.add(newSetting);
        }
        System.debug(JSON.serialize(trackerObjectSetting));
        return JSON.serialize(trackerObjectSetting);
    }
}
