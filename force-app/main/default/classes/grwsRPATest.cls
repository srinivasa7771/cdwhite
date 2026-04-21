@isTest
public class grwsRPATest {

    @isTest static void testGetRPA() {

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        //reqNum,srvcd,itmCd,expPriority;

        String str = '{"reqNum":"","srvcd":"001,002,003,004,021,078,040,020","itmCd":"md","expPriority":"1"}';
        req.requestURI = '/services/apexrest/getwsrpa/';
        req.httpMethod = 'GET';
        req.requestBody = Blob.valueof(str);
        RestContext.request = req;
        RestContext.response = res;


        testData.init();
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = new g_Srvc__c(Name = 'Srvc', lbl__c = 'Srvc', stg__c = stg.Id, uid__c = '001', actv__c = true, ckgsnc__c = true, Prk__c = 'Dubai Internet City', AccTp__c = 'Customer - External', ConRol__c = 'Employee', ConSTA__c = 'Active', payMd__c = 'Customer Deposit; Cash; Credit / Debit Card', Category__c = 'Employees Services', Sub_Category__c = 'Renewal Visa', Milestone_Stage__c = 'Ep;Medical;Rp;', Milestone_SLA__c = '10;2;6');
        insert s;

        list < g_srvcitm__c > itms = new list < g_srvcitm__c > ();
        itms.add(new g_srvcitm__c(srvc__c = s.Id, dSTA__c = 'n', ilv__c = 'ofl:ok;ofl:r;ofl:c;', slaN__c = 4, slaXP__c = 2, ord__c = 1, Tp__c = 'Service Item', cd__c = 'rp', Name = 'rp', lbl__c = 'rp', Req__c = true, aln__c = true, mxcnt__c = 1, rv__c = true, prcEdt__c = false, DscApp__c = true, EXP__c = true, KF__c = 0, scN__c = 10, cN__c = 5, smN__c = 1, spChN__c = 1, scXP__c = 1, cXP__c = 1, smXP__c = 1, spChXP__c = 1, xf__c = 'xf__c;xfid__c;xfed__c;xrp__c;xrpid__c;xrped__c;xui__c;xr__c;xcmbso__c;xcmbs__c;xcmao__c;xcma__c;xcmoao__c;xcmoa__c;xcmtao__c;xcmta__c;xef__c;'));
        itms.add(new g_srvcitm__c(srvc__c = s.Id, dSTA__c = 'n', ilv__c = 'ofl:ok;ofl:r;ofl:c;', slaN__c = 4, slaXP__c = 2, ord__c = 2, Tp__c = 'Service Item', cd__c = 'md', Name = 'md', lbl__c = 'md', Req__c = false, mxcnt__c = 1, rv__c = false, prcEdt__c = true, DscApp__c = false, EXP__c = false, KF__c = 0, scN__c = 10, cN__c = 5, smN__c = 1, spChN__c = 1, scXP__c = 1, cXP__c = 1, smXP__c = 1, spChXP__c = 1, xf__c = ''));
        insert itms;

        list < g_srvcitm_Status__c > sta = new list < g_srvcitm_Status__c > ();
        for (g_srvcitm__c i: itms) {
            sta.add(new g_srvcitm_Status__c(itm__c = i.Id, Milestone__c = 'EP', slaa__c = 'Standard', statype__c = 'Process', actv__c = true, slaN__c = 4, slaXP__c = 2, cd__c = 'n', name = 'n', lbl__c = 'n', Tp__c = 'Open', rqSTA__c = '', clm__c = false, clmA__c = 0, rfnd__c = false, rfndA__c = 0, Shift_At__c = 'Payment', Shift_Items__c = 'rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c = i.Id, Milestone__c = 'EP', slaa__c = 'Completed', statype__c = 'Process', actv__c = true, slaN__c = 4, slaXP__c = 2, cd__c = 'ook', name = 'ook', lbl__c = 'ook', Tp__c = 'Completed', rqSTA__c = '', clm__c = false, clmA__c = 0, rfnd__c = false, rfndA__c = 0, Shift_At__c = 'Payment', Shift_Items__c = 'rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c = i.Id, Milestone__c = 'Medical', slaa__c = 'Parallel', statype__c = 'Process', actv__c = true, slaN__c = 4, slaXP__c = 2, cd__c = 'c', name = 'c', lbl__c = 'c', Tp__c = 'Cancelled', rqSTA__c = 'Cancelled', clm__c = true, clmA__c = 1, rfnd__c = true, rfndA__c = 1, Shift_At__c = 'Payment', Shift_Items__c = 'rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c = i.Id, Milestone__c = 'RP', slaa__c = 'Standard', statype__c = 'Process', actv__c = true, slaN__c = 4, slaXP__c = 2, cd__c = 'ok', name = 'ok', lbl__c = 'ok', Tp__c = 'Completed', rqSTA__c = 'Completed', clm__c = false, clmA__c = 0, rfnd__c = false, rfndA__c = 0, Shift_At__c = 'Payment', Shift_Items__c = 'rp;md;'));
        }
        insert sta;


        Account a = testData.accCrt(false);
        Contact sp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp = testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c rq = testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);

        List < g_reqitem__c > itmLst = [Select id, name, ap__c From g_reqitem__c where rq__c =: rq.Id];
        System.debug('itmLst.size() : ' + itmLst.size());

        g_Tran__c T = new g_Tran__c(Acc__c = rq.Acc__c, RQ__c = rq.Id, TP__c = 'Payment');
        gctlReqpy.Trn trn = new gctlReqpy.Trn(T);
        trn.T = trn.T;

        Test.startTest();
        grwsRPA.getRpa();
        Test.stopTest();
    }

    @isTest static void testDoPost() {

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        //reqNum,srvcd,itmCd,expPriority;

        String str = '{"reqNum":"","srvcd":"001,002","itmCd":"rpmd","expPriority":""}';
        req.requestURI = '/services/apexrest/getwsrpa/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(str);
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        grwsRPA.doPost();
        Test.stopTest();

    }


}