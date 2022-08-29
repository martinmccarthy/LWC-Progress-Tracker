@isTest
public class ProgressTrackerControllerTest {

    /* Generic test right here, just grabs an object setting after inseting it
       in */
    @isTest static void getProgressTrackerObjectSettingsWithOpportunity() {
        Opportunity testOpportunity = new Opportunity(
            StageName = 'Sourcing Demand',
            CloseDate = date.valueOf('2016-01-01'),
            Name = 'Test Opportunity',
            IsTest__c = true
        );
        insert testOpportunity;

        Progress_Tracker_Object_Setting__mdt testObjectSetting = [SELECT Id, IsActive__c, Object_Name__c, Label
                                                                  FROM Progress_Tracker_Object_Setting__mdt
                                                                  WHERE Label =: 'Testing Setting'];

        Test.startTest();
        ProgressTrackerController.getProgressTrackerObjectSettings(testObjectSetting.Id, testOpportunity.Id);
        Test.stopTest();
    }
}
