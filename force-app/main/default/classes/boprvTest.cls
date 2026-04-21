/**************************************************************************************************
@Version History
 * Version      Date            Name                        Description
 * 1.0         Initial          DHAM                         Initial Draft
 * 1.1         25-06-2024       Prateek Jangir              Increased code coverage.
 * 1.2         27-12-2024       Sorna Mary                  To increase coverage for ID Generation
**************************************************************************************************/
@IsTest
private class boprvTest {
    @testSetup static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        gStg__c crtstng = testData.createSetting('test', 'testvalue');

        list<g_srvcitm__c> itms = new list < g_srvcitm__c > ();
       // itms.add(new g_srvcitm__c(srvc__c = s.Id, dSTA__c = 'n', slaN__c = 4, slaXP__c = 2, ord__c = 1, Tp__c = 'Service Item', cd__c = 'ep', Name = 'ep', lbl__c = 'ep', Req__c = true, aln__c = true, mxcnt__c = 1, rv__c = true, prcEdt__c = false, DscApp__c = true, EXP__c = true, KF__c = 0, scN__c = 10, cN__c = 5, smN__c = 1, spChN__c = 1, scXP__c = 1, cXP__c = 1, smXP__c = 1, spChXP__c = 1, xf__c = 'xf__c;xfid__c;xfed__c;xrp__c;xrpid__c;xrped__c;xui__c;xr__c;xcmbso__c;xcmbs__c;xcmao__c;xcma__c;xcmoao__c;xcmoa__c;xcmtao__c;xcmta__c;xef__c;'));
        itms.add(new g_srvcitm__c(srvc__c = s.Id, dSTA__c = 'n', slaN__c = 4,
            slaXP__c = 2, ord__c = 1, Tp__c = 'Service Item', cd__c = 'ai',
            Name = 'ai', lbl__c = 'ai', Req__c = false, aln__c = true, mxcnt__c = 1,
            rv__c = true, prcEdt__c = false, DscApp__c = true, EXP__c = true,
            KF__c = 0, scN__c = 10, cN__c = 5, smN__c = 1, spChN__c = 1,
            scXP__c = 1, cXP__c = 1, smXP__c = 1, spChXP__c = 1,
                xf__c = 'xf__c;xfid__c;xfed__c;xrp__c;xrpid__c;xrped__c;xui__c;xr__c;xcmbso__c;xcmbs__c;xcmao__c;xcma__c;xcmoao__c;xcmoa__c;xcmtao__c;xcmta__c;xef__c;'));
        insert itms;

        list < g_srvcitm_Status__c > sta = new list < g_srvcitm_Status__c > ();
        for (g_srvcitm__c i: itms) {
            sta.add(new g_srvcitm_Status__c(itm__c = i.Id, Milestone__c = 'EP',
                slaa__c = 'Standard', statype__c = 'Process', actv__c = true,
                slaN__c = 4, slaXP__c = 2, cd__c = 'n', name = 'n', lbl__c = 'n',
                Tp__c = 'Open', rqSTA__c = '', clm__c = false, clmA__c = 0, rfnd__c = false,
                rfndA__c = 0, Shift_At__c = 'Payment', Shift_Items__c = 'rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c = i.Id, Milestone__c = 'EP',
                slaa__c = 'Completed', statype__c = 'Process', actv__c = true,
                slaN__c = 4, slaXP__c = 2, cd__c = 'ook', name = 'ook', lbl__c = 'ook',
                Tp__c = 'Completed', rqSTA__c = '', clm__c = false, clmA__c = 0,
                rfnd__c = false, rfndA__c = 0, Shift_At__c = 'Payment', Shift_Items__c = 'rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c = i.Id, Milestone__c = 'Medical',
                slaa__c = 'Parallel', statype__c = 'Process', actv__c = true,
                slaN__c = 4, slaXP__c = 2, cd__c = 'c', name = 'c', lbl__c = 'c',
                Tp__c = 'Cancelled', rqSTA__c = 'Cancelled', clm__c = true, clmA__c = 1,
                rfnd__c = true, rfndA__c = 1, Shift_At__c = 'Payment', Shift_Items__c = 'rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c = i.Id, Milestone__c = 'Medical',
                xcsits__c = 'md-F;', slaa__c = 'Parallel', statype__c = 'Process',
                actv__c = true, slaN__c = 4, slaXP__c = 2, cd__c = 'u', name = 'u',
                lbl__c = 'c', Tp__c = 'Cancelled', rqSTA__c = 'Cancelled', clm__c = true,
                clmA__c = 1, rfnd__c = true, rfndA__c = 1, Shift_At__c = 'Payment',
                Shift_Items__c = 'rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c = i.Id, Milestone__c = 'Medical',
                slaa__c = 'Parallel', statype__c = 'Process', actv__c = true,
                slaN__c = 4, slaXP__c = 2, cd__c = 'fi', name = 'fi', lbl__c = 'c',
                Tp__c = 'Open', rqSTA__c = 'In process', clm__c = true, clmA__c = 1,
                rfnd__c = true, rfndA__c = 1, Shift_At__c = 'Payment', Shift_Items__c = 'rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c = i.Id, Milestone__c = 'RP',
                slaa__c = 'Standard', statype__c = 'Process', actv__c = true,
                slaN__c = 4, slaXP__c = 2, cd__c = 'ok', name = 'ok', lbl__c = 'ok',
                Tp__c = 'Completed', rqSTA__c = 'Completed', clm__c = false,
                clmA__c = 0, rfnd__c = false, rfndA__c = 0, Shift_At__c = 'Payment',
                Shift_Items__c = 'rp;md;'));
        }
        insert sta;
    }

    static testmethod void loadDataIdNull() {
        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        system.debug('srvcLst----'+srvcLst);
        Contact c = new Contact(Id=conLst[0].Id, mbs__c=500000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3));
        update c;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];

        srvcLst[0].stg__c = srvcsettings[0].Id;
        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        system.debug('conLst[0].Id'+conLst[0].Id);
        g_Req__c req =testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        g_Tran__c transactionRecord = new g_Tran__c(Acc__c=req.Acc__c, RQ__c=req.Id, TP__c='Payment', md__c='Credit / Debit Card', sta__c='Open', gwrf__c='4354354353'); //1.1
        insert transactionRecord;

        Test.startTest();

        boprv bo = new boprv();
        bo.reqnum = req.Name;
        bo.op = 'ai';
        bo.saveRq();  //1.1

        bo.searchReq();

        bo.op = 'la';
        bo.saveRq();

         bo.op = 'resetOTP';
        bo.saveRq();

        bo.op = 'Cancelled';
        bo.saveRq();
        bo.op = 'Cancellation document';
        bo.saveRq();
        //1.1 Start
        g_Tran__c trnsRecord = [select id, name from g_Tran__c limit 1];
        bo.reqnum = trnsRecord.Name;
        bo.searchTran();

        bo.reqnum = 'Test Transaction Name';
        bo.searchTran();
        //1.1 End

        //1.2 Start
        bo.op = 'id';
        bo.saveRq();
        g_reqitem__c reqItm = [ SELECT Id FROM g_reqitem__c WHERE RQ__c = :req.Id LIMIT 1 ];
        g_TranItem__c txnitm = new g_TranItem__c(
            itm__c = reqItm.Id, T__c = transactionRecord.Id, Tp__c = 'Payment', STA__c = 'Completed', A__c = 2500
        );
        insert txnitm;
        bo.reqnum = req.Name;
        bo.op = 'id';
        bo.saveRq();
        //1.2 End
        boprv objprv1 = new boprv();
         objprv1.getRefundItm();
        objprv1.refundItm();
        boprv.itmWrapper objwrap = new boprv.itmWrapper (reqItm);
        bo.updateItms(req, 'ok');
        Test.stopTest();
    }
}