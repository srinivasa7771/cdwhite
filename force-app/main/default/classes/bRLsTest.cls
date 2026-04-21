@isTest
private class bRLsTest {
    static testMethod void doTest() {
        Test.startTest();
            testData.init();
            testData.bRulesReqCrt();testData.bRulesItemCrt();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Draft', stg.reqq__c);
            list<bRLs.bRL> rules = bRLs.parse('IB', testData.bRulesReq);
            grqH.xObj o = new grqH.xObj(r, null);
            o.pl.mv.put('@isN', true);o.pl.mv.put('@isD', true);o.pl.mv.put('@isO', false);o.pl.mv.put('@chgSTA', false);
            o.pl.mv.put('@isUR', false);o.pl.mv.put('@isIP', false);o.pl.mv.put('@isCP', false);
            o.pl.mv.put('@isRJ', false);o.pl.mv.put('@isCL', false);o.pl.mv.put('@isOH', false);
            o.pl.mv.put('@hasC', true);o.pl.mv.put('@hadC', false);o.pl.mv.put('@chgC', true);
            o.pl.mv.put('@hasSP', false);o.pl.mv.put('@hadSP', false);o.pl.mv.put('@chgSP', true);
            o.pl.mv.put('@hasNP', true);o.pl.mv.put('@hadNP', false);o.pl.mv.put('@chgNP', true);
            o.pl.mo.put('#Srvc', s);o.pl.mo.put('#Acc', a);o.pl.mo.put('#nC', emp);o.pl.mo.put('#nlnkC', emp);
            o.pl.mv.put('@vSanc', false);
            bRLs.exc(o.pl, rules, 1);

            //
            //bRLs.Parse('test', 'test');
        Test.stopTest();

    }
}