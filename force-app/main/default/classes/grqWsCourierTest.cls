@istest
private class grqWsCourierTest {
    @testSetup
    static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        gStg__c crtstng = testData.createSetting('test', 'testvalue');
        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c req=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
    }
    static testmethod void test() {
        g_Req__c req= [SELECt id  FROM g_Req__c LIMIT 1];
        Test.startTest();
            grqWsCourier obj = new grqWsCourier();
            grqWsCourier.wsCourBooking(req.id);
        Test.stopTest();
    }
}