@isTest
private class gctlInsHelperTest {

    @TestSetup
    static void testData() {

        //testData.init();
        List<adnicWS__c> lstGStg = new List<adnicWS__c>();
        adnicWS__c CalPrem = new adnicWS__c(Name='CalPrem', Endpoint__c='https://online.adnic.ae/MedicalAppTest/api/medical/CalcPremium', PartnerID__c='TECOM');  lstGStg.add(CalPrem);
        adnicWS__c jsnCre = new adnicWS__c(Name='Json Creation', Endpoint__c='https://online.adnic.ae/MedicalAppTest/api/medical/CalcPremium', PartnerID__c='TECOM');lstGStg.add(jsnCre);
        adnicWS__c Decrypt = new adnicWS__c(Name='Decrypt', Endpoint__c='https://online.adnic.ae/MedicalAppTest/api/medical/CalcPremium', PartnerID__c='TECOM');lstGStg.add(Decrypt);
        adnicWS__c Encrypt = new adnicWS__c(Name='Encrypt', Endpoint__c='https://online.adnic.ae/MedicalAppTest/api/medical/CalcPremium', PartnerID__c='TECOM');lstGStg.add(Encrypt);

        insert lstGStg;

    }

    @isTest static void method1() {
        Test.startTest();
        Map<String, String> strMap = gctlInsHelper.crtReq('CalPrem', 'PartnerSalt', 'PartnerIV', 'reqBody', 'POST');
        Test.setMock(HttpCalloutMock.class, new gctlInsHelperMock('CalPremSuccess'));
        gctlInsHelper.calPremium(strMap);
        gctlInsHelper.genPolicy(strMap);
        gctlInsHelper.eidaUpdate(strMap);
        gctlInsHelper.uploadDoc(strMap);
        Test.setMock(HttpCalloutMock.class, new gctlInsHelperMock('CalPremError'));
        gctlInsHelper.calPremium(strMap);
        gctlInsHelper.genPolicy(strMap);
        gctlInsHelper.eidaUpdate(strMap);
        gctlInsHelper.uploadDoc(strMap);
        Test.stopTest();
    }

    @isTest static void method2() {
        Test.startTest();
        gctlInsHelper.upperCase('Test');
        gctlInsHelper.getFDt('2022-02-01 00:00:00', '/');
        gctlInsHelper.dateFormat('2022-02-01');
        gctlInsHelper.encryptStr('Testing', 1);
        try{
            gctlInsHelper.decryptStr('Z2FyYmFnZQ', 1);
        } catch (exception e) { }
        gctlInsHelper.getJson(new g_reqitem__c(), new Contact());
        /*g_Req__c r = new g_Req__c();
        insert r;
        g_reqitem__c ri = new g_reqitem__c();
        insert ri; */
        //gctlInsHelper.updateCnt('r.Id', 'Open');
        //gctlInsHelper.updaterqItmErrorMsg('ri.Id', 'error');
        Test.stopTest();
    }

}