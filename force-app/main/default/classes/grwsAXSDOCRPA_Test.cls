@isTest
public class grwsAXSDOCRPA_Test {

     @testSetup static void setup() {
        testdata.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
    }

    static testmethod void testPost() {
        Test.startTest();

          g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
              cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
              docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true limit 1];
        g_Srvc__c gs = new g_Srvc__c(id=srvcLst[0].Id, stg__c=srvcsettings[0].Id, sdg__c=sd.id,
            sprrole__c='Employee;Non Sponsored;Student;Trainee', sprsta__c='Active', lbl__c='employee service',
            conrol__c='Employee', xoi__c='test', uid__c='155', AddOnSrv__c='inr;vfs;', dsc__c='Employee visa eligibility depends on the size of the facility (lease area) and the business activity.',
            Prk__c='Dubai Design District; Dubai Healthcare City; Dubai International Academic City; Dubai Internet City; Dubai Knowledge Park; Dubai Media City; Dubai Outsource City; Dubai Studio City; Dubai Production City; Dubai Science Park; Emirates Towers',
            AccTp__c='Customer - External; Customer - LAS', ckgsnc__c=true,
                snc__c='CA- Outstanding Dues; CA- Outstanding Dues (Penalties); CA- Required Docs; CA- Violation (Activity); CA- Violation (Guideline); CA- Violation (Licensing Regulation); FIN- Bounced Cheques; FIN- Outstanding Dues; FIN- Required Docs; GSO- Employee head count; GSO- Non Cancellation of unutilised EP; GSO- PO Box Expiry; GSO- Reconciliation Issues; GSO- Residence visa Expiry; GSO- Visit Visa Overstay; IRM- Outstanding Dues (Community Fees); IRM- Required (Renewed Lease AGMT); Lease- Insurance (Non submission); Lease- Insurance Expiry; Lease- Required (Building COMP CERT); Lease- Required (Building Layout SMRY); Lease- Required (Lease Addendum); Lease- Required (Original Lease AGMT); Lease- Required (Renewed Lease AGMT); Lease- Required (Sublease AGMT); Lease- Required (Visa Matrix Form); Lease- Short Term Lease Not Signed; RnL- Approval from DDG; RnL- Blacklist; RnL- Court Order; RnL- Dispute between Shareholders; RnL- National Security Request; RnL- Repossession; RnL- Required Docs');
        update gs;

        system.debug('srvcLst---'+srvcLst);
        List<g_srvcitm__c> srvitm = [select id from g_srvcitm__c where     srvc__r.Name='Srvc' LIMIT 1];
        g_srvcitm__c gsi = new g_srvcitm__c(id=srvitm[0].Id, srvc__c=gs.Id);
        update gsi;
        system.debug('gsi---'+gsi);
        List<g_srvcitm_Status__c> stng = [select id, itm__r.srvc__c from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc' LIMIT 1];
        system.debug('srvitm---'+srvitm);
        system.debug('stng'+stng);
        g_Req__c r=testData.reqCrt(accLst[0].id, gs.Id, conLst[0].id, 'Open', srvcsettings[0].reqq__c);
        system.debug('first r---'+r.name);
        g_reqitem__c rqitem = new g_reqitem__c(Name='test', RQ__c=r.Id, itm__c=srvitm[0].Id, sta__c=stng[0].Id);
        insert rqitem;
        g_reqDoc__c rdoc= new g_reqDoc__c(Name='test', RQ__c=r.Id, ats__c=5);
        insert rdoc;
        system.debug('rdoc----'+rdoc);
        list<Attachment> attchlst = new list<Attachment>();
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.ParentId = rdoc.Id;
        attachment.Name ='Test Attachment for Parent';
        attachment.ContentType = 'application/pdf';
        attachment.Body = b;
           Blob b1 = Blob.valueOf('Test Data');
        Attachment attachment1 = new Attachment();
        attachment1.ParentId = rdoc.Id;
        attachment1.Name ='Test Attachment for Parent';
        attachment1.Body = b1;
        attchlst.add(attachment);
         attchlst.add(attachment1);
        insert attchlst;
         g_reqitemDoc__c rrdocitm = new g_reqitemDoc__c(name='test', lbl__c='test', reqItm__c=rqitem.Id, Req__c=true, reqAts__c=true, reqDoc__c=rdoc.Id, mnAts__c=1);
        insert rrdocitm;
        system.debug('rrdocitm----'+rrdocitm);
         list<g_reqitemDoc__c> ritdoc = [Select Id, Name, reqDoc__c, Tp__c, reqDoc__r.RQ__r.name, reqDoc__r.Name, reqItm__r.itmCd__c, Req__c, reqAts__c, upOk__c, reqDoc__r.Id From g_reqitemDoc__c];
        system.debug('ritdoc'+ritdoc);
        grwsAXSDOCRPA grws = new grwsAXSDOCRPA();
        grwsAXSDOCRPA.AttachmentWrapper gattch = new grwsAXSDOCRPA.AttachmentWrapper();
        string attCode = gattch.attCode;
          grwsAXSDOCRPA.loadReqDocs(r.name);
          Test.setMock(HttpCalloutMock.class, new MockLicRenewalBatchGen1());
         RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/abc/xyz/';
        request.httpMethod = 'POST';
        RestContext.request = request;
        //grwsAXSDOCRPA.doPost();
        Test.stopTest();

    }

    Public class MockLicRenewalBatchGen implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"respCode":"200", "status":"Sucess", "respMsg":"1", "SRN":"1", AxsId":"1"}');
            res.setStatusCode(200);
            System.debug('res====='+res);
            return res;
        }
    }
          Public class MockLicRenewalBatchGen1 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"dptData":[{"expPriority":"200", "reqNum":"Sucess"}]}');
            res.setStatusCode(200);
            System.debug('res====='+res);
            return res;
        }
    }

}