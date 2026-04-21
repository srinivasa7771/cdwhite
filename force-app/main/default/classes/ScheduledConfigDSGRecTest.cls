@isTest
public class ScheduledConfigDSGRecTest {

    @testSetup static void setup() {
        List<gStg__c> lstGStg = new List<gStg__c>();
        gStg__c scheduledDSGRec_30 = new gStg__c(name='scheduledDSGRec_30', Text_Value__c = '0 30 * * * ?');
        gStg__c scheduledDSGRec_0 = new gStg__c(name='scheduledDSGRec_0', Text_Value__c = '0 0 * * * ?');
        lstGStg.add(scheduledDSGRec_30);lstGStg.add(scheduledDSGRec_0);

        insert lstGStg;
    }

    static testmethod  void testScheduleIt() {
        Test.startTest();
        ScheduledConfigDSGRec.scheduleIt('test1', 'test2');
        Test.stopTest();
    }
}