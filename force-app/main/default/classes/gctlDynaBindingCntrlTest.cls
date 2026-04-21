@IsTest
private class gctlDynaBindingCntrlTest {
    @testSetup static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        gStg__c crtstng = testData.createSetting('test', 'testvalue');

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
        srvcsettings[0].formFields__c = 'xltp__c=License type;xcamc__c=Amendment Category;xcfn__c=Company name (English);xcna__c=Company name (Arabic);xdedln__c=License number;xcpid__c=Initial Approval Date;xcped__c=Approval Expiry Date;xcsp__c=Parent License Trade No.;xcsfn__c=Parent License Trade Name;xzn__c=Site;hpr__c=Business Activities;xchn__c=Name;xcmob__c=Mobile;xadtx4__c=Notes;xceml__c;';
        srvcsettings[0].dfjs__c = '[{ "field": "xltp__c", "STA": [{ "v": "New Company", "fields": "xcpid__c; xcped__c;xcamc__c;xcsp__c;xcsfn__c;", "display": "none" }, { "v": "New Company", "fields": "xcfn__c=Approved trade name (English);xcna__c=Approved trade name (Arabic);xdedln__c=Initial approval number ", "display": "block" }, { "v": "Relocation from Dubai Main Land", "fields": "xcpid__c; xcped__c;xcamc__c;xcsp__c;xcsfn__c", "display": "none" }, { "v": "New Branch", "fields": "xcamc__c", "display": "none" }, { "v": "New Branch", "fields": "xcfn__c=Approved trade name (English);xcna__c=Approved trade name (Arabic);xdedln__c=Initial approval number;;xcpid__c=Initial approval date;xcped__c=Approval expiry date;xcsp__c=Parent license trade number;xcsfn__c=Parent license trade name", "display": "block" }, { "v": "Renewal", "fields": "xcpid__c; xcped__c;xcamc__c;xcsp__c;xcsfn__c", "display": "none" }, { "v": "Renewal With Amendment", "fields": "xcpid__c; xcped__c;xcsp__c;xcsfn__c", "display": "none" }, { "v": "Renewal With Amendment", "fields": "xcamc__c", "display": "block" }, { "v": "Amendment", "fields": "xcpid__c; xcped__c;xcsp__c;xcsfn__c", "display": "none" }, { "v": "Shift Location", "fields": "xcpid__c; xcped__c;xcamc__c;xcsp__c;xcsfn__c", "display": "none" }, { "v": "Cancellation", "fields": "xcpid__c; xcped__c;xcamc__c;xcsp__c;xcsfn__c", "display": "none" }] }]';
        update srvcsettings;
        srvcLst[0].stg__c = srvcsettings[0].Id;
        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        system.debug('conLst[0].Id'+conLst[0].Id);
        g_Req__c req =testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        Test.startTest();
            //PageReference vfpage = Page.grqstatus;
             PageReference vfpage = new PageReference('/apex/grqstatus');
            vfpage.getParameters().put('id', req.Id);
            Test.setCurrentPage(vfpage);
            gctlDynaBindingCntrl controller = new gctlDynaBindingCntrl();
        Test.stopTest();
    }

}