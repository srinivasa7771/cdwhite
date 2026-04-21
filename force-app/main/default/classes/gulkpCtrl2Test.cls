@isTest
private class gulkpCtrl2Test {
    static testmethod void method1() {
        Test.startTest();
        testData.init();
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        //s.uid__c = '208';
        //update s;
        User u = testData.createportalUser('guKpUsr');
        insert u;
        Contact C = [Select Id, Name, AccountId, Photo_ID__c from Contact where Id=:u.contactId];
        Account A = [Select id, on__c , onar__c , Website, vespe__c, vespex__c, vetemp__c,
            vbtemp__c , vetst__c, vespst__c, vespstx__c , vbtst__c, vev__c, mxPortalUsers__c,
            Name, Email__c, lPrk__c, Building_Name__c,
                     xcublg__c, Location__c, Location_Cluster__c, xcuzn__c , Phone, Type, Prk__c, adb__c,
                         info__c, bgnr__c, bg__c, bgc__c, bgcabsc__c, bgb__c, vctemp__c, speabsc__c, vctst__c,
                         sncNt__c, vbvv__c, lcidt1__c,
                     ec__c, ecidt__c, lctp__c, ecedt__c, lcedt__c, lcsnc__c, lcsncnt__c, Legal_Framework__c,
                         psasnc__c, psasncnt__c, lcsta__c, ecsnc__c, ecsncnt__c, lcrndt__c, cosnc__c, cosncnt__c,
                         licexdt__c, licIdt__c,
                     bgsnc__c, bgsncnt__c, snc__c, voep__c, lc__c, ORACLE_PARTY_ID__c, rpa__c, os__c, adob__c , adx__c, adc__c from Account where id=:C.AccountId ];
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        g_Req__c r=testData.reqCrt(A.Id, s.Id, C.Id, 'Open', srvcsettings[0].reqq__c);
        List<pbzn__c> pbz = new List<pbzn__c>();
        pbz.add(new pbzn__c(Name='Dubai Media City'));
        pbz.add(new pbzn__c(Name='Dubai Science Park'));
        insert pbz;

        List<pobox__c> pob = new List<pobox__c>();
        pob.add(new pobox__c(Name='test228', xpbz__c=[Select Id from pbzn__c where Name='Dubai Media City'].Id, sta__c='Booked'));
        pob.add(new pobox__c(Name='test229', xpbz__c=[Select Id from pbzn__c where Name='Dubai Media City'].Id, sta__c='Available'));
        pob.add(new pobox__c(Name='test230', xpbz__c=[Select Id from pbzn__c where Name='Dubai Media City'].Id, sta__c='Booked'));
        pob.add(new pobox__c(Name='test231', xpbz__c=[Select Id from pbzn__c where Name='Dubai Science Park'].Id, sta__c='Available'));
        insert pob;

        List<alocpob__c> apob = new List<alocpob__c>();
        apob.add(new alocpob__c(Name='test228', acc__c=A.Id, cncld__c=false,
            idt__c= date.parse('12/03/2020'), edt__c= date.parse('12/03/2021'),
            pob__c=[Select Id from pobox__c where Name='test228'].Id, stts__c='Active'));
        apob.add(new alocpob__c(Name='test229', acc__c=A.Id, cncld__c=false,
            idt__c= date.parse('12/03/2020'), edt__c= date.parse('12/03/2021'),
            pob__c=[Select Id from pobox__c where Name='test229'].Id, stts__c='Active'));
        apob.add(new alocpob__c(Name='test230', acc__c=A.Id, cncld__c=false,
            idt__c= date.parse('12/03/2020'), edt__c= date.parse('12/03/2021'),
            pob__c=[Select Id from pobox__c where Name='test230'].Id, stts__c='Active'));
        apob.add(new alocpob__c(Name='test231', acc__c=A.Id, cncld__c=false,
            idt__c= date.parse('12/03/2020'), edt__c= date.parse('12/03/2021'),
            pob__c=[Select Id from pobox__c where Name='test231'].Id, stts__c='Active'));
        insert apob;
        System.runAs(u) {
            testData.init();
            gulkpCtrl2 pa = new gulkpCtrl2();
            pa.prsn = 'portalcontact';
            pa.selected_POB=pa.selected_POB;
            pa.preloaded_POB=pa.preloaded_POB;
            pa.selectedZone=pa.selectedZone;
            pa.preloadedPOB=pa.preloadedPOB;
            pa.certFlag=pa.certFlag;
            pa.showAtt=pa.showAtt;
            pa.docName=pa.docName;
            pa.imageBase64=pa.imageBase64;
            pa.A=pa.A;
            pa.attacheDoc=pa.attacheDoc;
            pa.selectedCon=pa.selectedCon;
            pa.selectedSpn=pa.selectedSpn;
            pa.selectedJobTitle=pa.selectedJobTitle;
            pa.isSponsor=pa.isSponsor;
            pa.qObj=pa.qObj;
            pa.rq = r;
            pa.req = r;
            pa.U = u;
            pa.sid = s.Id;
            pa.ser = s;

            pa.cRole='Employee;Non Sponsored;Access Card;Trainee;Student;Housemaid;Spouse;Child';
            pa.init_con();
            pa.init_spn();
            pa.init();

            List<g_jb__c> jb = new List<g_jb__c>();
            jb.add(new g_jb__c(Name='Administartive Assistant', jtm__c='Administartive Assistant', cd__c='Q5GwDScPT7', moh__c='df123', jcm__c='34565', jtar__c='مدير حسابات'));
            jb.add(new g_jb__c(Name='Manager', jtm__c='MANAGER', cd__c='114455', moh__c='df1234', jcm__c='4019', jtar__c='مدير حسابات'));
            jb.add(new g_jb__c(Name='Data Entry Clerk', jtm__c='Data Entry Clerk', cd__c='as12df', moh__c='az23xs', jcm__c='1234', jtar__c='مشغل حاسب الى'));
            jb.add(new g_jb__c(Name='Actor', jtm__c='Actor', cd__c='as2df', moh__c='az2xs', jcm__c='6h45', jtar__c='مدير حسابات'));
            insert jb;
            pa.title = 'Manager';
            pa.searchJobTitles();
            Attachment att=new Attachment();
            att.Body=Blob.valueOf('strString');
            att.Name='Note_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
            att.parentId=r.id;
            insert att;
            gulkpCtrl2.doc pd = new gulkpCtrl2.doc('TestDocument', att.Id);
            pa.searchPOBoxes();
            pa.init_POB();
            pa.searchAllocatedPOBoxes();
            pa.init_allocatedPOB();
            pa.updateRequest();
            pa.saveDraft();
            pa.saveDraft1();
             pa.searchPersons();
        }
        Test.stopTest();
    }

}