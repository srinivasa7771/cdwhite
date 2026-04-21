@istest
private class grHrAxsOICTest {
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
        grHrAxsOIC.HcRequest wrap1 = new grHrAxsOIC.HcRequest();
        wrap1.firstName='Test';
        wrap1.personId='Test';
        wrap1.AXSID='Test';
        wrap1.lastName='Test';
        wrap1.dob='22/11/2019';
        wrap1.gender='Test';
        wrap1.relationship='Test';
        wrap1.nationality='India';
        wrap1.isInsideUAE='Test';
        wrap1.passportNo='Test';
        wrap1.pIssueDate='22/11/2019';
        wrap1.pExpiryDate='22/11/2022';
        wrap1.pPlaceofIssue='22/11/2022';
        wrap1.occupationField='Test';
        wrap1.refMobile='Test';
        wrap1.deliveryZone='Test';
        wrap1.buildingName='Test';
        wrap1.location='Test';
        wrap1.notes='Test';
        wrap1.emirate='Test';
        wrap1.city='Test';
        wrap1.street='Test';
        wrap1.area='Test';
        wrap1.POBox='Test';
        wrap1.POBoxArea='Test';
        wrap1.accomodationType='Test';
        wrap1.sponsorAxsID ='a0E1s0000023vJ1EAI';
       // wrap1.nationality ='India';
        //wrap1.passportNo='qweqweqwe';
        Test.startTest();
        grHrAxsOIC obj = new grHrAxsOIC();
        grHrAxsOIC.createDepReq(wrap1);
        Test.stopTest();
    }

}