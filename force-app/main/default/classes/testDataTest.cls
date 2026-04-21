@IsTest
public class testDataTest {

    @IsTest(SeeAllData=false)
    static void test1() {
        try{
        String bR = testData.bRulesReq;
        String bRI = testData.bRulesItem;
        testData.init();
        testData.bRulesReqCrt();
        testData.bRulesReqCrt();

            testData.createSetting('', '');
            testData.createUser('testUser');
            testData.createCase('test');
        testData.adrsInfoCrt();
        testData.adrsInfoCrt();
        g_srvc_settings__c s=testData.stgCrt();
        testData.reqCrtOptItems(null, null, null, null, null, null);

         testData.srvcCrt(s.id);
        }catch (Exception e) {}
    }
}