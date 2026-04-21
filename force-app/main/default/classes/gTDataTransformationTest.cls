@isTest
private class gTDataTransformationTest {
    private static testmethod void  testgTDataTransformation() {
        Test.startTest();
        testData.init();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);

        list<g_srvcitm__c> itms = [select id, Finance_Group__c, Bill_To__c, ORA_Memo_Line__c from g_srvcitm__c where srvc__c=:s.id];
        for (g_srvcitm__c itm : itms) {
            itm.Finance_Group__c = 'DNRD';
            itm.Bill_To__c = 'AXS';
            itm.ORA_Memo_Line__c = 'AXS-GSO-Employee Visa (3 Years)';
        }
        update itms;
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment', md__c='Customer Deposit');
        insert T;
        g_reqitem__c i = r.Items__r[0];
        List<g_TranItem__c> TIs = new List<g_TranItem__c>();
        TIs.add(new g_TranItem__c(itm__c = i.Id, T__c = T.Id, iRef__c = '20102666341', A__c =552.50, Tp__c = 'Payment', VAT__c=25));
        TIs.add(new g_TranItem__c(itm__c = i.Id, T__c = T.Id, iRef__c = '20102666344', A__c =552.50, Tp__c = 'Payment', VAT__c=35));
        TIs.add(new g_TranItem__c(itm__c = i.Id, T__c = T.Id, iRef__c = '20102666342', A__c =552.50, Tp__c = 'Payment', VAT__c=0));
        TIs.add(new g_TranItem__c(itm__c = i.Id, T__c = T.Id, iRef__c = '20102666343', A__c =552.50, Tp__c = 'Payment', VAT__c=0));
        insert  TIs;

        g_Tran__c rT = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Refund', md__c='Customer Deposit');
        insert rT;
        g_reqitem__c ri = r.Items__r[0];
        List<g_TranItem__c> rTIs = new List<g_TranItem__c>();
        rTIs.add(new g_TranItem__c(itm__c = ri.Id, T__c = rT.Id, iRef__c = '201026663411', A__c =552.50, Tp__c = 'Refund', VAT__c=25));
        rTIs.add(new g_TranItem__c(itm__c = ri.Id, T__c = rT.Id, iRef__c = '201026663441', A__c =552.50, Tp__c = 'Refund', VAT__c=35));
        rTIs.add(new g_TranItem__c(itm__c = ri.Id, T__c = rT.Id, iRef__c = '201026663421', A__c =552.50, Tp__c = 'Refund', VAT__c=0));
        rTIs.add(new g_TranItem__c(itm__c = ri.Id, T__c = rT.Id, iRef__c = '201026663431', A__c =552.50, Tp__c = 'Refund', VAT__c=0));
        insert  rTIs;

        List<ORAMETA__c> oraList = new List<ORAMETA__c>();
        ORAMETA__c ora = new ORAMETA__c();
        ora.SERVICE__c = 'AXS_SERVICE';
        ora.TYPE__c = 'SERVICE';
        ora.SERVICE_TYPE__c = 'AXS';
        ora.BRAND__c = 'AXS';
        ora.PAYMENT_METHOD__c = 'CUSTOMER DEPOSIT';
        oraList.add(ora);
        ORAMETA__c ora1 = new ORAMETA__c();
        ora1.SERVICE__c = 'AXS_SERVICE';
        ora1.TYPE__c = 'CREDIT MEMO';
        ora1.SERVICE_TYPE__c = 'CREDIT_MEMO';
        ora1.BRAND__c = 'AXS';
        ora1.PAYMENT_METHOD__c = 'CUSTOMER DEPOSIT';
        oraList.add(ora1);
        insert oraList;
        gTDataTransformation.mergeTransItm(TIs);
        gTDataTransformation.mergeDMTransItm(TIs);
        gTDataTransformation.datatransformationInv(T.id, 'AXS');
        gTDataTransformation.datatransformationCM(rT.id, 'CREDIT_MEMO');
        gTDataTransformation.datatransformationReceipt(T.id);
        gTDataTransformation.datatransformationReceipt(T.id);
        gTDataTransformation.CMDMApplication(T.id);

        gTDataTransformation.transItm tti=new gTDataTransformation.transItm();
        tti.id=tti.id;
        tti.name=tti.name;

        Test.stopTest();
    }

}