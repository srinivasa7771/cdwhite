@isTest
public class obClgCtlTest {
    @testSetup static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        //gStg__c crtstng = testData.createSetting('test', 'testvalue');

    }
    static testmethod void test1() {
      g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
          cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
          docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<g_Req__c> rqLst = new List<g_Req__c>();
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id, uid__c from g_Srvc__c where Name='Srvc' LIMIT 1];
        srvcLst[0].uid__c = '322';
        update srvcLst;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, conLst[0].Id, 'Open', srvcsettings[0].reqq__c);
        g_Req__c r1=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, conLst[0].Id, 'Open', srvcsettings[0].reqq__c);
        r.xceml__c = 'test@test.com';
        r.ldmob__c = '0000000';
        r1.xceml__c = 'test@test.com';
        r1.ldmob__c = '0000000';
        rqLst.add(r);rqLst.add(r1);
        update rqLst;
        Task tsk = new Task();
        tsk.whatid=r.id;
        tsk.Subject='subject';
        tsk.Subject='subject';
        tsk.OwnerId = Userinfo.getUserId();
        insert tsk;
        Test.startTest();
          ApexPages.CurrentPage().getParameters().put('rid', r.id);
         obClgCtl ctl = new obClgCtl();
         ctl.crtTask();
        Test.stopTest();
    }
    static testmethod void test2() {
      g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
          cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
          docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<g_Req__c> rqLst = new List<g_Req__c>();
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, conLst[0].Id, 'Open', srvcsettings[0].reqq__c);
        g_Req__c r1=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, conLst[0].Id, 'Open', srvcsettings[0].reqq__c);
        r.xceml__c = 'test@test.com';
        r.ldmob__c = '0000000';
        r1.xceml__c = 'test@test.com';
        r1.ldmob__c = '0000000';
        rqLst.add(r);rqLst.add(r1);
        update rqLst;
        Task tsk = new Task();
        tsk.whatid=r.id;
        tsk.Subject='subject';
        tsk.Subject='subject';
        tsk.OwnerId = Userinfo.getUserId();
        insert tsk;
        Test.startTest();
          ApexPages.CurrentPage().getParameters().put('rid', r.id);
         obClgCtl ctl = new obClgCtl();
         ctl.cltp = 'rmd';
         ctl.rmdDt = '09/09/2021';
         ctl.logCtg = 'Contacted and assigned to PRM';
         ctl.crtTask();
         ctl.tsk = new Task();
         ctl.cltp = 'cn';
         ctl.reason = 'tst';
         ctl.crtTask();
        Test.stopTest();
    }
}