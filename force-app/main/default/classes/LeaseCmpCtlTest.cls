@isTest
private class LeaseCmpCtlTest {
    static testmethod void method1() {


        Test.startTest();
        testData.init();
        testData.bRulesReqCrt();
        testData.bRulesItemCrt();
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        update s;
        User u = testData.createportalUser('pnActUsr');
        insert u;
        Contact C = [Select Id, Name, AccountId, Photo_ID__c from Contact where Id =: u.contactId];
        Account A = [Select id, on__c, onar__c, Website, vespe__c, vespex__c, vetemp__c, vbtemp__c, vetst__c, vespst__c, vespstx__c, vbtst__c, vev__c, mxPortalUsers__c, Name, Email__c, lPrk__c, Building_Name__c,
            xcublg__c, Location__c, Location_Cluster__c, xcuzn__c, Phone, Type, Prk__c, adb__c, info__c, bgnr__c, bg__c, bgc__c, bgcabsc__c, bgb__c, vctemp__c, speabsc__c, vctst__c, sncNt__c, vbvv__c, lcidt1__c,
            ec__c, ecidt__c, lctp__c, ecedt__c, lcedt__c, lcsnc__c, lcsncnt__c, Legal_Framework__c, psasnc__c, psasncnt__c, lcsta__c, ecsnc__c, ecsncnt__c, lcrndt__c, cosnc__c, cosncnt__c, licexdt__c, licIdt__c,
            bgsnc__c, bgsncnt__c, snc__c, voep__c, lc__c, ORACLE_PARTY_ID__c, rpa__c, os__c, adob__c, adx__c, adc__c from Account where id =: C.AccountId
        ];
        //u.AccountId = A.id;
        //update u;
        List < g_srvc_settings__c > srvcsettings = [select id, reqq__c from g_srvc_settings__c where Name = 'srvcStg'
            LIMIT 1
        ];
        g_Req__c r = testData.reqCrt(A.Id, s.Id, C.Id, 'Open', srvcsettings[0].reqq__c);
        system.Debug('request r' + r);
        System.runAs(u) {
            LeaseCmpCtl lcc = new LeaseCmpCtl();
            lcc.A = A;
            lcc.U = u;
            LeaseCmpCtl.SegActivity seg = new LeaseCmpCtl.SegActivity();
            seg.name = 'Test nm';
            LeaseCmpCtl.segmentWraper sw = new LeaseCmpCtl.segmentWraper();
            sw.name = 'Test acc';
            sw.price = '25000';
            List < LeaseCmpCtl.segmentWraper > lst = new List < LeaseCmpCtl.segmentWraper > ();
            lst.add(sw);
            LeaseCmpCtl.UnitInfo uinfo = new LeaseCmpCtl.UnitInfo();
            uinfo.LineItemName = 'tst';
            lcc.segments = lst;
            lcc.calculateDueAmt();
            lcc.addSegment();
            lcc.addSegment4mRQ();
            lcc.editFromLeaseCmp();
            lcc.formationUpdate();
            lcc.getPick1();
            lcc.getPick2();
            lcc.setSegJson('tst');
            lcc.setRq(r);
            string js = lcc.getSegJson();
            LeaseCmpCtl lcc1 = new LeaseCmpCtl('tst');
            lcc.mapAct = new Map < String, String > ();
        }
        Test.stopTest();

    }

}