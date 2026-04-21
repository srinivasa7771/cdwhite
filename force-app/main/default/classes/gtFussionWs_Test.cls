@isTest
public class gtFussionWs_Test {
    @testSetup static void setup() {
        testData.init();
        g_srvc_settings__c stg = testData.stgCrt();

        List < g_Srvc__c > lstSrvc = new List < g_Srvc__c > ();
        g_Srvc__c s = new g_Srvc__c(Name = 'Srvc', lbl__c = 'Srvc', stg__c = stg.Id, uid__c = '208', actv__c = true, ckgsnc__c = true, Prk__c = 'Dubai Internet City', AccTp__c = 'Customer - External', ConRol__c = 'Employee', ConSTA__c = 'Active', payMd__c = 'Customer Deposit; Cash; Credit / Debit Card', Category__c = 'Employees Services', Sub_Category__c = 'Renewal Visa', Milestone_Stage__c = 'Ep;Medical;Rp;', Milestone_SLA__c = '10;2;6');
        lstSrvc.add(s);

        g_Srvc__c s1 = new g_Srvc__c(Name = 'Srvc', lbl__c = 'Srvc', stg__c = stg.Id, uid__c = '156', actv__c = true, ckgsnc__c = true, Prk__c = 'Dubai Internet City', AccTp__c = 'Customer - External', ConRol__c = 'Employee', ConSTA__c = 'Active', payMd__c = 'Customer Deposit; Cash; Credit / Debit Card', Category__c = 'Employees Services', Sub_Category__c = 'Renewal Visa', Milestone_Stage__c = 'Ep;Medical;Rp;', Milestone_SLA__c = '10;2;6');
        lstSrvc.add(s1);

        g_Srvc__c s2 = new g_Srvc__c(Name = 'Srvc', lbl__c = 'Srvc', stg__c = stg.Id, uid__c = '216', actv__c = true, ckgsnc__c = true, Prk__c = 'Dubai Internet City', AccTp__c = 'Customer - External', ConRol__c = 'Employee', ConSTA__c = 'Active', payMd__c = 'Customer Deposit; Cash; Credit / Debit Card', Category__c = 'Employees Services', Sub_Category__c = 'Renewal Visa', Milestone_Stage__c = 'Ep;Medical;Rp;', Milestone_SLA__c = '10;2;6');
        lstSrvc.add(s2);
        insert lstSrvc;

        list < g_srvcitm__c > itms = new list < g_srvcitm__c > ();
        itms.add(new g_srvcitm__c(srvc__c = lstSrvc[0].Id, dSTA__c = 'n', slaN__c = 4, slaXP__c = 2, ord__c = 1, Tp__c = 'Service Item', cd__c = '0np', dcr__c = 'Approval from DM:Approval from DM;Catering Service Agreement:Catering Service Agreement;NOC from LandLord:NOC from LandLord;Service Provider License Copy:Service Provider License Copy;Signed Catering Permit Guidelines:Signed Catering Permit Guidelines;', Name = 'rp', lbl__c = 'rp', Req__c = true, aln__c = true, mxcnt__c = 1, rv__c = true, prcEdt__c = false, DscApp__c = true, EXP__c = true, KF__c = 0, scN__c = 10, cN__c = 5, smN__c = 1, spChN__c = 1, scXP__c = 1, cXP__c = 1, smXP__c = 1, spChXP__c = 1, xf__c = 'xf__c;xfid__c;xfed__c;xrp__c;xrpid__c;xrped__c;xui__c;xr__c;xcmbso__c;xcmbs__c;xcmao__c;xcma__c;xcmoao__c;xcmoa__c;xcmtao__c;xcmta__c;xef__c;'));
        itms.add(new g_srvcitm__c(srvc__c = lstSrvc[0].Id, dSTA__c = 'n', slaN__c = 4, slaXP__c = 2, ord__c = 2, Tp__c = 'Service Item', cd__c = 'pnt', Name = 'pnt', lbl__c = 'pnt', Req__c = false, mxcnt__c = 1, rv__c = false, prcEdt__c = true, DscApp__c = false, EXP__c = false, KF__c = 0, scN__c = 10, cN__c = 5, smN__c = 1, spChN__c = 1, scXP__c = 1, cXP__c = 1, smXP__c = 1, spChXP__c = 1, xf__c = ''));
        itms.add(new g_srvcitm__c(srvc__c = lstSrvc[1].Id, dSTA__c = 'n', slaN__c = 4, slaXP__c = 2, ord__c = 1, Tp__c = 'Service Item', cd__c = '0np', dcr__c = 'Approval from DM:Approval from DM;Catering Service Agreement:Catering Service Agreement;NOC from LandLord:NOC from LandLord;Service Provider License Copy:Service Provider License Copy;Signed Catering Permit Guidelines:Signed Catering Permit Guidelines;', Name = 'rp', lbl__c = 'rp', Req__c = true, aln__c = true, mxcnt__c = 1, rv__c = true, prcEdt__c = false, DscApp__c = true, EXP__c = true, KF__c = 0, scN__c = 10, cN__c = 5, smN__c = 1, spChN__c = 1, scXP__c = 1, cXP__c = 1, smXP__c = 1, spChXP__c = 1, xf__c = 'xf__c;xfid__c;xfed__c;xrp__c;xrpid__c;xrped__c;xui__c;xr__c;xcmbso__c;xcmbs__c;xcmao__c;xcma__c;xcmoao__c;xcmoa__c;xcmtao__c;xcmta__c;xef__c;'));
        itms.add(new g_srvcitm__c(srvc__c = lstSrvc[2].Id, dSTA__c = 'n', slaN__c = 4, slaXP__c = 2, ord__c = 2, Tp__c = 'Service Item', cd__c = 'pnt', Name = 'pnt', lbl__c = 'pnt', Req__c = false, mxcnt__c = 1, rv__c = false, prcEdt__c = true, DscApp__c = false, EXP__c = false, KF__c = 0, scN__c = 10, cN__c = 5, smN__c = 1, spChN__c = 1, scXP__c = 1, cXP__c = 1, smXP__c = 1, spChXP__c = 1, xf__c = ''));
        insert itms;




        list < g_srvcitm_Status__c > sta = new list < g_srvcitm_Status__c > ();
        for (g_srvcitm__c i: itms) {
            sta.add(new g_srvcitm_Status__c(itm__c = i.Id, Milestone__c = 'EP', slaa__c = 'Standard', statype__c = 'Process', actv__c = true, slaN__c = 4, slaXP__c = 2, cd__c = 'n', name = 'n', lbl__c = 'n', Tp__c = 'Open', rqSTA__c = '', clm__c = false, clmA__c = 0, rfnd__c = false, rfndA__c = 0, Shift_At__c = 'Payment', Shift_Items__c = 'rp;md;', exsyst__c = 'dcca:Closed;'));
            sta.add(new g_srvcitm_Status__c(itm__c = i.Id, Milestone__c = 'EP', slaa__c = 'Completed', statype__c = 'Process', actv__c = true, slaN__c = 4, slaXP__c = 2, cd__c = 'ook', name = 'ook', lbl__c = 'ook', Tp__c = 'Completed', rqSTA__c = '', clm__c = false, clmA__c = 0, rfnd__c = false, rfndA__c = 0, Shift_At__c = 'Payment', Shift_Items__c = 'rp;md;', exsyst__c = 'dcca:Closed;'));
            sta.add(new g_srvcitm_Status__c(itm__c = i.Id, Milestone__c = 'Medical', slaa__c = 'Parallel', statype__c = 'Process', actv__c = true, slaN__c = 4, slaXP__c = 2, cd__c = 'c', name = 'c', lbl__c = 'c', Tp__c = 'Cancelled', rqSTA__c = 'Cancelled', clm__c = true, clmA__c = 1, rfnd__c = true, rfndA__c = 1, Shift_At__c = 'Payment', Shift_Items__c = 'rp;md;', exsyst__c = 'dcca:Closed;'));
            sta.add(new g_srvcitm_Status__c(itm__c = i.Id, Milestone__c = 'RP', slaa__c = 'Standard', statype__c = 'Process', actv__c = true, slaN__c = 4, slaXP__c = 2, cd__c = 'ok', name = 'ok', lbl__c = 'ok', Tp__c = 'Completed', rqSTA__c = 'Completed', clm__c = false, clmA__c = 0, rfnd__c = false, rfndA__c = 0, Shift_At__c = 'Payment', Shift_Items__c = 'rp;md;', exsyst__c = 'dcca:Closed;'));
        }
        insert sta;

        Account a = testData.accCrt(false);
        a.ORACLE_PARTY_ID__c = '1234';
        a.lc__c = '999999';
        update a;

        Contact sp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp = testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');

        g_Req__c rq = testData.reqCrt(a.Id, lstSrvc[0].Id, emp.Id, 'Open', stg.reqq__c);
        rq.rtacn__c = '1234';
        rq.xoln__c = '055372654';
        rq.rmob__c = '0512341234';
        // rq.xceml__c='a@b.com'; rq.xintp__c = 'SILVER'; rq.xcp__c = 'P98989876';
        update rq;

        g_Req__c rq1 = testData.reqCrt(a.Id, lstSrvc[1].Id, emp.Id, 'Open', stg.reqq__c);
        rq1.rtacn__c = '1234';
        rq1.xoln__c = '055372654';
        rq1.rmob__c = '0512341234';
        // rq.xceml__c='a@b.com'; rq.xintp__c = 'SILVER'; rq.xcp__c = 'P98989876';
        update rq1;

        g_Req__c rq2 = testData.reqCrt(a.Id, lstSrvc[2].Id, emp.Id, 'Open', stg.reqq__c);
        rq2.rtacn__c = '1234';
        rq2.xoln__c = '055372654';
        rq2.rmob__c = '0512341234';
        // rq.xceml__c='a@b.com'; rq.xintp__c = 'SILVER'; rq.xcp__c = 'P98989876';
        update rq2;

        list < g_reqitem__c > rqItm = [Select id, xdcca_refId__c, rq__c, RQ__r.Id from g_reqitem__c];
        g_Tran__c t = new g_Tran__c();
        t.Acc__c = a.id;
        t.md__c = 'cash';
        t.TP__c = 'Payment';
        t.STA__c = 'Completed';
        t.RQ__c = rqItm[0].RQ__r.id;
        insert t;

        g_Tran__c t1 = new g_Tran__c();
        t1.Acc__c = a.id;
        t1.md__c = 'cash';
        t1.TP__c = 'Payment';
        t1.STA__c = 'Completed';
        t1.RQ__c = rqItm[1].RQ__r.id;
        insert t1;

        g_Tran__c t2 = new g_Tran__c();
        t2.Acc__c = a.id;
        t2.md__c = 'cash';
        t2.TP__c = 'PAYMENT';
        t2.STA__c = 'Completed';
        t2.RQ__c = rqItm[2].RQ__r.id;
        insert t2;

        g_Tran__c t3 = new g_Tran__c();
        t3.Acc__c = a.id;
        t3.md__c = 'cash';
        t3.TP__c = 'Refund';
        t3.STA__c = 'Completed';
        t3.RQ__c = rqItm[2].RQ__r.id;
        insert t3;

        List < ORAMETA__c > ormList = new List < ORAMETA__c > ();
        ORAMETA__c orm = new ORAMETA__c();
        orm.TYPE__c = 'PAYMENT';
        //orm.SERVICE_TYPE__c = 'AXS';
        orm.BRAND__c = 'AXS';
        orm.PAYMENT_METHOD__c = 'CASH';
        ormList.add(orm);

        ORAMETA__c orm1 = new ORAMETA__c();
        orm1.TYPE__c = 'SERVICE';
        orm1.SERVICE_TYPE__c = 'AXS';
        orm1.BRAND__c = 'AXS';
        orm1.PAYMENT_METHOD__c = 'CASH';
        ormList.add(orm1);

        ORAMETA__c orm2 = new ORAMETA__c();
        orm2.TYPE__c = 'DEBIT MEMO';
        orm2.SERVICE_TYPE__c = 'DEBIT_MEMO';
        orm2.BRAND__c = 'AXS';
        orm2.PAYMENT_METHOD__c = 'CUSTOMER DEPOSIT';
        ormList.add(orm2);

        ORAMETA__c orm3 = new ORAMETA__c();
        orm3.TYPE__c = 'DEBIT MEMO';
        orm3.SERVICE_TYPE__c = 'CDTOBG';
        orm3.BRAND__c = 'AXS';
        orm3.PAYMENT_METHOD__c = 'CUSTOMER DEPOSIT';
        ormList.add(orm3);

        ORAMETA__c orm4 = new ORAMETA__c();
        orm4.TYPE__c = 'DEBIT MEMO';
        orm4.SERVICE_TYPE__c = 'BGTOCD';
        orm4.BRAND__c = 'AXS';
        orm4.PAYMENT_METHOD__c = 'CUSTOMER DEPOSIT';
        ormList.add(orm4);

        ORAMETA__c orm5 = new ORAMETA__c();
        orm5.TYPE__c = 'CREDIT MEMO';
        orm5.SERVICE_TYPE__c = 'CREDIT_MEMO';
        orm5.BRAND__c = 'AXS';
        orm5.PAYMENT_METHOD__c = 'CASH';
        ormList.add(orm5);

        ORAMETA__c orm6 = new ORAMETA__c();
        orm6.TYPE__c = 'SERVICE';
        orm6.SERVICE_TYPE__c = 'PMS';
        orm6.BRAND__c = 'DIC';
        orm6.PAYMENT_METHOD__c = 'CASH';
        ormList.add(orm6);

        ORAMETA__c orm7 = new ORAMETA__c();
        orm7.TYPE__c = 'SERVICE';
        orm7.SERVICE_TYPE__c = 'PARKING';
        orm7.BRAND__c = 'DIC';
        orm7.PAYMENT_METHOD__c = 'CASH';
        ormList.add(orm7);

        insert ormList;

    }

    static testmethod void meth1() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c limit 1];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();
        gtFussionWs.createInvoiceFu(tRef[0].id);
        Test.stopTest();
    }
    static testmethod void meth11() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c where RQ__r.srvc__r.uid__c != '208'
            limit 1
        ];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();
        gtFussionWs.createInvoiceFu(tRef[0].id);
        Test.stopTest();
    }
    static testmethod void meth12() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c where TP__c = 'Refund'
            limit 1
        ];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();
        gtFussionWs.createInvoiceFu(tRef[0].id);
        gtFussionWs.CMDMApplicationDmyRecpFu(tRef[0].id);

        Test.stopTest();
    }
    static testmethod void meth2() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c limit 1];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();
        gtFussionWs.createReceiptFu(tRef[0].id);
        Test.stopTest();
    }
    static testmethod void meth3() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c limit 1];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();
        gtFussionWs.createReceiptInvFu(tRef[0].id);
        Test.stopTest();
    }
    static testmethod void meth31() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c where RQ__r.srvc__r.uid__c != '208'
            limit 1
        ];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();
        gtFussionWs.createReceiptInvFu(tRef[0].id);
        Test.stopTest();
    }
    static testmethod void meth4() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c limit 1];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();
        gtFussionWs.createCreditMemoFu(tRef[0].id);
        Test.stopTest();
    }
    static testmethod void meth5() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c limit 1];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();
        gtFussionWs.createDebitMemoFu(tRef[0].id);
        Test.stopTest();
    }
    static testmethod void meth6() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c limit 1];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();
        gtFussionWs.CMDMApplicationFu(tRef[0].id);
        Test.stopTest();
    }
    static testmethod void meth16() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c limit 1];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();
        gtFussionWs.createInvoiceFu(tRef[0].id, 'AXS');
        gtFussionWs.createInvoiceFu(tRef[0].id, 'BU');
        Test.stopTest();
    }
    static testmethod void meth17() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c limit 1];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();
        gtFussionWs.createDMDRFu(tRef[0].id);
        Test.stopTest();
    }
    static testmethod void meth18() {


        ws_call__c ws = new ws_call__c();
        ws.ws_typ__c = 'CreateBankFu';
        ws.mtd_nm__c = 'BankAccUpdate';
        ws.intsts__c = 'Ready for Integration';
        insert ws;
        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c limit 1];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();

        gtFussionWs.voidCreateRefundAtt('', tRef[0].id, ws.id);


        Test.stopTest();
    }
    static testmethod void meth182() {

        Account acc = new Account(Name = 'Test Account', adrfi__c = 200);
        insert acc;
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        Contact sp = testData.conCrt(null, acc.Id, 'Active', 'Employee', 'Pass1442', 'Egypt');
        Contact emp = testData.conCrt(sp, acc.Id, 'Active', 'Employee', 'Pass21112', 'Egypt');
        g_Req__c r = testData.reqCrt(acc.Id, s.Id, emp.Id, 'Open', stg.reqq__c);


        // Create g_Tran__c
        g_Tran__c tran = new g_Tran__c(Acc__c = acc.Id, RQ__c = r.id);
        insert tran;

        g_srvcitm__c gsitem = new g_srvcitm__c(Name = 'itemtest', cd__c = 'mi', lbl__c = 'itemntest', ord__c = 2, dSTA__c = 'n', srvc__c = s.Id, Tp__c = 'Service Item');
        insert gsitem;
        g_srvcitm_Status__c status = new g_srvcitm_Status__c(Name = 'statustest', cd__c = 'ok', lbl__c = 'Pending Approval', Tp__c = 'Open', itm__c = gsitem.Id);
        insert status;
        // Create g_reqitem__c
        grqH.rAfter = false;
        grqH.rBefore = false;
        grqH.iBefore = false;
        grqH.iAfter = false;
        g_reqitem__c reqItem = new g_reqitem__c(
            itm__c = gsitem.id,
            RQ__c = r.id,
            xrramt__c = 100,
            xramt__c = 200,
            sta__c = status.Id,
            xtrf__c = 'Customer Deposit',
            name = 'Request Item'
        );
        insert reqItem;

        // Create ws_call__c
        ws_call__c ws = new ws_call__c(rq_itm__c = reqItem.Id, intsts__c = 'Ready for Integration', ws_typ__c = 'CreateBankFu', mtd_nm__c = 'BankAccUpdate');
        insert ws;



        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c limit 1];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();

        gtFussionWs.voidCreateRefundHisAtt('', r.id, tran.id);

        Test.stopTest();
    }
    static testmethod void meth181() {

        Account acc = new Account(Name = 'Test Account', adrfi__c = 200);
        insert acc;
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        Contact sp = testData.conCrt(null, acc.Id, 'Active', 'Employee', 'Pass14412', 'Egypt');
        Contact emp = testData.conCrt(sp, acc.Id, 'Active', 'Employee', 'Pass211112', 'Egypt');
        g_Req__c r = testData.reqCrt(acc.Id, s.Id, emp.Id, 'Open', stg.reqq__c);

        // Create g_Tran__c
        g_Tran__c tran = new g_Tran__c(Acc__c = acc.Id, RQ__c = r.id);
        insert tran;

        g_srvcitm__c gsitem = new g_srvcitm__c(Name = 'itemtest', cd__c = 'mi', lbl__c = 'itemntest', ord__c = 2, dSTA__c = 'n', srvc__c = s.Id, Tp__c = 'Service Item');
        insert gsitem;
        g_srvcitm_Status__c status = new g_srvcitm_Status__c(Name = 'statustest', cd__c = 'ok', lbl__c = 'Pending Approval', Tp__c = 'Open', itm__c = gsitem.Id);
        insert status;
        // Create g_reqitem__c
        grqH.rAfter = false;
        grqH.rBefore = false;
        grqH.iBefore = false;
        grqH.iAfter = false;
        g_reqitem__c reqItem = new g_reqitem__c(
            itm__c = gsitem.id,
            RQ__c = r.id,
            xrramt__c = 100,
            xramt__c = 200,
            sta__c = status.Id,
            xtrf__c = 'Customer Deposit',
            name = 'Request Item'
        );
        insert reqItem;

        // Create ws_call__c
        ws_call__c ws = new ws_call__c(rq_itm__c = reqItem.Id, intsts__c = 'Ready for Integration', ws_typ__c = 'CreateBankFu', mtd_nm__c = 'BankAccUpdate');
        insert ws;
        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c limit 1];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();
        gtFussionWs.createBankAcc(ws.id);


        Test.stopTest();
    }

    static testmethod void meth19() {
        ws_call__c ws = new ws_call__c();
        ws.ws_typ__c = 'CreateBankFu';
        ws.mtd_nm__c = 'BankAccUpdate';
        ws.intsts__c = 'Ready for Integration';
        insert ws;
        Test.setMock(HttpCalloutMock.class, new Mock());
        List < g_Tran__c > tRef = [select id, name from g_Tran__c limit 1];
        System.debug('===tRef==' + tRef);
        gtFussionWs cls = new gtFussionWs();
        Test.startTest();
        gtFussionWs.preChecks(tRef[0].id);
        gtFussionWs.checkBalance('', '');
        gtFussionWs.voidCreateRefund('', tRef[0].id, ws);
        gtFussionWs.insertCallAtt(tRef[0].id, tRef[0].id, tRef[0].id);
        Test.stopTest();
    }

    // Test method for Customer Deposit refund flow
    @isTest
    static void testVoidCreateRefund_CustomerDeposit() {
        Test.setMock(HttpCalloutMock.class, new Mock());

        // Create related Account
        Account acc = new Account(Name = 'Test Account', adrfi__c = 200);
        insert acc;

        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        Contact sp = testData.conCrt(null, acc.Id, 'Active', 'Employee', 'Pass144', 'Egypt');
        Contact emp = testData.conCrt(sp, acc.Id, 'Active', 'Employee', 'Pass2111', 'Egypt');
        g_Req__c r = testData.reqCrt(acc.Id, s.Id, emp.Id, 'Open', stg.reqq__c);


        // Create g_Tran__c
        g_Tran__c tran = new g_Tran__c(Acc__c = acc.Id, RQ__c = r.id);
        insert tran;

        g_srvcitm__c gsitem = new g_srvcitm__c(Name = 'itemtest', cd__c = 'mi', lbl__c = 'itemntest', ord__c = 2, dSTA__c = 'n', srvc__c = s.Id, Tp__c = 'Service Item');
        insert gsitem;
        g_srvcitm_Status__c status = new g_srvcitm_Status__c(Name = 'statustest', cd__c = 'ok', lbl__c = 'Pending Approval', Tp__c = 'Open', itm__c = gsitem.Id);
        insert status;
        // Create g_reqitem__c
        grqH.rAfter = false;
        grqH.rBefore = false;
        grqH.iBefore = false;
        grqH.iAfter = false;
        g_reqitem__c reqItem = new g_reqitem__c(
            itm__c = gsitem.id,
            RQ__c = r.id,
            xrramt__c = 100,
            xramt__c = 200,
            sta__c = status.Id,
            xtrf__c = 'Customer Deposit',
            name = 'Request Item'
        );
        insert reqItem;

        // Create ws_call__c
        ws_call__c ws = new ws_call__c(rq_itm__c = reqItem.Id);
        insert ws;

        // Create test payload
        Map < String, Object > refundPayload = new Map < String, Object > {
            'REFUND_AMOUNT' => 0,
            'REMITTANCE_MESSAGE_2' => 'Initial'
        };
        String payload = JSON.serialize(refundPayload);

        Test.startTest();
        gwsH.rAfter = false;
        gtFussionWs.voidCreateRefund(payload, tran.RQ__c, ws);
        Test.stopTest();



    }

    // Test method for Bank Guarantee refund flow
    @isTest
    static void testVoidCreateRefund_BankGuarantee() {
        Test.setMock(HttpCalloutMock.class, new Mock());

        // Create related Account
        Account acc = new Account(Name = 'BG Account', bgrfi__c = 50, tbgr__c = 500);
        insert acc;

        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        Contact sp = testData.conCrt(null, acc.Id, 'Active', 'Employee', 'Pass122', 'Egypt');
        Contact emp = testData.conCrt(sp, acc.Id, 'Active', 'Employee', 'Pass244', 'Egypt');
        g_Req__c r = testData.reqCrt(acc.Id, s.Id, emp.Id, 'Open', stg.reqq__c);

        // Create g_Tran__c
        g_Tran__c tran = new g_Tran__c(Acc__c = acc.Id, RQ__c = r.id);
        insert tran;

        g_srvcitm__c gsitem = new g_srvcitm__c(Name = 'itemtest', cd__c = 'mi', lbl__c = 'itemntest', ord__c = 2, dSTA__c = 'n', srvc__c = s.Id, Tp__c = 'Service Item');
        insert gsitem;
        g_srvcitm_Status__c status = new g_srvcitm_Status__c(Name = 'statustest', cd__c = 'ok', lbl__c = 'Pending Approval', Tp__c = 'Open', itm__c = gsitem.Id);
        insert status;
        // Create g_reqitem__c
        grqH.rAfter = false;
        grqH.rBefore = false;
        grqH.iBefore = false;
        grqH.iAfter = false;
        g_reqitem__c reqItem = new g_reqitem__c(
            RQ__c = r.id,
            itm__c = gsitem.id,
            xrramt__c = 150,
            xramt__c = 200,
            sta__c = status.Id,
            xtrf__c = 'Bank Guarantee',
            name = 'BG Item'
        );
        insert reqItem;

        // Create ws_call__c
        ws_call__c ws = new ws_call__c(rq_itm__c = reqItem.Id);
        insert ws;

        // Payload
        Map < String, Object > refundPayload = new Map < String, Object > {
            'REFUND_AMOUNT' => 0,
            'REMITTANCE_MESSAGE_2' => 'Initial'
        };
        String payload = JSON.serialize(refundPayload);

        Test.startTest();
        gwsH.rAfter = false;
        gtFussionWs.voidCreateRefund(payload, tran.RQ__c, ws);
        customerRefund obj = new customerRefund();
        obj.REFUND_AMOUNT = 1111;
        obj.REFUND_TYPE = 'Test1';
        obj.ACCOUNT_NUMBER = 'Test1';
        obj.ACCOUNTING_DATE = 'Test1';
        obj.REFUND_PAYMENT_METHOD = 'Test1';
        obj.REMITTANCE_MESSAGE_1 = 'Test1';
        obj.REFUND_REFERENCE_ID = 'Test1';
        obj.REMITTANCE_MESSAGE_2 = 'Test1';
        TokenResp obj1 = new TokenResp();
        obj1.access_token = 'Test2';
        obj1.token_type = 'Test2';
        obj1.expires_in = 'Test2';
        obj1.scope = 'Test2';
        Test.stopTest();


    }
    private class Mock implements HttpCalloutMock {
        private String FAKE_RESPONSE_JSON = 'mockRes';
        public HTTPResponse respond(HTTPRequest req) {

            HTTPResponse res = new HTTPResponse();
            res.setBody(FAKE_RESPONSE_JSON);
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"STATUS":"Success"}');

            return res;
        }
    }


}