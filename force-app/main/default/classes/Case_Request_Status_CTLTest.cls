@isTest
private class Case_Request_Status_CTLTest {
   @testSetup static void setup() {

        List<gStg__c> lstGStg = new List<gStg__c>();
        gStg__c pActivation = new gStg__c(name='ParkingActivation', Text_Value__c = '149');
        lstGStg.add(pActivation);

        gStg__c pLostCard = new gStg__c(name='ParkingLostCard', Text_Value__c = '150');
        lstGStg.add(pLostCard);

        gStg__c pModification = new gStg__c(name='ParkingModification', Text_Value__c = '152');
        lstGStg.add(pModification);

        gStg__c pDetail = new gStg__c(name='ParkingDetail', Text_Value__c = '153');
        lstGStg.add(pDetail);

        gStg__c wsDomain = new gStg__c(name='WSDmn', Text_Value__c = 'cs6');
        lstGStg.add(wsDomain);

        gStg__c tecomDmn = new gStg__c(name='tecomDmn', Text_Value__c = 'tecom--staging.cs6.my');
        lstGStg.add(tecomDmn);

        insert lstGStg;

    }

    static testMethod void doTest() {
        boolean blV;String sV;
        Test.startTest();
            testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            Case cs = new Case();
            cs.Subject = 'test';
            cs.Status = 'Open';
            cs.Type = 'Enquiry';
            cs.Description = 'test';
            cs.Request__c = r.id;
            insert cs;
            Case_Request_Status_CTL obj=new Case_Request_Status_CTL(new ApexPages.StandardController(cs));

    }
}