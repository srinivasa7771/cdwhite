@isTest
private class gctlUBOTest {
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

        gStg__c paidParking = new gStg__c(name='AdditionalParking', Text_Value__c = '154');
        lstGStg.add(paidParking);

        gStg__c ParkingCancellation = new gStg__c(name='ParkingCancellation', Text_Value__c = '155');
        lstGStg.add(ParkingCancellation);

        gStg__c ParkingDeact = new gStg__c(name='ParkingDeact', Text_Value__c = '157');
        lstGStg.add(ParkingDeact);
        gStg__c tst1 = new gStg__c(name='INS_STD', Text_Value__c = 'tst;tst;');
        lstGStg.add(tst1);
        gStg__c tst3 = new gStg__c(name='INS_SPO', Text_Value__c = 'tst;tst;');
        lstGStg.add(tst3);
        gStg__c tst2 = new gStg__c(name='INS_CHLD', Text_Value__c = 'tst;tst;');
        lstGStg.add(tst2);
        insert lstGStg;
    }

    static testMethod void doTest() {
        boolean blV;String sV;

        testData.init();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);

        gStg__c stg1 = new gStg__c();
        stg1.name = 'guprfl';
        stg1.Checkbox_Value__c = true;
        stg1.Currency_Value__c = 12;
        stg1.Number_Value__c = 43;
        stg1.Text_Value__c = '00e20000001Ak2YAAS';
        insert stg1;
        //------------------------------------------------
        //

        Contact c = new Contact();
        c.idtxt__c = '2730';
        c.rp__c = 'qwdqwed';
        c.lastName = 'khan';
        insert c;

        Contact c1 = new Contact();
        c1.rp__c = 'qwdqwed';
        c1.lastName = 'khan';
        c1.Spon__c = c.id;
        c1.rol__c = 'Spouse';
        insert c1;

        Test.startTest();

        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('id', '2730');
        System.currentPageReference().getParameters().put('enc', '27301111');

        gctlUBO obj=new gctlUBO(new ApexPages.StandardController(r));
        obj.rq=obj.rq;obj.srv=obj.srv;obj.Acc=obj.Acc;obj.md=obj.md;
        Blob txt = Blob.valueOf('tst');
        obj.imageBase64 = txt; obj.docName = 'test.jpg';
        obj.uploadDocToRQ();
        obj.delDocFromRQ();
        obj.completeReq();
        g_Req__c rqNew = new g_Req__c();
        obj=new gctlUBO(new ApexPages.StandardController(rqNew));
        ApexPages.CurrentPage().getParameters().put('sid', s.Id);
        obj=new gctlUBO(new ApexPages.StandardController(rqNew));
        obj.rq.Acc__c = a.id;
        Test.stopTest();
    }

}