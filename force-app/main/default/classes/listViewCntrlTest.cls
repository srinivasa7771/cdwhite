@isTest(SeeAllData=false)
public class listViewCntrlTest {
   /*
    @testSetup static void setup() {
        testData.init();

        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s = new g_Srvc__c(Name='Srvc', lbl__c='Srvc', stg__c=stg.Id, uid__c='001',
            actv__c=true, ckgsnc__c=true, Prk__c='Dubai Internet City', AccTp__c='Customer - External',
            ConRol__c='Employee', ConSTA__c='Active', payMd__c='Customer Deposit; Cash; Credit / Debit Card',
            Category__c='Employees Services', Sub_Category__c='Renewal Visa', Milestone_Stage__c='Ep;Medical;Rp;',
            Milestone_SLA__c='10;2;6');
        insert s;

        list<g_srvcitm__c> itms = new list<g_srvcitm__c>();
        itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
            slaXP__c=2, ord__c=1, Tp__c='Service Item', cd__c='ep', ilv__c='ofl:ok;ofl:c;',
            dcr__c ='Approval from DM:Approval from DM;Catering Service Agreement:Catering Service Agreement;NOC from LandLord:NOC from LandLord;Service Provider License Copy:Service Provider License Copy;Signed Catering Permit Guidelines:Signed Catering Permit Guidelines;',
            Name='rp', lbl__c='rp', Req__c=true, aln__c=true, mxcnt__c=1,
            rv__c=true, prcEdt__c=false, DscApp__c=true, EXP__c=true, KF__c=0,
            scN__c=10, cN__c=5, smN__c=1, spChN__c=1, scXP__c=1, cXP__c=1,
            smXP__c=1, spChXP__c=1, xf__c='xf__c;xfid__c;xfed__c;xrp__c;xrpid__c;xrped__c;xui__c;xr__c;xcmbso__c;xcmbs__c;xcmao__c;xcma__c;xcmoao__c;xcmoa__c;xcmtao__c;xcmta__c;xef__c;'));
        itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
            slaXP__c=2, ord__c=2, Tp__c='Service Item', cd__c='rp', Name='pnt',
            lbl__c='pnt', Req__c=false, mxcnt__c=1, rv__c=false, prcEdt__c=true,
            DscApp__c=false, EXP__c=false, KF__c=0, scN__c=10, cN__c=5, smN__c=1,
            spChN__c=1, scXP__c=1, cXP__c=1, smXP__c=1, spChXP__c=1, xf__c=''));
        insert itms;

        list<g_srvcitm_Status__c> sta = new list<g_srvcitm_Status__c>();
        for (g_srvcitm__c i:itms) {
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='EP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='rv', name='n', lbl__c='n', Tp__c='Open', rqSTA__c='',
                clm__c=false, clmA__c=0, rfnd__c=false, rfndA__c=0, Shift_At__c='Payment',
                Shift_Items__c='rp;md;', exsyst__c='dcca:Closed;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='EP',
                slaa__c='Completed', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='cc', name='ook', lbl__c='ook', Tp__c='Completed',
                rqSTA__c='', clm__c=false, clmA__c=0, rfnd__c=false, rfndA__c=0,
                Shift_At__c='Payment', Shift_Items__c='rp;md;', exsyst__c='dcca:Closed;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c = 'Medical',
                slaa__c='Parallel', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='c', name='c', lbl__c='c', Tp__c='Cancelled',
                rqSTA__c='Cancelled', clm__c=true, clmA__c=1, rfnd__c=true, rfndA__c=1,
                Shift_At__c='Payment', Shift_Items__c='rp;md;', exsyst__c='dcca:Closed;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='RP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='ok', name='ok', lbl__c='ok', Tp__c='Completed',
                rqSTA__c='Completed', clm__c=false, clmA__c=0, rfnd__c=false,
                rfndA__c=0, Shift_At__c='Payment', Shift_Items__c='rp;md;', exsyst__c='dcca:Closed;'));
        }
        insert sta;

        Account a=testData.accCrt(false);
        a.ORACLE_PARTY_ID__c = '1234';  a.lc__c='999999';
        update a;

        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c rq=testData.reqCrt(a.Id, s.Id, emp.Id, 'In Process', stg.reqq__c);
        rq.rtacn__c = '1234';rq.xoln__c='055372654'; rq.rmob__c='0512341234'; rq.STA__c ='In Process' ;
        update rq;

         g_Req__c rq2=testData.reqCrt(a.Id, s.Id, emp.Id, 'Under Review', stg.reqq__c);
        update rq2;

       gctlReqpy.itm itm = new gctlReqpy.itm(rq.Items__r[0]);itm.I=itm.I;itm.s=itm.s;itm.r=itm.r;
            g_Tran__c T = new g_Tran__c(Acc__c=rq.Acc__c, RQ__c=rq.Id, TP__c='Payment');gctlReqpy.Trn trn = new gctlReqpy.Trn(T); trn.T=trn.T;
        boolean blV;String sV;
        ApexPages.currentPage().getParameters().put('rc', 'y');
            ApexPages.currentPage().getParameters().put('c', 'test');
            gctlReqpy obj=new gctlReqpy(new ApexPages.StandardController(rq)); obj.pyMthd = 'pyMthd';
            obj.rq=obj.rq;obj.pt=obj.pt;obj.pDsc=obj.pDsc;obj.pgHide=obj.pgHide;obj.ispu=obj.ispu;sV=obj.lcl;
            obj.T=obj.T;obj.Is=obj.Is;obj.pyMthds=obj.pyMthds;obj.pyMthd=obj.pyMthd;obj.pdfConfirm=obj.pdfConfirm;obj.payDone=obj.payDone;blV=obj.nD;
            obj.pyMthd='Customer Deposit';obj.save();
            obj.pyMthd='Cash';obj.save();
            obj.pyMthd='Cheque';obj.save();
            obj.pyMthd='Credit / Debit Card';obj.save();
            obj.pyMthd='';obj.save();

            gctlReqpyChk objChk = new gctlReqpyChk();
            objChk.pgHide=objChk.pgHide;objChk.ispu=objChk.ispu;sV=objChk.lcl;objChk.T=objChk.T;
            objChk.Chk();
    }

    static testMethod void testbatch() {

        Test.startTest();

        listViewCntrl listV = new listViewCntrl();
        listV.selCatg='001, 002, 003, 004, 021, 078, 040, 020';
        listV.getCatOpt();
        listV.getItmOpt();
        listV.getStsOpt();
        listV.selItm = 'ep';
        listV.selStat='rv, n, cc, ccc, v, vcc';
        listV.queryReq();
        Test.stopTest();
    }

    */

    static testMethod void doTest() {
        boolean blV;String sV;
           Test.startTest();
               testData.init();
            /*g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_reqMbr__c objM = new g_reqMbr__c();

            gStg__c paidParking = new gStg__c(name='AdditionalParking', Text_Value__c = '154');
            insert paidParking;
            //----------------------------------------
            gctlReqpy.itm itm = new gctlReqpy.itm(r.Items__r[0]);itm.I=itm.I;itm.s=itm.s;itm.r=itm.r;
            g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment');gctlReqpy.Trn trn = new gctlReqpy.Trn(T); trn.T=trn.T;
            s.stg__r=stg;r.srvc__r=s;
            ApexPages.currentPage().getParameters().put('rc', 'y');
            ApexPages.currentPage().getParameters().put('c', 'test');
            gctlReqpy obj=new gctlReqpy(new ApexPages.StandardController(r)); obj.pyMthd = 'pyMthd';
            obj.rq=obj.rq;obj.pt=obj.pt;obj.pDsc=obj.pDsc;obj.pgHide=obj.pgHide;obj.ispu=obj.ispu;sV=obj.lcl;
            obj.T=obj.T;obj.Is=obj.Is;obj.pyMthds=obj.pyMthds;obj.pyMthd=obj.pyMthd;obj.pdfConfirm=obj.pdfConfirm;obj.payDone=obj.payDone;blV=obj.nD;
            obj.pyMthd='Customer Deposit';obj.save();

            //obj.CnclPayment();
            //--------------------------------------------

        */

        listViewCntrl listV = new listViewCntrl();
        listV.selCatg='001, 002, 003, 004, 021, 078, 040, 020';
        listV.getCatOpt();
        listV.getItmOpt();
        listV.getStsOpt();
        listV.selItm = 'ep';
        listV.selStat='rv, n, cc, ccc, v, vcc';
        listV.queryReq();

           Test.stopTest();
    }

}