@IsTest
public class grtFuStaUpdateTest {

     @testSetup static void setup() {
        testData.init();
        g_srvc_settings__c stg=testData.stgCrt();

        List<g_Srvc__c> lstSrvc = new List<g_Srvc__c>();
        g_Srvc__c s = new g_Srvc__c(Name='Srvc', lbl__c='Srvc', stg__c=stg.Id, uid__c='208',
            actv__c=true, ckgsnc__c=true, Prk__c='Dubai Internet City', AccTp__c='Customer - External',
            ConRol__c='Employee', ConSTA__c='Active', payMd__c='Customer Deposit; Cash; Credit / Debit Card',
            Category__c='Employees Services', Sub_Category__c='Renewal Visa', Milestone_Stage__c='Ep;Medical;Rp;',
            Milestone_SLA__c='10;2;6');
        lstSrvc.add(s);
        insert lstSrvc;

        list<g_srvcitm__c> itms = new list<g_srvcitm__c>();
        itms.add(new g_srvcitm__c(srvc__c=lstSrvc[0].Id, dSTA__c='n',
            slaN__c=4, slaXP__c=2, ord__c=1, Tp__c='Service Item', cd__c='0np',
            dcr__c ='Approval from DM:Approval from DM;Catering Service Agreement:Catering Service Agreement;NOC from LandLord:NOC from LandLord;Service Provider License Copy:Service Provider License Copy;Signed Catering Permit Guidelines:Signed Catering Permit Guidelines;',
            Name='rp', lbl__c='rp', Req__c=true, aln__c=true, mxcnt__c=1,
            rv__c=true, prcEdt__c=false, DscApp__c=true, EXP__c=true, KF__c=0,
            scN__c=10, cN__c=5, smN__c=1, spChN__c=1, scXP__c=1, cXP__c=1,
            smXP__c=1, spChXP__c=1, xf__c='xf__c;xfid__c;xfed__c;xrp__c;xrpid__c;xrped__c;xui__c;xr__c;xcmbso__c;xcmbs__c;xcmao__c;xcma__c;xcmoao__c;xcmoa__c;xcmtao__c;xcmta__c;xef__c;'));
       insert itms;
        list<g_srvcitm_Status__c> sta = new list<g_srvcitm_Status__c>();
        for (g_srvcitm__c i:itms) {
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='EP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='n', name='n', lbl__c='n', Tp__c='Open', rqSTA__c='',
                clm__c=false, clmA__c=0, rfnd__c=false, rfndA__c=0, Shift_At__c='Payment',
                Shift_Items__c='rp;md;', exsyst__c='dcca:Closed;'));
            }
        insert sta;

        Account a=testData.accCrt(false);
        a.ORACLE_PARTY_ID__c = 'T-1234';  a.lc__c='009999';
        update a;

       Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');

        g_Req__c rq=testData.reqCrt(a.Id, lstSrvc[0].Id, emp.Id, 'Open', stg.reqq__c);
        rq.rtacn__c = '1234';rq.xoln__c='055372654'; rq.rmob__c='0512341234';
        update rq;

        list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, rq__c, RQ__r.Id from g_reqitem__c];
        g_Tran__c t = new g_Tran__c();
        t.Acc__c =a.id;
        t.md__c ='cash';
        t.TP__c ='Payment';
        t.STA__c='Completed';
        t.RQ__c = rqItm[0].RQ__r.id;
        insert t;
    }

    static testMethod void testdoPost() {

      List<g_Tran__c> tRef =  [select id, name from g_Tran__c];
       String reqbody ='{ "Method": "Value1", "data": { "ReceiptNumber": "'+
           tRef[0].name+'", "ReceiptStatus": "Value4", "ReversalCategory": "Value4", "ReversalReason": "Value4", "ReversalComment": "Value4", "TransactionNumber": "Value4", "CustomerTransactionId": "Value4", "Status": "Value4", "ErrorMessage": "Value4" }  }';
        String restURL = '/services/apexrest/FuStaUpdate/';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = restURL;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(reqbody);
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        grtFuStaUpdate.doPost();
        Test.stopTest();

}
}