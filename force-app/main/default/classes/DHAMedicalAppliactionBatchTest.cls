@isTest
private class DHAMedicalAppliactionBatchTest {

    static testMethod void testMedicalFitStatus() {
        testData.init();
        List < gStg__c > lstGStg = new List < gStg__c > ();
        lstGStg.add(new gStg__c(name = 'BH', Text_Value__c = '01m20000000BKEa'));
        lstGStg.add(new gStg__c(name = 'DHA_ENDPOINT', Text_Value__c = 'https://gsb.qa.dubai.gov.ae'));
        lstGStg.add(new gStg__c(name = 'DHA_FZ_ENDPOINT', Text_Value__c = 'https://gsb.qa.dubai.gov.ae'));
        lstGStg.add(new gStg__c(name = 'DHA_FZ_APIKEY', Text_Value__c = 'tset'));
        lstGStg.add(new gStg__c(name = 'gdhreg', Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name = 'gdhexp', Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name = 'gdhem', Text_Value__c = 'Exp'));
        lstGStg.add(new gStg__c(name = 'gdhsptp', Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name = 'gdhcntr', Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name = 'gdhpkg', Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name = 'gdhfzorg', Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name = 'DHA_USR', Text_Value__c = 'tst1'));
        lstGStg.add(new gStg__c(name = 'DHA_PASS', Text_Value__c = 'tst1'));
        lstGStg.add(new gStg__c(name = 'DHA_New_Enabled', Text_Value__c = 'tst2', Checkbox_Value__c = false));
        lstGStg.add(new gStg__c(name = 'DHA_FZ_APIKEY_New', Text_Value__c = 'tst3', Checkbox_Value__c = false));
        lstGStg.add(new gStg__c(name = 'DHA_ENDPOINT_New', Text_Value__c = 'tst4', Checkbox_Value__c = false));

        insert lstGStg;
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        List < g_srvcitm_Status__c > stsLst = [select id, cd__c, Next_Status__c from g_srvcitm_Status__c where itm__r.cd__c = 'md'
            and cd__c in ('n', 'fi')
        ];
        map < string, string > stsMp = new map < string, string > ();
        for (g_srvcitm_Status__c sts: stsLst)
            stsMp.put(sts.cd__c, sts.id);
        for (g_srvcitm_Status__c sts: stsLst) {
            if (sts.cd__c == 'n')
                sts.Next_Status__c = stsMp.get('fi');
        }
        update stsLst;
        Account a = testData.accCrt(false);
        Contact sp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp = testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r = testData.reqCrtOptItems(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c, 'md');
        List < g_reqitem__c > riItmLst = [select id, AD__c, name from g_reqitem__c where itm__r.cd__c = 'md'];
        system.debug('riItmLst' + riItmLst);
        g_reqitem__c ritm = new g_reqitem__c(id = riItmLst[0].Id, exp__c = true, dcXP__c = 0.00, dc__c = 0.00, Dsc__c = 0.00, KF__c = 0.00, scXP__c = 0.00, scN__c = 0.00, cXP__c = 0.00, cN__c = 0.00, smXP__c = 0.00, smN__c = 0.00, su__c = 0.00, vec__c = 0.00, vesch__c = 0.00, vsc__c = 0.00, vst__c = 0.00);
        update ritm;
        system.debug('ritm----->' + ritm);
        List < g_reqitem__c > riItmLst2 = [select id, AD__c, exp__c, name from g_reqitem__c where id =: ritm.Id];
        system.debug('riItmLst2' + riItmLst2);
        List < ws_call__c > wsList = new List < ws_call__c > ();
        ws_call__c wc = new ws_call__c();
        wc.rq_itm__c = ritm.id;
        wc.ws_typ__c = 'DHA Medical1';
        wc.mtd_nm__c = 'createApplication';
        wc.sdt__c = system.now();
        wc.intsts__c = 'Ready for Integration';
        wsList.add(wc);
        Insert wsList;
        List < ws_call__c > wsListUpdate = [select id, intsts__c, rq_itm__r.exp__c from ws_call__c WHERE ws_typ__c In('DHA Medical1')];
        for (ws_call__c wsupdate: wsListUpdate) {
            wsupdate.intsts__c = 'Ready for Integration';
            wsupdate.ws_typ__c = 'DHA Medical';
        }
        update wsListUpdate;
        system.debug('wsListUpdate-->' + wsListUpdate);
        Test.startTest();
        Test.setMock(WebServiceMock.class, new DHAMedicalAppliactionMockImpl());

        Test.setMock(HttpCalloutMock.class, new mockGetResp());
        DHAMedicalAppliactionBatch obj = new DHAMedicalAppliactionBatch();
        obj.convertDoc('12345');

        Database.executeBatch(obj);
        obj.upgradePackage('12345');

        Test.stopTest();
    }
    static testMethod void testMedicalFitStatus1() {
        testData.init();
        List < gStg__c > lstGStg = new List < gStg__c > ();
        lstGStg.add(new gStg__c(name = 'BH', Text_Value__c = '01m20000000BKEa'));
        lstGStg.add(new gStg__c(name = 'DHA_ENDPOINT', Text_Value__c = 'https://gsb.qa.dubai.gov.ae'));
        lstGStg.add(new gStg__c(name = 'DHA_FZ_ENDPOINT', Text_Value__c = 'https://gsb.qa.dubai.gov.ae'));
        lstGStg.add(new gStg__c(name = 'DHA_FZ_APIKEY', Text_Value__c = 'tset'));
        lstGStg.add(new gStg__c(name = 'gdhreg', Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name = 'gdhexp', Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name = 'gdhem', Text_Value__c = 'Exp'));
        lstGStg.add(new gStg__c(name = 'gdhsptp', Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name = 'gdhcntr', Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name = 'gdhpkg', Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name = 'gdhfzorg', Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name = 'DHA_USR', Text_Value__c = 'tst1'));
        lstGStg.add(new gStg__c(name = 'DHA_PASS', Text_Value__c = 'tst1'));
        lstGStg.add(new gStg__c(name = 'DHA_New_Enabled', Text_Value__c = 'tst2', Checkbox_Value__c = false));
        lstGStg.add(new gStg__c(name = 'DHA_FZ_APIKEY_New', Text_Value__c = 'tst3', Checkbox_Value__c = false));
        lstGStg.add(new gStg__c(name = 'DHA_ENDPOINT_New', Text_Value__c = 'tst4', Checkbox_Value__c = false));
        insert lstGStg;
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        List < g_srvcitm_Status__c > stsLst = [select id, cd__c, Next_Status__c from g_srvcitm_Status__c where itm__r.cd__c = 'md'
            and cd__c in ('n', 'fi')
        ];
        map < string, string > stsMp = new map < string, string > ();
        for (g_srvcitm_Status__c sts: stsLst)
            stsMp.put(sts.cd__c, sts.id);
        for (g_srvcitm_Status__c sts: stsLst) {
            if (sts.cd__c == 'n')
                sts.Next_Status__c = stsMp.get('fi');
        }
        update stsLst;
        Account a = testData.accCrt(false);
        Contact sp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp = testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r = testData.reqCrtOptItems(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c, 'md');
        List < g_reqitem__c > riItmLst = [select id, AD__c, name from g_reqitem__c where itm__r.cd__c = 'md'];
        system.debug('riItmLst' + riItmLst);
        g_reqitem__c ritm = new g_reqitem__c(id = riItmLst[0].Id, exp__c = true, dcXP__c = 0.00, dc__c = 0.00, Dsc__c = 0.00, KF__c = 0.00, scXP__c = 0.00, scN__c = 0.00, cXP__c = 0.00, cN__c = 0.00, smXP__c = 0.00, smN__c = 0.00, su__c = 0.00, vec__c = 0.00, vesch__c = 0.00, vsc__c = 0.00, vst__c = 0.00);
        update ritm;
        system.debug('ritm----->' + ritm);
        List < g_reqitem__c > riItmLst2 = [select id, AD__c, exp__c, name from g_reqitem__c where id =: ritm.Id];
        system.debug('riItmLst2' + riItmLst2);
        List < ws_call__c > wsList = new List < ws_call__c > ();
        ws_call__c wc = new ws_call__c();
        wc.rq_itm__c = ritm.id;
        wc.ws_typ__c = 'DHA Medical1';
        wc.mtd_nm__c = 'upgradeApplication';
        wc.sdt__c = system.now();
        wc.intsts__c = 'Ready for Integration';
        wsList.add(wc);
        Insert wsList;
        List < ws_call__c > wsListUpdate = [select id, intsts__c, rq_itm__r.exp__c from ws_call__c WHERE ws_typ__c In('DHA Medical1')];
        for (ws_call__c wsupdate: wsListUpdate) {
            wsupdate.intsts__c = 'Ready for Integration';
            wsupdate.ws_typ__c = 'DHA Medical';
            wc.mtd_nm__c = 'upgradeApplication';
        }
        update wsListUpdate;
        system.debug('wsListUpdate-->' + wsListUpdate);
        Test.startTest();
        Test.setMock(WebServiceMock.class, new DHAMedicalAppliactionMockImpl());

        Test.setMock(HttpCalloutMock.class, new mockGetResp());
        DHAMedicalAppliactionBatch obj = new DHAMedicalAppliactionBatch();
        obj.convertDoc('12345');

        Database.executeBatch(obj);
        obj.upgradePackage('12345');

        Test.stopTest();
    }
    /*static testMethod void testMedicalUpdateStatus() {
         
        	testData.init();
        List<gStg__c> lstGStg = new List<gStg__c>();
        lstGStg.add(new gStg__c(name='BH',Text_Value__c = '01m20000000BKEa'));
          lstGStg.add(new gStg__c(name='DHA_ENDPOINT',Text_Value__c = 'https://gsb.qa.dubai.gov.ae'));
        lstGStg.add(new gStg__c(name='gdhreg',Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name='gdhexp',Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name='gdhem',Text_Value__c = 'Exp'));
        lstGStg.add(new gStg__c(name='gdhsptp',Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name='gdhcntr',Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name='gdhpkg',Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name='gdhfzorg',Text_Value__c = 'Regular'));
        lstGStg.add(new gStg__c(name='DHA_USR',Text_Value__c = 'tst1'));
        lstGStg.add(new gStg__c(name='DHA_PASS',Text_Value__c = 'tst1'));
        insert lstGStg;
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
        List<g_srvcitm_Status__c> stsLst = [select id,cd__c,Next_Status__c from g_srvcitm_Status__c where itm__r.cd__c ='md' and cd__c in ('n','fi')];
          map<string,string> stsMp = new map<string,string>();
          for(g_srvcitm_Status__c sts : stsLst)
           stsMp.put(sts.cd__c,sts.id);  
         for(g_srvcitm_Status__c sts : stsLst){
          if(sts.cd__c == 'n')
              sts.Next_Status__c = stsMp.get('fi');
           }
          update stsLst;
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
            Contact emp=testData.conCrt(sp,a.Id,'Active','Employee','Pass2','Egypt');
            g_Req__c r=testData.reqCrtOptItems(a.Id,s.Id,emp.Id,'Open',stg.reqq__c,'md');
        List<g_reqitem__c> riItmLst = [select id,name from g_reqitem__c where itm__r.cd__c = 'md'];
            ws_call__c wc = new ws_call__c();
                wc.rq_itm__c =riItmLst[0].id;
                wc.ws_typ__c = 'DHA Medical';
                wc.mtd_nm__c = 'upgradeApplication';
                wc.sdt__c = date.today();
				wc.intsts__c = 'Ready for Integration';
            insert wc;     
        Test.startTest();
          Test.setMock(WebServiceMock.class, new DHAMedicalAppliactionMockImpl());
            DHAMedicalAppliactionBatch obj = new DHAMedicalAppliactionBatch();
            Database.executeBatch(obj);
         Test.stopTest();
    }
    */
    public class DHAMedicalAppliactionMockImpl implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map < String, Object > response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
            if (requestName == 'UpgradePackageRequest') {
                AXSDHA.UpgradePackageRequest_element req = (AXSDHA.UpgradePackageRequest_element) request;
                string appNo = (string) req.ApplicationName;

                AXSDHA.UpgradePackageResponse_element response_x = new AXSDHA.UpgradePackageResponse_element();
                if (appNo == '12345')
                    response_x.ResponseCode = '00';
                else
                    response_x.ResponseCode = '01';
                response.put('response_x', response_x);
            } else {
                AXSNewDHA.createApplicationResponse_element res = new AXSNewDHA.createApplicationResponse_element();
                res.applicationName = '12345';
                response.put('response_x', res);
            }
        }
    }
    public class mockGetResp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Files":[{"FileData":"tststst"}]}');
            res.setStatusCode(200);

            return res;
        }
    }
}