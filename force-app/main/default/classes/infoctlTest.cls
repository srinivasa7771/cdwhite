@isTest
public class infoctlTest {

    /*static testMethod void doTest() {
        boolean blV;String sV;
        Test.startTest();
            testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_reqMbr__c objM = new g_reqMbr__c();
            //-----------------------------------------------
            gctlReq.mbr m = new gctlReq.mbr(objM);
            m.m=m.m;

            blV=m.isnw;
            m.adjust(r);

            gStg__c stg1 = new gStg__c();
            stg1.name = 'guprfl';
            stg1.Checkbox_Value__c = true;
            stg1.Currency_Value__c = 12;
            stg1.Number_Value__c = 43;
            stg1.Text_Value__c = '00e20000001Ak2YAAS';
            insert stg1;
            Contact c = new Contact();
            c.idtxt__c = '2730';
            c.rp__c = 'qwdqwed';
            c.lastName = 'khan';
            insert c;

            Contact c1 = new Contact();
            c1.rp__c = 'qwdqwed';
            c1.lastName = 'khan';
            c1.Spon__c = c.id;
            c1.rol__c = 'Spouse';
            insert c1;
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
            System.currentPageReference().getParameters().put('id', '2730');
            System.currentPageReference().getParameters().put('enc', '27301111');
           ApexPages.StandardController stc = new ApexPages.StandardController(r);
               infoctl obj = new infoctl(stc);

            obj.rq=obj.rq;obj.srv=obj.srv;obj.Acc=obj.Acc;obj.md=obj.md;
            obj.pg=obj.pg;obj.pgHide=obj.pgHide;obj.ispu=obj.ispu;

            g_Req__c rqNew = new g_Req__c();
            obj=new infoctl(new ApexPages.StandardController(rqNew));
            ApexPages.CurrentPage().getParameters().put('sid', s.Id);
            obj=new infoctl(new ApexPages.StandardController(rqNew));

            obj.authenticate();

            obj.authenticateUser();
            infoctl.DEG_Checksum('test', 'test');

        Test.stopTest();
    }*/
      @testSetup static void setup() {

        testData.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);

    }
    static testmethod void test1() {
        infoctl info=new infoctl();
        info.empid=info.empid;

        info.sid=info.sid;
        info.pid=info.pid;
        info.emp=info.emp;
        info.lc=info.lc;
        info.srv=info.srv;
        info.Acc=info.Acc;
        info.pg=info.pg;
        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
         List<g_srvc_settings__c> srvcsettings = [select id, reqq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        system.debug('srvcLst----'+srvcLst);
          g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, conLst[0].Id, 'Open', srvcsettings[0].reqq__c);
          ApexPages.StandardController stc = new ApexPages.StandardController(r);
               infoctl grd = new infoctl(stc);
         //PageReference myVfPage = Page.InfoBkp;
        PageReference myVfPage = new PageReference('/apex/InfoBkp');
        myVfPage.getParameters().put('id', r.id);
         myVfPage.getParameters().put('sid', r.srvc__c);
        Test.setCurrentPage(myVfPage);
        string sid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sid'));
        grd.authenticate();
        infoctl.DEG_Checksum('test', 'test');
       grd.crtPay('open', 'Cash');

    }

}