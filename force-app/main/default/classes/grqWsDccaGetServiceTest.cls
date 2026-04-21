@isTest
private class grqWsDccaGetServiceTest {

    @testSetup static void setup() {

    }
    static testMethod void doTest() {
        grqWsDccaGetService grq = new grqWsDccaGetService();
        grqWsDccaGetService.argLocation gargLoc = new  grqWsDccaGetService.argLocation () ;
        gargLoc.isRegoff = false;gargLoc.agreeNo = 'test1';gargLoc.edDt = 'test1';gargLoc.fullLoc = 'test1';gargLoc.status = 'test1';gargLoc.reason = 'test1';gargLoc.stDt = 'test1';
        grqWsDccaGetService.Titles title = new grqWsDccaGetService.Titles();
        title.name = 'test1';title.lang = 'test1';title.genere = 'test1';title.freq = 'test1';
        grqWsDccaGetService.Channels ch = new grqWsDccaGetService.Channels();
        ch.name = 'test1';ch.lang = 'test1';ch.genere = 'test1';ch.freq = 'test1';
        grqWsDccaGetService.Locations l = new grqWsDccaGetService.Locations();
        l.isRegoff = false;
        l.AgreementNo = 'test1';
        l.IsMainAdd=false;
        l.showOnLicen=false;
        l.ArabicBuildingName = 'test1';
        l.ArabicBusinessUnit = 'test1';
        l.ArabicFloor = 'test1';
        l.ArabicOfficeNo = 'test1';
        l.totalArea = 'test1';
        l.Category = 'test1';
        l.SubCategory = 'test1';
        l.regOff = false;
        l.OfficeNo = 'test1';
        l.LicenseNo = 'test1';
        l.LocationId = 'test1';
        l.BusinessPark = 'test1';
        l.BuildingName = 'test1';
        l.Floor = 'test1';
        l.Status = 'test1';
        l.ContractStatusReason = 'test1';
        l.ContractStartDate = date.today();
        l.ContractEnddate = date.today();
        l.subleaseCompany = 'test1';
        l.licenseType = 'test1';
        l.IsSubLease = 'test1';
        l.error = 'test1';
        l.IsDownsize = 'test1';
        l.RenewalOpp = 'test1';
        l.Recordtype = 'test1';
        l.masterLocationLicense = 'test1';
        grqWsDccaGetService.Activities act = new grqWsDccaGetService.Activities();
        act.LicenseNo = 'test1';act.ActivityId = 'test1';act.type = 'test1';act.accName = 'test1';act.titleList = null;act.chanList = null;act.StartDate = Date.today();act.error = 'test1';
        grqWsDccaGetService.ActivityLocations actl = new grqWsDccaGetService.ActivityLocations();
        actl.error = 'test1';actl.errorCode = 'test1';
        grqWsDccaGetService.DocumentD doc = new grqWsDccaGetService.DocumentD();
        doc.name = 'Test1'; doc.shareHolderName = 'Test1'; doc.isRequired = false;
        grqWsDccaGetService.LineItems li = new grqWsDccaGetService.LineItems();
        li.segment = 'Test';li.activity = 'Test';li.isActive = 'Test';li.lineName = 'Test';li.amount = 1000;
        grqWsDccaGetService.Data dt = new grqWsDccaGetService.Data();
        dt.docs = null;
        dt.lines = null;
        dt.idRec='test';
        dt.sme='test';
        dt.amount =1000;
        dt.name = 'Test';
        dt.mangerName = 'Test';
        dt.mangerNameA = 'Test';
        dt.leaseType = 'Test';
        dt.managerNation = 'Test';
        dt.managerNationA = 'Test';
        dt.errorCode = 'Test';
        dt.errorMessage = 'Test';
        dt.licType = 'Test';
        dt.buRecomendation = false;
        dt.shareHldType = 'Test';
        grqWsDccaGetService.sanctions sc = new grqWsDccaGetService.sanctions();
        sc.sanctionDept = 'Test';sc.sancdescriprtion = 'Test';
        grqWsDccaGetService.ResponseData rd = new grqWsDccaGetService.ResponseData();
        rd.PartyId = 'Test';rd.Success = false;rd.Source = 'Test';rd.Error = 'Test';rd.ResponseCode = 'Test';
        List<grqWsDccaGetService.Records> rcLst = new List<grqWsDccaGetService.Records>();
        grqWsDccaGetService.Records rc = new grqWsDccaGetService.Records();
        rc.StageName = 'Test';
        rc.AgNo = 'Test';
        rc.LeaseType = 'Test';
        rc.Type = 'Test';
        rc.regOff = false;
        rc.BusinessPark = 'Test';
        rc.ContractStartDate = 'Test';
        rc.ContractEndDate = '12/09/2019';
        rc.Category = 'Test';
        rc.SubCategory = 'Test';
        rc.ContractStatus = 'Test';
        rc.ContractStatusReason = 'Ready for Activation';
        rc.Products = null;
        rc.fullUnitAdd = 'Test';
        rc.IsDownsize = 'Test';
        rc.RenewalOpp = 'Test';
        rcLst.add(rc);
        grqWsDccaGetService.getNewLicDt(rcLst, Date.today(), 'Free Zone Limited Liability company');
        grqWsDccaGetService.getNewLicDt(rcLst, Date.today(), 'Freelancer');
        grqWsDccaGetService.getNewLicDt(rcLst, Date.today(), '');
        grqWsDccaGetService.Units unit = new grqWsDccaGetService.Units();
        unit.UnitNameArabic='Test';
        unit.FloorArabic='Test';
        unit.BuildingNameArabic='Test';
        unit.SendToDCCA='Test';
        unit.UnitName='Test';
        unit.UnitNumber='Test';
        unit.FloorName='Test';
        unit.CommercialName='Test';
        unit.UniqueKey='Test';
        unit.AgNo='Test';
        unit.ContractStartDate='Test';
        unit.ContractEnddate='Test';

        grqWsDccaGetService.ContractInfo cinfo=new grqWsDccaGetService.ContractInfo();
        cinfo.contractNo=cinfo.contractNo;
        cinfo.buildingName=cinfo.buildingName;
        cinfo.businessPark=cinfo.businessPark;
        cinfo.contractStartdate=cinfo.contractStartdate;
        cinfo.contractEnddate=cinfo.contractEnddate;
        cinfo.unitNo=cinfo.unitNo;
        cinfo.floor=cinfo.floor;
        cinfo.status=cinfo.status;
        cinfo.contractType=cinfo.contractType;
        cinfo.businessUnit=cinfo.businessUnit;
        cinfo.unitNoArb=cinfo.unitNoArb;
        cinfo.floorArb=cinfo.floorArb;
        cinfo.buildingnameArb=cinfo.buildingnameArb;
        cinfo.businessUnitArb=cinfo.businessUnitArb;
        cinfo.totalArea=cinfo.totalArea;
    }

    static testMethod void testbatchgetReq() {

        Test.startTest();
        testData.init();

        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s = new g_Srvc__c(Name='Srvc', lbl__c='Srvc', stg__c=stg.Id, uid__c='208',
            actv__c=true, ckgsnc__c=true, Prk__c='Dubai Internet City', AccTp__c='Customer - External',
            ConRol__c='Employee', ConSTA__c='Active', payMd__c='Customer Deposit; Cash; Credit / Debit Card',
            Category__c='Employees Services', Sub_Category__c='Renewal Visa', Milestone_Stage__c='Ep;Medical;Rp;',
            Milestone_SLA__c='10;2;6');
        insert s;

        list<g_srvcitm__c> itms = new list<g_srvcitm__c>();
        itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
            slaXP__c=2, ord__c=1, Tp__c='Service Item',
                cd__c='dr', dcr__c ='Approval from DM:Approval from DM;Catering Service Agreement:Catering Service Agreement;NOC from LandLord:NOC from LandLord;Service Provider License Copy:Service Provider License Copy;Signed Catering Permit Guidelines:Signed Catering Permit Guidelines;',
            Name='rp', lbl__c='rp', Req__c=true, aln__c=true, mxcnt__c=1,
            rv__c=true, prcEdt__c=false, DscApp__c=true, EXP__c=true, KF__c=0,
            scN__c=10, cN__c=5, smN__c=1, spChN__c=1, scXP__c=1, cXP__c=1,
            smXP__c=1, spChXP__c=1, xf__c='xf__c;xfid__c;xfed__c;xrp__c;xrpid__c;xrped__c;xui__c;xr__c;xcmbso__c;xcmbs__c;xcmao__c;xcma__c;xcmoao__c;xcmoa__c;xcmtao__c;xcmta__c;xef__c;'));
        itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
            slaXP__c=2, ord__c=2, Tp__c='Service Item', cd__c='pnt', Name='pnt',
            lbl__c='pnt', Req__c=false, mxcnt__c=1, rv__c=false, prcEdt__c=true,
            DscApp__c=false, EXP__c=false, KF__c=0, scN__c=10, cN__c=5, smN__c=1,
            spChN__c=1, scXP__c=1, cXP__c=1, smXP__c=1, spChXP__c=1, xf__c=''));
        insert itms;

        list<g_srvcitm_Status__c> sta = new list<g_srvcitm_Status__c>();
        for (g_srvcitm__c i:itms) {
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='EP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='n', name='n', lbl__c='n', Tp__c='Open', rqSTA__c='',
                clm__c=false, clmA__c=0, rfnd__c=false, rfndA__c=0, Shift_At__c='Payment',
                Shift_Items__c='rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='EP',
                slaa__c='Completed', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='ook', name='ook', lbl__c='ook', Tp__c='Completed',
                rqSTA__c='', clm__c=false, clmA__c=0, rfnd__c=false, rfndA__c=0,
                Shift_At__c='Payment', Shift_Items__c='rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c = 'Medical',
                slaa__c='Parallel', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='c', name='c', lbl__c='c', Tp__c='Cancelled',
                rqSTA__c='Cancelled', clm__c=true, clmA__c=1, rfnd__c=true, rfndA__c=1,
                Shift_At__c='Payment', Shift_Items__c='rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='RP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='ok', name='ok', lbl__c='ok', Tp__c='Completed',
                rqSTA__c='Completed', clm__c=false, clmA__c=0, rfnd__c=false,
                rfndA__c=0, Shift_At__c='Payment', Shift_Items__c='rp;md;'));
        }
        insert sta;

        Account a=testData.accCrt(false);
        a.ORACLE_PARTY_ID__c = '1234';  a.lc__c='999999';a.dccaexId__c='12345';a.lcedt__c=system.today().addmonths(7);a.DDA_External_ID__c='12345';
        update a;

        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c rq=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        rq.rtacn__c = '1234';rq.xoln__c='055372654'; rq.rmob__c='0512341234';
        rq.xceml__c='a@b.com'; rq.xintp__c = 'SILVER'; rq.xcp__c = 'P98989876';
        update rq;
        list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, rq__c, RQ__r.Id, RQ__r.name from g_reqitem__c limit 1];
        System.debug('<rqItm[0]> : ' + rqItm[0].RQ__r.Id);
        Blob b = Blob.valueOf('Test Data');
        Attachment att = new Attachment();
        att.ParentId = rqItm[0].RQ__r.id;
        att.Name = 'test 2';
        att.Body = b;
        insert att;

        g_reqDoc__c r1 = new g_reqDoc__c();
        r1.Name = 'Approval from DM';
        r1.RQ__c = rqItm[0].RQ__r.id;
        Insert r1;

        Attachment attach=new Attachment();
        attach.Name='Approval from DM.jpg';
        Blob bodyBlob=Blob.valueOf('Unit Test Approval from DM Body');
        attach.body=bodyBlob;
        attach.parentId=r1.id;
        insert attach;

        List<ws_call__c> wsList = new List<ws_call__c>();

        ws_call__c ws = new ws_call__c();
        ws.intsts__c= 'Ready for Integration';
        ws.mtd_nm__c = 'LicenseRenewalDoc' ;
        ws.pmid__c ='' ;
        ws.rq_itm__c=rqItm[0].id;
        ws.rq_jsn__c='{"AttachmentList":[{"Name":"Approval from DM", "attachmentBody":"test"}]}';
        ws.ws_typ__c='DCCA AddRemove Sanction';
        wsList.add(ws);

        /*  ws_call__c ws1 = new ws_call__c();
ws1.intsts__c= 'Ready for Integration';
ws1.mtd_nm__c = 'LicenseRenewalCopy' ;
ws1.pmid__c ='' ;
ws1.rq_itm__c=rqItm[0].id;
ws1.rq_jsn__c='{"AttachmentList":[{"Name":"Approval from DM", "attachmentBody":"test"}]}';
ws1.ws_typ__c='DCCA License Renewals';
wsList.add(ws1); */

        Insert wsList;
        List<Account> accLst = [select id, lc__c, licexdt__c, DDA_External_ID__c from Account where Name='Acc' LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockInsgetReqDetails());
        grqWsDccaGetService.Records gr = new grqWsDccaGetService.Records();
        string OppArea = gr.OppArea;
        grqWsDccaGetService.Invoices gi = new grqWsDccaGetService.Invoices();
        string InvoiceId = gi.InvoiceId;
        string InvoiceName = gi.InvoiceName;
        string InvoiceDueDate= gi.InvoiceDueDate;
        string InvoiceType = gi.InvoiceType;
        string InvoiceAmount = gi.InvoiceAmount;
        grqWsDccaGetService.PaymentSchedules gp = new grqWsDccaGetService.PaymentSchedules();
        grqWsDccaGetService.DData gd = new grqWsDccaGetService.DData();
        string body= gd.body;
        string Id = gp.Id;
        string Name= gp.Name;
        string Type = gp.Type;
        string Amount = gp.Id;
        String strgetReq =  grqWsDccaGetService.getReqDetails(accLst[0].lc__c, accLst[0].licexdt__c, accLst[0].DDA_External_ID__c);
        String strgetReqq =  grqWsDccaGetService.getReqDetails(accLst[0].lc__c, accLst[0].licexdt__c, accLst[0].DDA_External_ID__c, false);
        string docname =    grqWsDccaGetService.getDocument(accLst[0].lc__c, 'test doc');
        string acclic = grqWsDccaGetService.getLicenseCopy(accLst[0].lc__c);
        string getNew = grqWsDccaGetService.getNewReqDetails(rqItm[0].RQ__r.Name);
        //String strSeg =   grqWsDccaGetService.loadAllSeg('19299');
        // String strloc =   grqWsDccaGetService.loaddccaLoc('19299');
        // List<grqWsDccaGetService.Records> testRecordList =   grqWsDccaGetService.getAgreements('AG-110743');
        Test.stopTest();
    }

    static testMethod void testbatchSeg() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockInsloadAllSeg());
        String strSeg =   grqWsDccaGetService.loadAllSeg('19299');
        Test.stopTest();
    }
    static testMethod void testbatchcrtdoc() {
        Test.startTest();
        testData.init();

        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s = new g_Srvc__c(Name='Srvc', lbl__c='Srvc', stg__c=stg.Id, uid__c='208',
            actv__c=true, ckgsnc__c=true, Prk__c='Dubai Internet City', AccTp__c='Customer - External',
            ConRol__c='Employee', ConSTA__c='Active', payMd__c='Customer Deposit; Cash; Credit / Debit Card',
            Category__c='Employees Services', Sub_Category__c='Renewal Visa', Milestone_Stage__c='Ep;Medical;Rp;',
            Milestone_SLA__c='10;2;6');
        insert s;

        list<g_srvcitm__c> itms = new list<g_srvcitm__c>();
        itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
            slaXP__c=2, ord__c=1, Tp__c='Service Item',
                cd__c='dr', dcr__c ='Approval from DM:Approval from DM;Catering Service Agreement:Catering Service Agreement;NOC from LandLord:NOC from LandLord;Service Provider License Copy:Service Provider License Copy;Signed Catering Permit Guidelines:Signed Catering Permit Guidelines;',
            Name='rp', lbl__c='rp', Req__c=true, aln__c=true, mxcnt__c=1,
            rv__c=true, prcEdt__c=false, DscApp__c=true, EXP__c=true, KF__c=0,
            scN__c=10, cN__c=5, smN__c=1, spChN__c=1, scXP__c=1, cXP__c=1,
            smXP__c=1, spChXP__c=1, xf__c='xf__c;xfid__c;xfed__c;xrp__c;xrpid__c;xrped__c;xui__c;xr__c;xcmbso__c;xcmbs__c;xcmao__c;xcma__c;xcmoao__c;xcmoa__c;xcmtao__c;xcmta__c;xef__c;'));
        itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
            slaXP__c=2, ord__c=2, Tp__c='Service Item', cd__c='pnt', Name='pnt',
            lbl__c='pnt', Req__c=false, mxcnt__c=1, rv__c=false, prcEdt__c=true,
            DscApp__c=false, EXP__c=false, KF__c=0, scN__c=10, cN__c=5, smN__c=1,
            spChN__c=1, scXP__c=1, cXP__c=1, smXP__c=1, spChXP__c=1, xf__c=''));
        insert itms;

        list<g_srvcitm_Status__c> sta = new list<g_srvcitm_Status__c>();
        for (g_srvcitm__c i:itms) {
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='EP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='n', name='n', lbl__c='n', Tp__c='Open', rqSTA__c='',
                clm__c=false, clmA__c=0, rfnd__c=false, rfndA__c=0, Shift_At__c='Payment',
                Shift_Items__c='rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='EP',
                slaa__c='Completed', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='ook', name='ook', lbl__c='ook', Tp__c='Completed',
                rqSTA__c='', clm__c=false, clmA__c=0, rfnd__c=false, rfndA__c=0,
                Shift_At__c='Payment', Shift_Items__c='rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c = 'Medical',
                slaa__c='Parallel', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='c', name='c', lbl__c='c', Tp__c='Cancelled',
                rqSTA__c='Cancelled', clm__c=true, clmA__c=1, rfnd__c=true, rfndA__c=1,
                Shift_At__c='Payment', Shift_Items__c='rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='RP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='ok', name='ok', lbl__c='ok', Tp__c='Completed',
                rqSTA__c='Completed', clm__c=false, clmA__c=0, rfnd__c=false,
                rfndA__c=0, Shift_At__c='Payment', Shift_Items__c='rp;md;'));
        }
        insert sta;

        Account a=testData.accCrt(false);
        a.ORACLE_PARTY_ID__c = '1234';  a.lc__c='999999';a.dccaexId__c='12345';a.lcedt__c=system.today().addmonths(7);a.DDA_External_ID__c='12345';
        update a;

        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c rq=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        rq.rtacn__c = '1234';rq.xoln__c='055372654'; rq.rmob__c='0512341234';
        rq.xceml__c='a@b.com'; rq.xintp__c = 'SILVER'; rq.xcp__c = 'P98989876';
        update rq;
        list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, rq__c, RQ__r.Id from g_reqitem__c limit 1];
        System.debug('<rqItm[0]> : ' + rqItm[0].RQ__r.Id);
        Blob b = Blob.valueOf('Test Data');
        Attachment att = new Attachment();
        att.ParentId = rqItm[0].RQ__r.id;
        att.Name = 'test 2';
        att.Body = b;
        insert att;

        g_reqDoc__c r1 = new g_reqDoc__c();
        r1.Name = 'Approval from DM';
        r1.RQ__c = rqItm[0].RQ__r.id;
        Insert r1;

        Attachment attach=new Attachment();
        attach.Name='Approval from DM.jpg';
        Blob bodyBlob=Blob.valueOf('Unit Test Approval from DM Body');
        attach.body=bodyBlob;
        attach.parentId=r1.id;
        insert attach;

        Test.setMock(HttpCalloutMock.class, new MockInsloadAllSeg());
        List<String> docname = new List<String>();
        docname.add('Test Doc');
        grqWsDccaGetService.crtdoc(docname);
        grqWsDccaGetService.convertDateArabic(Date.today(), '1');
        grqWsDccaGetService.convertDateArabic(Date.today().addMonths(1), '1');
        grqWsDccaGetService.convertDateArabic(Date.today().addMonths(2), '1');
        grqWsDccaGetService.convertDateArabic(Date.today().addMonths(3), '1');
        grqWsDccaGetService.convertDateArabic(Date.today().addMonths(4), '1');
        grqWsDccaGetService.convertDateArabic(Date.today().addMonths(5), '1');
        grqWsDccaGetService.convertDateArabic(Date.today().addMonths(6), '1');
        grqWsDccaGetService.convertDateArabic(Date.today().addMonths(7), '1');
        grqWsDccaGetService.convertDateArabic(Date.today().addMonths(8), '1');
        grqWsDccaGetService.convertDateArabic(Date.today().addMonths(9), '1');
        grqWsDccaGetService.convertDateArabic(Date.today().addMonths(10), '1');
        grqWsDccaGetService.convertDateArabic(Date.today().addMonths(11), '1');
        grqWsDccaGetService.sortPermises('test1;test2;test3', ';');
        grqWsDccaGetService.convertNumToAr('2');
        grqWsDccaGetService.convertNumToAr('2');
        grqWsDccaGetService.getArabicBU('D3');
        grqWsDccaGetService.getArabicBU('DHC');
        grqWsDccaGetService.getArabicBU('DIAC');
        grqWsDccaGetService.getArabicBU('DKP');
        grqWsDccaGetService.getArabicBU('DIC');
        grqWsDccaGetService.getArabicBU('DOC');
        grqWsDccaGetService.getArabicBU('DMC');
        grqWsDccaGetService.getArabicBU('DSC');
        grqWsDccaGetService.getArabicBU('DPC');
        grqWsDccaGetService.getArabicBU('DSP');
        grqWsDccaGetService.getEnglishBU('D3');
        grqWsDccaGetService.getEnglishBU('DHC');
        grqWsDccaGetService.getEnglishBU('DIAC');
        grqWsDccaGetService.getEnglishBU('DKP');
        grqWsDccaGetService.getEnglishBU('DIC');
        grqWsDccaGetService.getEnglishBU('DOC');
        grqWsDccaGetService.getEnglishBU('DMC');
        grqWsDccaGetService.getEnglishBU('DSC');
        grqWsDccaGetService.getEnglishBU('DPC');
        grqWsDccaGetService.getEnglishBU('DSP');
        List<grqWsDccaGetService.Units> unitLst = new List<grqWsDccaGetService.Units>();
        grqWsDccaGetService.Units unit = new grqWsDccaGetService.Units();
        unit.UnitNoEnglish = 'Dubai Design District'; unit.UnitNoArabic='test';
        unitLst.add(unit);
        Map<string, List<grqWsDccaGetService.Units>> argUnitMap = new Map<string, List<grqWsDccaGetService.Units>>();
        argUnitMap.put('test1', unitLst);
        grqWsDccaGetService.remapUnitsAgr(argUnitMap);
        grqWsDccaGetService.formatDt2('01/01/2019');
        grqWsDccaGetService.formatDt('01-01-2019');
        g_Req__c req = [select id, name, xdei__c, xlicd__c, (select id, name, sta__c From Items__r where IsDeleted=false order by itm__r.ord__c) from g_Req__c];
        map < Id, g_Req__c > reqMap = new map < Id, g_Req__c >();
        for (g_reqitem__c ri : req.Items__r)
            reqMap.put(ri.id, req);
        grqWsDccaGetService.sendDccaLic(req.Items__r, reqMap, 'DCCA AddRemove Sanction', 'LicenseRenewalDoc');

        Test.stopTest();
    }

    static testMethod void testbatchloc() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockInsloaddccaLoc());
        String strSeg =   grqWsDccaGetService.loaddccaLoc('19299');
        Test.stopTest();
    }

    static testMethod void testbatchtecomAgloc() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockgetAgreements());
        List<grqWsDccaGetService.Records> testRecordList =   grqWsDccaGetService.getAgreements('AG-110743');
        //  String getNewLicDt=  grqWsDccaGetService.getNewLicDt(testRecordList, '2019-11-01');
        List<grqWsDccaGetService.Units> newUnitList  = new  List<grqWsDccaGetService.Units>();
        for (grqWsDccaGetService.Records rec : testRecordList) {
            if (rec.Units != null) newUnitList.addAll(rec.Units);
        }
        if (newUnitList != null && newUnitList.size()>0)  grqWsDccaGetService.filterCategoriesForUnits(newUnitList);
        Test.stopTest();
    }

    static testMethod void testbatchD3Agloc() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockgetAgreements());
        List<grqWsDccaGetService.Records> testRecordList =   grqWsDccaGetService.getD3Agreements('AG-110743');
        Test.stopTest();
    }

    static testMethod void testbatchgetTecomLoc() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockgetcrmLoc());
        List<grqWsDccaGetService.Records> testRecordList =   grqWsDccaGetService.loadTecomCRMLoc('1475811');
        Test.stopTest();
    }

    static testMethod void testbatchgetD3Loc() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockgetcrmLoc2());
        List<grqWsDccaGetService.Records> testRecordList =   grqWsDccaGetService.loadD3Loc('1475811');
        grqWsDccaGetService.filterCategories(testRecordList);
        List<grqWsDccaGetService.Units> newUnitList  = new  List<grqWsDccaGetService.Units>();
        for (grqWsDccaGetService.Records rec : testRecordList) {
            if (rec.Units != null) newUnitList.addAll(rec.Units);
        }
        if (newUnitList != null && newUnitList.size()>0)  grqWsDccaGetService.filterCategoriesForUnits(newUnitList);
        Test.stopTest();
    }

    public class MockInsgetReqDetails implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Data":[{"sme":null, "shareHldType":"Corporate - BOF", "name":"REQ-00213171", "mangerNameA":"تونجتونج  زهو", "mangerName":"Tongtong Zhou", "managerNationA":"الصين", "managerNation":"China", "lines":[{"segment":null, "lineName":"Knowledge Dirham", "amount":10, "activity":null}, {"segment":null, "lineName":"Innovation Dirham", "amount":10, "activity":null}, {"segment":"Design", "lineName":"Design - Consultancy", "amount":22397, "activity":"Consultancy"}, {"segment":"Design", "lineName":"Design - Concept Design (Free for Segment:Design)", "amount":0, "activity":"Concept Design"}, {"segment":"Design", "lineName":"Design - Information, Interface and Digital Design (Free for Segment:Design)", "amount":0, "activity":"Information, Interface and Digital Design"}, {"segment":"Executive Search", "lineName":"Executive Search - Executive Search", "amount":14932, "activity":"Executive Search"}, {"segment":"Human Resources Consultancy", "lineName":"Human Resources Consultancy - Organizational Restructuring and Reorganizing", "amount":14932, "activity":"Organizational Restructuring and Reorganizing"}, {"segment":"Human Resources Consultancy", "lineName":"Human Resources Consultancy - Compensation, Benefits & Recognition (Free for Segment:Human Resources Consultancy)", "amount":0, "activity":"Compensation, Benefits & Recognition"}, {"segment":"Human Resources Consultancy", "lineName":"Human Resources Consultancy - Career Development & Management (Free for Segment:Human Resources Consultancy)", "amount":0, "activity":"Career Development & Management"}, {"segment":"Consultancy", "lineName":"Consultancy - Management Consultancy", "amount":14932, "activity":"Management Consultancy"}, {"segment":"Software", "lineName":"Software - Solution Provider", "amount":14932, "activity":"Solution Provider"}, {"segment":"Software", "lineName":"Software - Developer (Free for Segment:Software)", "amount":0, "activity":"Developer"}, {"segment":"Software", "lineName":"Software - Customer Service (Free for Segment:Software)", "amount":0, "activity":"Customer Service"}, {"segment":"Software", "lineName":"Software - Support Service Provider (Free for Segment:Software)", "amount":0, "activity":"Support Service Provider"}, {"segment":"Software", "lineName":"Software - Consultancy (Free for Segment:Software)", "amount":0, "activity":"Consultancy"}, {"segment":"IT Service", "lineName":"IT Service - Developer", "amount":14932, "activity":"Developer"}, {"segment":"IT Service", "lineName":"IT Service - Consultancy (Free for Segment:IT Service)", "amount":0, "activity":"Consultancy"}, {"segment":"IT Service", "lineName":"IT Service - Customer Service (Free for Segment:IT Service)", "amount":0, "activity":"Customer Service"}, {"segment":"IT Service", "lineName":"IT Service - Solution Provider (Free for Segment:IT Service)", "amount":0, "activity":"Solution Provider"}, {"segment":"IT Service", "lineName":"IT Service - Support Service Provider (Free for Segment:IT Service)", "amount":0, "activity":"Support Service Provider"}, {"segment":"Regional Head Quarters", "lineName":"Regional Head Quarters - Administration Office", "amount":14932, "activity":"Administration Office"}], "licType":"Commercial License", "licNo":"19299", "leaseType":"Tecom Commercial Lease", "idRec":"a1C5D000000VTdKUAW", "expDate":"2019-11-01", "errorMessage":"", "errorCode":"0", "docs":[{"name":"Original Certificate of Good Standing", "isRequired":true}], "amount":112009}]}');
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockInsloadAllSeg implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"MethodName":"getActivities", "locationList":null, "LicnseNo":"19299", "errorCode":"0", "error":"", "act":[{"type":"Office", "titleList":null, "StartDate":"2016-03-31", "segName":"Design", "Name":"Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a296F000004GUQfQAO", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2016-03-31", "segName":"Design", "Name":"Concept Design", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a296F000004GUQgQAO", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2016-03-31", "segName":"Design", "Name":"Information, Interface and Digital Design", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a296F000004GUQhQAO", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Executive Search", "Name":"Executive Search", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80VAAQ", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Human Resources Consultancy", "Name":"Organizational Restructuring and Reorganizing", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80aAAA", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Human Resources Consultancy", "Name":"Compensation, Benefits & Recognition", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80fAAA", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Human Resources Consultancy", "Name":"Career Development & Management", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80kAAA", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2003-12-22", "segName":"Consultancy", "Name":"Management Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NGVIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2009-04-01", "segName":"Software", "Name":"Solution Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NHHIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Developer", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NKoIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2003-12-22", "segName":"Regional Head Quarters", "Name":"Administration Office", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NKtIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NKuIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Customer Service", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NLBIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2009-04-01", "segName":"IT Service", "Name":"Solution Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NPjIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Support Service Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NQuIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Developer", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NSrIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Customer Service", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NStIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Support Service Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NVIIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NVVIA2", "accName":null}]}');
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockInsloaddccaLoc implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"MethodName":"getLocations", "locationList":[{"totalArea":"662", "subleaseCompany":null, "SubCategory":"Office", "Status":"Active", "showOnLicen":false, "regOffFlag":null, "Recordtype":"Tecom CRM Integration", "prodList":[{"UnitNumber":"305", "regOff":false, "ProductName":"DIC-Bldg 05-305", "LineItemName":"a0sA0000000UgkOIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"206", "regOff":false, "ProductName":"DIC-Bldg 05-206", "LineItemName":"a0sA0000000UgkCIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"204", "regOff":false, "ProductName":"DIC-Bldg 05-204", "LineItemName":"a0sA0000000UgkAIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"202", "regOff":false, "ProductName":"DIC-Bldg 05-202", "LineItemName":"a0sA0000000Ugk8IAC", "floor":"2", "buildingName":"5"}, {"UnitNumber":"203", "regOff":false, "ProductName":"DIC-Bldg 05-203", "LineItemName":"a0sA0000000Ugk9IAC", "floor":"2", "buildingName":"5"}, {"UnitNumber":"201", "regOff":false, "ProductName":"DIC-Bldg 05-201", "LineItemName":"a0sA0000000Ugk7IAC", "floor":"2", "buildingName":"5"}, {"UnitNumber":"205", "regOff":false, "ProductName":"DIC-Bldg 05-205", "LineItemName":"a0sA0000000UgkBIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"111", "regOff":false, "ProductName":"DIC-Bldg 05-111", "LineItemName":"a0sA0000000UgjtIAC", "floor":"1", "buildingName":"5"}, {"UnitNumber":"110", "regOff":false, "ProductName":"DIC-Bldg 05-110", "LineItemName":"a0sA0000000UgjsIAC", "floor":"1", "buildingName":"5"}, {"UnitNumber":"109", "regOff":false, "ProductName":"DIC-Bldg 05-109", "LineItemName":"a0sA0000000UgjrIAC", "floor":"1", "buildingName":"5"}, {"UnitNumber":"112", "regOff":false, "ProductName":"DIC-Bldg 05-112", "LineItemName":"a0sA0000000UgjuIAC", "floor":"1", "buildingName":"5"}, {"UnitNumber":"224", "regOff":false, "ProductName":"DIC-Bldg 05-224", "LineItemName":"a0sA0000000UgkJIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"316", "regOff":false, "ProductName":"DIC-Bldg 05-316", "LineItemName":"a0sA0000000UgkZIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"317", "regOff":false, "ProductName":"DIC-Bldg 05-317", "LineItemName":"a0sA0000000UgkaIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"313", "regOff":false, "ProductName":"DIC-Bldg 05-313", "LineItemName":"a0sA0000000UgkWIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"315", "regOff":false, "ProductName":"DIC-Bldg 05-315", "LineItemName":"a0sA0000000UgkYIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"223", "regOff":false, "ProductName":"DIC-Bldg 05-223", "LineItemName":"a0sA0000000UgkIIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"309", "regOff":false, "ProductName":"DIC-Bldg 05-309", "LineItemName":"a0sA0000000UgkSIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"308", "regOff":false, "ProductName":"DIC-Bldg 05-308", "LineItemName":"a0sA0000000UgkRIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"322", "regOff":false, "ProductName":"DIC-Bldg 05-322", "LineItemName":"a0sA0000000UgkfIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"220", "regOff":false, "ProductName":"DIC-Bldg 05-220", "LineItemName":"a0sA0000000UgkFIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"314", "regOff":false, "ProductName":"DIC-Bldg 05-314", "LineItemName":"a0sA0000000UgkXIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"312", "regOff":false, "ProductName":"DIC-Bldg 05-312", "LineItemName":"a0sA0000000UgkVIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"307", "regOff":false, "ProductName":"DIC-Bldg 05-307", "LineItemName":"a0sA0000000UgkQIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"219", "regOff":false, "ProductName":"DIC-Bldg 05-219", "LineItemName":"a0sA0000000UgkEIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"222", "regOff":false, "ProductName":"DIC-Bldg 05-222", "LineItemName":"a0sA0000000UgkHIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"221", "regOff":true, "ProductName":"DIC-Bldg 05-221", "LineItemName":"a0sA0000000UgkGIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"303", "regOff":false, "ProductName":"DIC-Bldg 05-303", "LineItemName":"a0sA0000000UgkMIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"310", "regOff":false, "ProductName":"DIC-Bldg 05-310", "LineItemName":"a0sA0000000UgkTIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"323", "regOff":false, "ProductName":"DIC-Bldg 05-323", "LineItemName":"a0sA0000000UgkgIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"311", "regOff":false, "ProductName":"DIC-Bldg 05-311", "LineItemName":"a0sA0000000UgkUIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"302", "regOff":false, "ProductName":"DIC-Bldg 05-302", "LineItemName":"a0sA0000000UgkLIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"304", "regOff":false, "ProductName":"DIC-Bldg 05-304", "LineItemName":"a0sA0000000UgkNIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"301", "regOff":false, "ProductName":"DIC-Bldg 05-301", "LineItemName":"a0sA0000000UgkKIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"321", "regOff":false, "ProductName":"DIC-Bldg 05-321", "LineItemName":"a0sA0000000UgkeIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"324", "regOff":false, "ProductName":"DIC-Bldg 05-324", "LineItemName":"a0sA0000000UgkhIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"319", "regOff":false, "ProductName":"DIC-Bldg 05-319", "LineItemName":"a0sA0000000UgkcIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"318", "regOff":false, "ProductName":"DIC-Bldg 05-318", "LineItemName":"a0sA0000000UgkbIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"320", "regOff":false, "ProductName":"DIC-Bldg 05-320", "LineItemName":"a0sA0000000UgkdIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"306", "regOff":false, "ProductName":"DIC-Bldg 05-306", "LineItemName":"a0sA0000000UgkPIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"305", "regOff":false, "ProductName":"DIC-Bldg 05-305", "LineItemName":"a0sA0000000UgkOIAS", "floor":"3", "buildingName":"5"}], "OfficeNo":"305", "masterLocationLicense":"", "LocationId":"a1i5D0000001fhGQAQ", "licenseType":"Commercial License", "LicenseNo":"19299", "IsSubLease":"NO", "IsMainAdd":false, "Floor":"3", "error":"", "ContractStatusReason":null, "ContractStartDate":"2016-09-15", "ContractEnddate":"2021-09-14", "Category":"Office", "BusinessPark":"Dubai Internet City", "BuildingName":"5", "ArabicOfficeNo":"305", "ArabicFloor":"3", "ArabicBusinessUnit":"مدينة دبي للإنترنت", "ArabicBuildingName":"5", "AgreementNo":"AG-117256"}, {"totalArea":"0", "subleaseCompany":null, "SubCategory":null, "Status":"Active", "showOnLicen":false, "regOffFlag":null, "Recordtype":"Tecom CRM Integration", "prodList":[{"UnitNumber":"401", "regOff":false, "ProductName":"Building 08-401", "LineItemName":"a03w000000Ekwt4AAB", "floor":"4", "buildingName":"089"}, {"UnitNumber":"410", "regOff":false, "ProductName":"Building 08-410", "LineItemName":"a03w000000EkwtBAAR", "floor":"4", "buildingName":"089"}, {"UnitNumber":"413", "regOff":false, "ProductName":"Building 08-413", "LineItemName":"a03w000000EkwtCAAR", "floor":"4", "buildingName":"089"}, {"UnitNumber":"414", "regOff":false, "ProductName":"Building 08-414", "LineItemName":"a03w000000EkwtDAAR", "floor":"4", "buildingName":"089"}, {"UnitNumber":"415", "regOff":false, "ProductName":"Building 08-415", "LineItemName":"a03w000000EkwtEAAR", "floor":"4", "buildingName":"089"}], "OfficeNo":"415", "masterLocationLicense":"", "LocationId":"a1i5D0000001TjAQAU", "licenseType":"Commercial License", "LicenseNo":"19299", "IsSubLease":"NO", "IsMainAdd":false, "Floor":"4", "error":"", "ContractStatusReason":null, "ContractStartDate":"2015-08-16", "ContractEnddate":"2020-11-13", "Category":"Office", "BusinessPark":"Dubai Design District", "BuildingName":"089", "ArabicOfficeNo":"415", "ArabicFloor":"4", "ArabicBusinessUnit":"حي دبي للتصميم", "ArabicBuildingName":"089", "AgreementNo":"AG-6849"}], "LicnseNo":"19299", "errorCode":"0", "error":"", "act":null}');
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockgetAgreements implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"ResponseData":{"AgNo":"AG-110743", "Success":true, "Source":"TBP", "Error":"", "ResponseCode":"200", "Records":[{"AgNo":"AG-110743", "Units":[{"UnitName":"DMC-Bldg 14-Full Building", "UnitNameArabic":"", "UnitNoArabic":"مبنى كامل", "UnitNoEnglish":"Full Building", "UnitNumber":"Full Building", "FloorArabic":"الأرضي", "FloorEnglish":"Ground", "FloorName":"Ground 0", "BuildingName":"14", "BuildingNameArabic":"14", "CommercialName":"DMC Bldg 14", "BusinessPark":"DMC", "UniqueKey":"DMCBldg 14", "Category":"Office", "SubCategory":"Office", "SendToDCCA":true}]}]}}');
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockgetcrmLoc implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(' {"ResponseData":{"PartyId":"1475811", "Success":true, "Source":"TBP", "Error":"", "ResponseCode":"200", "Records":[{"StageName":"Lease Renewal", "AgNo":"AG-131986", "LeaseType":"Tecom / PMLA", "BusinessPark":"DSC", "ContractStartDate":"2021-01-01", "ContractEndDate":"2021-12-31", "Category":"Office", "SubCategory":"Office", "ContractStatus":"In Progress", "ContractStatusReason":"Customer Signed", "IsDownsize":false, "RenewalOpp":"", "Products":[{"LineItemName":"Renewal: 2021 : Camouflage Productions FZ-LLC- DSC-Bldg 04-203", "ProductName":"DSC-Bldg 04-203", "UnitNumber":"203"}]}, {"StageName":"Closed Won", "AgNo":"AG-126889", "LeaseType":"Tecom / PMLA", "BusinessPark":"DSC", "ContractStartDate":"2018-01-01", "ContractEndDate":"2020-12-31", "Category":"Office", "SubCategory":"Office", "ContractStatus":"Active", "ContractStatusReason":"Active", "IsDownsize":false, "RenewalOpp":"AG-131986", "Products":[{"LineItemName":"Camouflage Productions FZ-LLC- DSC-Bldg 04-203", "ProductName":"DSC-Bldg 04-203", "UnitNumber":"203"}]}]}}');
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockgetcrmLoc2 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"ResponseData":{"PartyId":"32023", "Success":true, "Source":"TBP", "Error":"", "ResponseCode":"200", "Records":[{"StageName":"Closed Won", "AgNo":"AG-119902", "LeaseType":"Tecom / PMLA", "BusinessPark":"DKP", "ContractStartDate":"2017-02-01", "ContractEndDate":"2019-01-31", "Category":"Office", "SubCategory":"Premium Fitted-out Office", "ContractStatus":"Active", "ContractStatusReason":"Active", "IsDownsize":true, "RenewalOpp":"", "Products":[{"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-FL1C1", "ProductName":"DKP-B02-FL1C1", "UnitNumber":"FL1C1"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-163A", "ProductName":"DKP-B02-163A", "UnitNumber":"163A"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-162", "ProductName":"DKP-B02-162", "UnitNumber":"162"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-161", "ProductName":"DKP-B02-161", "UnitNumber":"161"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-160", "ProductName":"DKP-B02-160", "UnitNumber":"160"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-159", "ProductName":"DKP-B02-159", "UnitNumber":"159"}]}, {"StageName":"Closed Won", "AgNo":"AG-117256", "LeaseType":"Tecom / PMLA", "BusinessPark":"DIC", "ContractStartDate":"2016-09-15", "ContractEndDate":"2021-09-14", "Category":"Common Area", "SubCategory":"Corridor", "ContractStatus":"Active", "ContractStatusReason":"Active", "IsDownsize":false, "RenewalOpp":"", "Products":[{"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-305", "ProductName":"DIC-Bldg 05-305", "UnitNumber":"305"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-306", "ProductName":"DIC-Bldg 05-306", "UnitNumber":"306"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-320", "ProductName":"DIC-Bldg 05-320", "UnitNumber":"320"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-318", "ProductName":"DIC-Bldg 05-318", "UnitNumber":"318"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-319", "ProductName":"DIC-Bldg 05-319", "UnitNumber":"319"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-324", "ProductName":"DIC-Bldg 05-324", "UnitNumber":"324"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-321", "ProductName":"DIC-Bldg 05-321", "UnitNumber":"321"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-301", "ProductName":"DIC-Bldg 05-301", "UnitNumber":"301"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-304", "ProductName":"DIC-Bldg 05-304", "UnitNumber":"304"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-302", "ProductName":"DIC-Bldg 05-302", "UnitNumber":"302"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-311", "ProductName":"DIC-Bldg 05-311", "UnitNumber":"311"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-C", "ProductName":"DIC-Bldg 05-C", "UnitNumber":"C"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-323", "ProductName":"DIC-Bldg 05-323", "UnitNumber":"323"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-310", "ProductName":"DIC-Bldg 05-310", "UnitNumber":"310"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-303", "ProductName":"DIC-Bldg 05-303", "UnitNumber":"303"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-221", "ProductName":"DIC-Bldg 05-221", "UnitNumber":"221"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-222", "ProductName":"DIC-Bldg 05-222", "UnitNumber":"222"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-219", "ProductName":"DIC-Bldg 05-219", "UnitNumber":"219"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-307", "ProductName":"DIC-Bldg 05-307", "UnitNumber":"307"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-312", "ProductName":"DIC-Bldg 05-312", "UnitNumber":"312"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-314", "ProductName":"DIC-Bldg 05-314", "UnitNumber":"314"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-220", "ProductName":"DIC-Bldg 05-220", "UnitNumber":"220"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-322", "ProductName":"DIC-Bldg 05-322", "UnitNumber":"322"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-308", "ProductName":"DIC-Bldg 05-308", "UnitNumber":"308"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-309", "ProductName":"DIC-Bldg 05-309", "UnitNumber":"309"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-223", "ProductName":"DIC-Bldg 05-223", "UnitNumber":"223"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-315", "ProductName":"DIC-Bldg 05-315", "UnitNumber":"315"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-313", "ProductName":"DIC-Bldg 05-313", "UnitNumber":"313"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-317", "ProductName":"DIC-Bldg 05-317", "UnitNumber":"317"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-316", "ProductName":"DIC-Bldg 05-316", "UnitNumber":"316"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-224", "ProductName":"DIC-Bldg 05-224", "UnitNumber":"224"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-112", "ProductName":"DIC-Bldg 05-112", "UnitNumber":"112"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-109", "ProductName":"DIC-Bldg 05-109", "UnitNumber":"109"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-110", "ProductName":"DIC-Bldg 05-110", "UnitNumber":"110"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-111", "ProductName":"DIC-Bldg 05-111", "UnitNumber":"111"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-205", "ProductName":"DIC-Bldg 05-205", "UnitNumber":"205"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-201", "ProductName":"DIC-Bldg 05-201", "UnitNumber":"201"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-203", "ProductName":"DIC-Bldg 05-203", "UnitNumber":"203"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-202", "ProductName":"DIC-Bldg 05-202", "UnitNumber":"202"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-204", "ProductName":"DIC-Bldg 05-204", "UnitNumber":"204"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-206", "ProductName":"DIC-Bldg 05-206", "UnitNumber":"206"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-FL2C1", "ProductName":"DIC-Bldg 05-FL2C1", "UnitNumber":"FL2C1"}]}]}} ');
            res.setStatusCode(200);
            return res;
        }
    }

}