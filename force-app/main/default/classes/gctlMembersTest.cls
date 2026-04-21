@isTest(SeeAllData=false)
public class gctlMembersTest {

    @testSetup
    static void setup() {/*MS*/
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
        List<g_srvcitm__c> srvitm = [select id from g_srvcitm__c where srvc__r.Name='Srvc' LIMIT 1];
        List<g_srvcitm_Status__c> stng = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc' LIMIT 1];

        Contact c = new Contact(Id=conLst[0].Id, mbs__c=500000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3));
        update c;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);

        g_reqitem__c rqitem = new g_reqitem__c(Name='License_Registration_Request', RQ__c=r.Id, itm__c=srvitm[0].Id, sta__c=stng[0].Id);
        insert rqitem;

        g_reqDoc__c rdoc= new g_reqDoc__c(Name='Signed AOA', RQ__c=r.Id, ats__c=5);
        g_reqDoc__c rdoc2= new g_reqDoc__c(Name='Testdoc', RQ__c=r.Id, ats__c=5);

        List<g_reqDoc__c> lstRdocs = new List<g_reqDoc__c>();
        lstRdocs.add(rdoc);lstRdocs.add(rdoc2);
        insert lstRdocs;

        g_reqitemDoc__c rrdocitm = new g_reqitemDoc__c(name='Application Form', lbl__c='Application Form', reqItm__c=rqitem.Id, reqDoc__c=rdoc.Id, mnAts__c=2, Req__c=true, reqAts__c=true);
        g_reqitemDoc__c rrdocitm2 = new g_reqitemDoc__c(name='Declaration of Appointment as General Manager',
            lbl__c='Declaration of Appointment as General Manager', reqItm__c=rqitem.Id, reqDoc__c=rdoc.Id,
            mnAts__c=2, Req__c=true, reqAts__c=true);
        List<g_reqitemDoc__c> lstRqItmDocs = new List<g_reqitemDoc__c>();
        lstRqItmDocs.add(rrdocitm);lstRqItmDocs.add(rrdocitm2);
        insert lstRqItmDocs;

        Attachment a = new Attachment(name='General Manager Declaration', parentId=r.Id, body= Blob.valueOf('TEST'));
        insert a;

        gctlMembers gm = new gctlMembers();
        gm.rq = r;
        gm.init_mem();

        Test.startTest();
        gm.imageBase64 = 'TEST1334344343';
        gm.docName = 'Trade license copy.jpg';
        gm.saveAttachment();

        gm.docName = 'Signed AOA';
        gm.AOADoc = 'TEST1334344343';
        gm.saveAttachment1();
        gm.docName = 'Testdoc';
        gm.saveAttachment1();

        gm.savegmDec1();

        gm.delDocID = a.Id;
        gm.deleteAOADocs();

        gm.componentOne = new gctlRequ();
        try{ gm.saveOpen1(); }catch (Exception ex) {}

        stng[0].name ='AOA RIC Submited';
        stng[0].cd__c ='v';
        update stng[0];
        gm.submitDocstoPrm1();

        Test.stopTest();

    }

     static testmethod void test2() {

         g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
             cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
             docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
         insert sd;
         List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
         List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
         List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
         List<g_srvcitm__c> srvitm = [select id from g_srvcitm__c where srvc__r.Name='Srvc' LIMIT 1];
         List<g_srvcitm_Status__c> stng = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc' LIMIT 1];

         Contact c = new Contact(Id=conLst[0].Id, mbs__c=500000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3));
         update c;
         List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
         Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
         g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);

         g_reqitem__c rqitem = new g_reqitem__c(Name='License_Registration_Request', RQ__c=r.Id, itm__c=srvitm[0].Id, sta__c=stng[0].Id);
         insert rqitem;

         gctlMembers gm = new gctlMembers();
         gm.rq = r;

         r.xadtx4__c = '{"workorders":null, "usrName":null, "SubCategory":null, "StageName":null, "shareHoldersType":"memAndCorp", "shareDetails":{"totalShares":1000, "shareValue":1000}, "shareCapital":null, "scWorkid":null, "respMsg":null, "requestid":null, "quotes":null, "proposedLegalForm":null, "Products":null, "productName":null, "prmPhone":null, "prmMobile":null, "prmLastName":null, "prmFirstName":null, "prmEmail":null, "pcRegNo":null, "pcDOI":null, "paymentSchedules":null, "parentCompany":null, "oppId":null, "onbReqid":null, "ofcPhone":null, "ofcEmail":null, "ofcCountry":null, "ofcAddress":null, "noofShares":null, "nationality":null, "nameResWorkid":null, "members":[{"uboType":null, "street":"fff", "stockExchangeListed":null, "sh":"200", "security":null, "salutation":null, "rpNo":null, "rpExpDate":null, "role":"Shareholder, Board of Director, Legal Representative", "postalCode":null, "placeissued":"erer", "pIssuedDate":"24/07/2015", "phoneno":"", "pExpDate":"23/07/2025", "passportNo":"r4343434", "passportId":"00P1s000003cVqzEAE", "nationality":"Algeria", "mobile":"554480164", "mname":null, "mailingStreet":null, "mailingPostalCode":null, "mailingCountry":null, "mailingCity":null, "lnameAr":null, "lname":"SINGH", "legals":null, "gender":"F", "fullName":"ZAAKIRAH SINGH", "fnameAr":null, "fname":"ZAAKIRAH", "email":"tets@tets.com", "eid":null, "eExpDate":null, "dob":"10/03/1999", "ctgCode1":"sh1", "ctgCode":"sh", "ctg":"Shareholder", "cshType":null, "corpORind":"ind", "contryCode":null, "conid":null, "city":"ffd", "birthplace":null, "address":null}, {"uboType":null, "street":null, "stockExchangeListed":null, "sh":"300", "security":null, "salutation":null, "rpNo":null, "rpExpDate":null, "role":"Shareholder", "postalCode":null, "placeissued":null, "pIssuedDate":null, "phoneno":null, "pExpDate":null, "passportNo":"4343434", "passportId":null, "nationality":"United Arab Emirates", "mobile":"554480164", "mname":null, "mailingStreet":null, "mailingPostalCode":null, "mailingCountry":null, "mailingCity":null, "lnameAr":null, "lname":"Facebook", "legals":null, "gender":null, "fullName":null, "fnameAr":null, "fname":null, "email":"tets@tets.com", "eid":null, "eExpDate":null, "dob":"01/12/2000", "ctgCode1":"sh3", "ctgCode":"sh", "ctg":"Shareholder", "cshType":null, "corpORind":"corp", "contryCode":null, "conid":null, "city":null, "birthplace":null, "address":"fdfdfdfd"}, {"uboType":null, "street":null, "stockExchangeListed":null, "sh":"300", "security":null, "salutation":null, "rpNo":null, "rpExpDate":null, "role":"Shareholder, Ultimate Beneficiary", "postalCode":null, "placeissued":null, "pIssuedDate":null, "phoneno":null, "pExpDate":null, "passportNo":"434343", "passportId":null, "nationality":"Albania", "mobile":"554481064", "mname":null, "mailingStreet":null, "mailingPostalCode":null, "mailingCountry":null, "mailingCity":null, "lnameAr":null, "lname":"Oracle", "legals":null, "gender":null, "fullName":null, "fnameAr":null, "fname":null, "email":"tets@tets.com", "eid":null, "eExpDate":null, "dob":"04/12/2000", "ctgCode1":"sh1", "ctgCode":"sh1", "ctg":"Shareholder", "cshType":null, "corpORind":"corp", "contryCode":null, "conid":null, "city":null, "birthplace":null, "address":"ddd"}, {"uboType":null, "street":"ddd", "stockExchangeListed":null, "sh":"200", "security":null, "salutation":null, "rpNo":null, "rpExpDate":null, "role":"Shareholder, Board of Director", "postalCode":null, "placeissued":"rr", "pIssuedDate":"14/12/2016", "phoneno":"", "pExpDate":"13/12/2026", "passportNo":"r43434", "passportId":"", "nationality":"Algeria", "mobile":"554481064", "mname":null, "mailingStreet":null, "mailingPostalCode":null, "mailingCountry":null, "mailingCity":null, "lnameAr":null, "lname":"ARMSTRONG", "legals":null, "gender":"M", "fullName":"JESSE ARMSTRONG", "fnameAr":null, "fname":"JESSE", "email":"tets@tets.com", "eid":null, "eExpDate":null, "dob":"07/10/1981", "ctgCode1":"sh3", "ctgCode":"sh", "ctg":"Shareholder", "cshType":null, "corpORind":"ind", "contryCode":null, "conid":null, "city":"dd", "birthplace":null, "address":null}, {"uboType":null, "street":"fff", "stockExchangeListed":null, "sh":null, "security":null, "salutation":null, "rpNo":null, "rpExpDate":null, "role":"General Manager, Board of Director, General Manager", "postalCode":null, "placeissued":"COCHIN", "pIssuedDate":"07/10/2015", "phoneno":"", "pExpDate":"06/10/2025", "passportNo":"N3311986", "passportId":"00P1s000003cVqBEAU", "nationality":"India", "mobile":"554481064", "mname":null, "mailingStreet":null, "mailingPostalCode":null, "mailingCountry":null, "mailingCity":null, "lnameAr":null, "lname":"MANIYANGATT", "legals":null, "gender":"F", "fullName":"AMBILI MANIYANGATT", "fnameAr":null, "fname":"AMBILI", "email":"tets@tets.com", "eid":null, "eExpDate":null, "dob":"29/08/1990", "ctgCode1":"sh4", "ctgCode":"gm", "ctg":"General Manager", "cshType":null, "corpORind":"ind", "contryCode":null, "conid":null, "city":"ffff", "birthplace":null, "address":null}, {"uboType":"Ultimately owns or controls whether directly or indirectly 25% or more of the shares or voting rights;Holds the right, directly or indirectly, to appoint or remove a majority of the board of directors;Has the right to exercise, or actually exercises, significant influence or control over the corporate body;Exercises ultimate control over the management;Controls the corporate body1", "street":null, "stockExchangeListed":null, "sh":null, "security":null, "salutation":null, "rpNo":null, "rpExpDate":null, "role":"Ultimate Beneficiary, Ultimate Beneficiary, Board of Director", "postalCode":null, "placeissued":"DEHRADUN", "pIssuedDate":"02/04/2018", "phoneno":"", "pExpDate":"03/04/2028", "passportNo":"S0223000", "passportId":"", "nationality":"India", "mobile":"554481064", "mname":null, "mailingStreet":null, "mailingPostalCode":null, "mailingCountry":null, "mailingCity":null, "lnameAr":null, "lname":"SINGH", "legals":"2-3", "gender":"M", "fullName":"VEERENDRA SINGH", "fnameAr":null, "fname":"VEERENDRA", "email":"tets@tets.com", "eid":null, "eExpDate":null, "dob":"01/07/1994", "ctgCode1":"sh4", "ctgCode":"ub", "ctg":"Ultimate Beneficiary", "cshType":null, "corpORind":"ind", "contryCode":null, "conid":null, "city":null, "birthplace":null, "address":null}, {"uboType":null, "street":"fsdf", "stockExchangeListed":null, "sh":null, "security":null, "salutation":null, "rpNo":null, "rpExpDate":null, "role":"Board of Director", "postalCode":null, "placeissued":"fdfdf", "pIssuedDate":"20/12/2022", "phoneno":"", "pExpDate":"21/12/2012", "passportNo":"K6667789", "passportId":"00P1s000003cVrwEAE", "nationality":"India", "mobile":"554481064", "mname":null, "mailingStreet":null, "mailingPostalCode":null, "mailingCountry":null, "mailingCity":null, "lnameAr":null, "lname":"SARKAR", "legals":null, "gender":"M", "fullName":"ZOHEB AHMED SARKAR", "fnameAr":null, "fname":"ZOHEB AHMED", "email":"test@test.com", "eid":null, "eExpDate":null, "dob":"30/01/1991", "ctgCode1":"gm", "ctgCode":"bd", "ctg":"Board of Director", "cshType":null, "corpORind":"ind", "contryCode":null, "conid":null, "city":"fdsfds", "birthplace":null, "address":null}], "licenseType":null, "lcExpdate":null, "issuingAuthority":null, "isSuccess":null, "Invoices":null, "hseWorkid":null, "fullNameAr":null, "fullName":null, "documents":null, "dedLicense":null, "dedLeaseType":null, "dedCompanyName":null, "dedActivities":null, "DDAReqNo":null, "currentpgid":"pg4", "crmOppId":null, "crmAccName":null, "crmAccId":null, "countryOfIncorp":null, "ContractStatusReason":null, "ContractStatus":null, "ContractStartDate":null, "ContractEndDate":null, "Category":null, "caseid":null, "BusinessPark":null, "businessName3":null, "businessName2":null, "businessName1":null, "brandWorkid":null, "AgNo":null, "actvities":null}';
         r.xadh__c = 'sh1;sh2;sh3;sh4;gm;ub;bd1;';
         update r;
         gm.submitToPRM();

         Test.startTest();

         stng[0].cd__c ='v';
         update stng[0];

         r.os__c = 'Name Approval Re-Review';
         update r;
         srvitm[0].cd__c = 'na';
         update srvitm[0];
         gm.submitToVerification();

         gctlMembers.D d= new gctlMembers.D();
         d.DocName = 'test'; d.DocLabel = 'test'; d.DocType = 'test'; d.attId = 'test';
         d.attName = 'test'; d.tmpt = 'test'; d.isOptional = false;
         gm.savecsd1();
         gm.saveLandDoc();
             gm.deleteLandDoc('abd');
         gm.generateRqItem(new set<String>{'abd'});
         Test.stopTest();
     }

}