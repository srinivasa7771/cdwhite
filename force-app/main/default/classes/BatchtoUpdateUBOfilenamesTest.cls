@isTest
private class BatchtoUpdateUBOfilenamesTest {
     @testSetup static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
    }

    static testmethod void test1() {
       g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
           cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
           docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
         List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        List<g_srvcitm__c> srvitm = [select id from g_srvcitm__c where srvc__r.Name='Srvc' LIMIT 1];
        List<g_srvcitm_Status__c> stng = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc' LIMIT 1];
        g_Srvc__c gs = new g_Srvc__c(id=srvcLst[0].Id, stg__c=srvcsettings[0].Id, sdg__c=sd.id,
            sprrole__c='Employee;Non Sponsored;Student;Trainee', sprsta__c='Active', lbl__c='employee service',
            conrol__c='Employee', xoi__c='test', uid__c='209', AddOnSrv__c='inr;vfs;', dsc__c='Employee visa eligibility depends on the size of the facility (lease area) and the business activity.',
            Prk__c='Dubai Design District; Dubai Healthcare City; Dubai International Academic City; Dubai Internet City; Dubai Knowledge Park; Dubai Media City; Dubai Outsource City; Dubai Studio City; Dubai Production City; Dubai Science Park; Emirates Towers',
            AccTp__c='Customer - External; Customer - LAS', ckgsnc__c=true,
                snc__c='CA- Outstanding Dues; CA- Outstanding Dues (Penalties); CA- Required Docs; CA- Violation (Activity); CA- Violation (Guideline); CA- Violation (Licensing Regulation); FIN- Bounced Cheques; FIN- Outstanding Dues; FIN- Required Docs; GSO- Employee head count; GSO- Non Cancellation of unutilised EP; GSO- PO Box Expiry; GSO- Reconciliation Issues; GSO- Residence visa Expiry; GSO- Visit Visa Overstay; IRM- Outstanding Dues (Community Fees); IRM- Required (Renewed Lease AGMT); Lease- Insurance (Non submission); Lease- Insurance Expiry; Lease- Required (Building COMP CERT); Lease- Required (Building Layout SMRY); Lease- Required (Lease Addendum); Lease- Required (Original Lease AGMT); Lease- Required (Renewed Lease AGMT); Lease- Required (Sublease AGMT); Lease- Required (Visa Matrix Form); Lease- Short Term Lease Not Signed; RnL- Approval from DDG; RnL- Blacklist; RnL- Court Order; RnL- Dispute between Shareholders; RnL- National Security Request; RnL- Repossession; RnL- Required Docs');
        update gs;
        g_Req__c r=testData.reqCrt(accLst[0].Id, gs.Id, conLst[0].Id, 'Open', srvcsettings[0].reqq__c);
        g_reqitem__c rqitem = new g_reqitem__c(Name='test', RQ__c=r.Id, itm__c=srvitm[0].Id, sta__c=stng[0].Id);
        insert rqitem;
        g_reqDoc__c rdoc= new g_reqDoc__c(Name='test', RQ__c=r.Id, ats__c=5);
        insert rdoc;
        g_reqitemDoc__c rrdocitm = new g_reqitemDoc__c(name='test', reqItm__c=rqitem.Id, reqDoc__c=rdoc.Id, mnAts__c=1);
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.ParentId = rdoc.Id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        insert attachment;
        Test.startTest();
        Database.executeBatch(new BatchtoUpdateUBOfilenames(), 5);
        Test.stopTest();
    }

}