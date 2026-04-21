@istest private class grqHtest{

    static TestMethod void doTest() {

            boolean blV;String sV; /*MS*/
            grqH.rBefore=grqH.rBefore;
            grqH.rAfter=grqH.rAfter;
            grqH.iBefore=grqH.iBefore;
            grqH.iAfter=grqH.iAfter;
            testData.init();
            gStg__c cs = new gStg__c();
            cs.name = 'slaExpiry';
            cs.Number_Value__c = 50;
            insert cs;
            testData.bRulesReqCrt();testData.bRulesItemCrt();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
            Contact emp=testData.conCrt(sp,a.Id,'Active','Employee','Pass2','Egypt');
            g_Req__c r=testData.reqCrt(a.Id,s.Id,emp.Id,'Open',stg.reqq__c);
        Test.startTest();
            grqH.reInit4Test();
            r.STA__c = 'Under Review';update r;
            list<g_srvcitm_Status__c> STAs=[select id,itm__c,slaa__c,Milestone__c    from g_srvcitm_Status__c where itm__r.srvc__c=:s.id and cd__c='c' and isDeleted = false];
            for (g_reqitem__c i:r.Items__r){for (g_srvcitm_Status__c iSTA:STAs){ if (i.itm__c==iSTA.itm__c ){i.STA__c=iSTA.id;}}}
            update r.Items__r;
            /*for (g_reqitem__c i:r.Items__r){for (g_srvcitm_Status__c iSTA:STAs){ if (i.itm__c==iSTA.itm__c && iSTA.slaa__c =='Completed'){i.STA__c=iSTA.id;}}}
            update r.Items__r;
            for (g_reqitem__c i:r.Items__r){for (g_srvcitm_Status__c iSTA:STAs){ if (i.itm__c==iSTA.itm__c ){i.STA__c=iSTA.id;}}}
            update r.Items__r; */

            //call the AP method
            Set<Id> riIds = new Set<Id>();
            for (g_reqitem__c i:r.Items__r){
                riIds.add(i.Id);
            }

            g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c,RQ__c=r.Id,TP__c='Payment',STA__c='Completed');
            new grqh.rh().AP(r,T,riIds);

        Attachment att = new Attachment(ParentId =r.Id,Name='Attachment',Body=Blob.valueOf('Test Data'));
            insert att;delete att;
            grqH.reInit4Test();
            delete r.Items__r;
            grqH.reInit4Test();
            delete r;
           Test.stopTest();
    }
}