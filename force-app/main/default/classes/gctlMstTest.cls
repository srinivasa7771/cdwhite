@isTest
private class gctlMstTest {
    static testmethod void test() {
        Test.startTest();
            List<g_Milestone__c> mList = new List<g_Milestone__c>();
            gctlMst obj = new gctlMst();
            obj.mst=mList;
            obj.srName ='test';
            system.assertEquals(obj.mst, mList);
        Test.stopTest();
    }
}