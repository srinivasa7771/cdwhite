@isTest
private  class ApplicantDetailControllerTest {
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
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        system.debug('srvcLst----'+srvcLst);
        Contact c = new Contact(Id=conLst[0].Id, mbs__c=500000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3));
        update c;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        system.debug('conLst[0].Id'+conLst[0].Id);
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        system.Debug('request r'+r);
        loc__c aloc = new loc__c(acc__c=accLst[0].Id, IsActive__c=true);
        insert aloc;
        List<g_srvcitm__c> srvitm = [select id from g_srvcitm__c where  srvc__r.Name='Srvc' LIMIT 1];
        system.debug('srvitm=='+srvitm);
        List<g_srvcitm_Status__c> stng1 = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc' LIMIT 1];
        system.debug('stng1=='+stng1);
        g_srvcitm_Status__c stng = new g_srvcitm_Status__c(Id=stng1[0].id, Courier_Stage__c='Collection');
        update stng;
        g_Srvc__c gs = new g_Srvc__c(id=srvcLst[0].Id, stg__c=srvcsettings[0].Id, sdg__c=sd.id,
            sprrole__c='Employee;Non Sponsored;Student;Trainee', sprsta__c='Active', lbl__c='employee service',
            conrol__c='Employee', xoi__c='test', uid__c='155', AddOnSrv__c='inr;vfs;', dsc__c='Employee visa eligibility depends on the size of the facility (lease area) and the business activity.',
            Prk__c='Dubai Design District; Dubai Healthcare City; Dubai International Academic City; Dubai Internet City; Dubai Knowledge Park; Dubai Media City; Dubai Outsource City; Dubai Studio City; Dubai Production City; Dubai Science Park; Emirates Towers',
            AccTp__c='Customer - External; Customer - LAS', ckgsnc__c=true,
                snc__c='CA- Outstanding Dues; CA- Outstanding Dues (Penalties); CA- Required Docs; CA- Violation (Activity); CA- Violation (Guideline); CA- Violation (Licensing Regulation); FIN- Bounced Cheques; FIN- Outstanding Dues; FIN- Required Docs; GSO- Employee head count; GSO- Non Cancellation of unutilised EP; GSO- PO Box Expiry; GSO- Reconciliation Issues; GSO- Residence visa Expiry; GSO- Visit Visa Overstay; IRM- Outstanding Dues (Community Fees); IRM- Required (Renewed Lease AGMT); Lease- Insurance (Non submission); Lease- Insurance Expiry; Lease- Required (Building COMP CERT); Lease- Required (Building Layout SMRY); Lease- Required (Lease Addendum); Lease- Required (Original Lease AGMT); Lease- Required (Renewed Lease AGMT); Lease- Required (Sublease AGMT); Lease- Required (Visa Matrix Form); Lease- Short Term Lease Not Signed; RnL- Approval from DDG; RnL- Blacklist; RnL- Court Order; RnL- Dispute between Shareholders; RnL- National Security Request; RnL- Repossession; RnL- Required Docs');
        update gs;
        system.debug('service aftr update---'+gs);
        g_Req__c rq = new g_Req__c(Id=r.id, xcmbs__c=5000, con__c=c.Id, acc__c=accLst[0].id, srvc__c=gs.id, STA__c='Draft', xadh__c='ptn;');
        update rq;
        system.debug('after request update'+rq);
        g_reqitem__c rqitem = new g_reqitem__c(Name='test', RQ__c=rq.Id, itm__c=srvitm[0].Id, sta__c=stng.Id);
        insert rqitem;
        g_reqDoc__c rdoc= new g_reqDoc__c(Name='test', RQ__c=rq.Id, ats__c=5);
        insert rdoc;
        system.debug('rdoc----'+rdoc);
        g_reqitemDoc__c rrdocitm = new g_reqitemDoc__c(name='test', reqItm__c=rqitem.Id, reqDoc__c=rdoc.Id, mnAts__c=1);
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.ParentId = rdoc.Id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        insert attachment;
        ApexPages.currentPage().getParameters().put('docName', 'Test Attachment for Parent');
        ApexPages.currentPage().getParameters().put('attId', attachment.Id);

        g_Tran__c gt = new g_Tran__c(Acc__c=accLst[0].Id, RQ__c=rq.Id, dt__c=system.today(), TP__c='Payment', STA__c='Completed', md__c='Credit / Debit Card');
        Test.startTest();
        //PageReference myVfPage = Page.grqatt;
        PageReference myVfPage = new PageReference('/apex/grqatt');
        myVfPage.getParameters().put('id', rq.Id);
        Test.setCurrentPage(myVfPage);
        String rid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        system.debug('rid---->'+rid);
        system.debug('g---->'+gs);
        system.debug('sd---->'+sd);

        ApplicantDetailController ac = new ApplicantDetailController();
        ApexPages.currentPage().getParameters().put('id', rq.Id);
        ApexPages.currentPage().getParameters().put('sid', srvcLst[0].Id);
        ac.isgu = true;
        boolean hasSanctions = false;
        ac.existingMemDetail=ac.existingMemDetail;
        ac.membersList=ac.membersList;
        ac.mdList=ac.mdList;
        ac.infoList=ac.infoList;
        //ac.actSeg=ac.actSeg;
        //ac.existingSegandAct=ac.existingSegandAct;
        ac.allSegandAct=ac.allSegandAct;
        ac.activityMap=ac.activityMap;
        ac.segmentMap=ac.segmentMap;
        ac.deleteAttachment();
        ac.deleteAttach();
        ac.getVfsCountriesOptions();
        ac.getAllCountries();
        ac.fetchMemberDetails();
        ApexPages.currentPage().getParameters().put('ammendmentValue', 'Adding New Publishing title');
        Test.setMock(HttpCalloutMock.class, new licenseAmendmentMock());
        //try {
        //ac.fetchAllDDAMembers();
        //} catch (Exception e) {}
        ac.ApplicantContactInfo();
        ac.saveReq();
        ac.getSalutations();
        ac.getAcc();
        ac.validateAndRedirect();
        ac.assignAccount();

       // ac.deleteMemResolDoc();
        //ac.deleteDirResolDoc();
        ac.getReqDocId(rid, 'Test');
        ApexPages.currentPage().getParameters().put('pid', conLst[0].Id);
        ac.applicantInfo();
        hasSanctions=true;
        ac.isgu = false;
        gs.uid__c = 'ail';
        update gs;
        ac.loadData();
        ac.getOccuType();
        ac.getSponsorTypes();
        ac.getMartialStatus();
        ac.getSpokenLanguages();
        ac.saveBO();
        gctlRequ obj = new gctlRequ();
        ac.setCompCtrlMap('componentOne', obj);
        ac.req.id = rq.Id;ac.req.srvc__c =gs.id;
        ac.saveDraft();
        ac.saveDraftR();
        ac.docName = 'test';
        ac.saveAttachment();
        ac.req.Acc__c = [select id from Account limit 1].Id;
        ac.cancelR();
        ac.setDynamicDoclst();
        ac.rerenderDocs();
        ac.authenticateUser();
        ac.getPrmtReqs();
        ac.loadLocations();
        ac.getlstActivities();
        ac.getDedActivities();
        ac.getCountriesOptions();
        ac.edit();
        ac.cancel();
        ApplicantDetailController.getArabicName('test');
        ApplicantDetailController.DEG_Checksum('test', 'test1');
        ApplicantDetailController.checkDoc(rq.Id, 'test');
        ac.getCountryOfBirth();
        ac.getPlaceOfBirthUAE();
        ac.getNationalityVals();
        ac.getReligionVals();
        ac.getCommunityVals();
        ac.getBldgNameVals();
        ac.getQualLevels();
        String responseBody='{"srList":null, "message":null, "licenseInfos":[{"totalShareCapital":100000.00, "totalNumberOfShares":100.00, "parentCompanyRegistrationNo":null, "parentCompanyPermanentAddress":null, "parentCompanyNationality":null, "parentCompanyName":null, "members":[{"type":"Person", "salutation":"Mr.", "registrationNo":null, "registrationDate":null, "proposedNumberOfShares":null, "positions":"Legal Representative;Ultimate Beneficiary;Individual Shareholder", "placeborn":null, "perMobile":"00000000000", "perEmail":"rafeeqkhaja@yopmail.com", "passports":[{"placeOfIssuance":null, "issueDate":"2022-05-16", "expiryDate":"2032-05-15", "docNo":"YB9152818", "countryOfIssuance":null}], "operatingNameArabic":null, "operatingName":null, "nationality":"Italy", "middleNameArabic":null, "middleName":null, "lastNameArabic":"جنوفس", "lastName":"Genovese", "gender":"Male", "firstNameArabic":"مارسيلو فابيانو هانس", "firstName":"Marcello Fabiano Hans", "externalPassportUrl":null, "emiratesId":{"placeOfIssuance":null, "issueDate":null, "expiryDate":null, "docNo":null, "countryOfIssuance":null}, "ddaSFPassportUrl":"https://dcca--staging.sandbox.my.salesforce.com/sfc/p/F700000027P8/a/6F000000OFNj/ROJNcyr1v_gSvhd6DurR1BqfMfx8oSoSFBSrYBBvSg8", "ddaId":"a066F00001eIRcgQAG", "dateOfIncorporation":null, "currentNumberOfShares":25.00, "countryOfIncorporation":null, "cessationDate":null, "birthDate":"1989-09-25", "addresses":[{"type":"HOME", "street":"Rietpark 7, 6300", "postalCode":null, "phone":"00000000003", "mobile":"00000000000", "homePhone":"00000000002", "email":"rafeeqkhaja@yopmail.com", "country":null, "city":"Zug", "buildingNo":null, "area":null}, {"type":"UAE", "street":null, "postalCode":null, "phone":"00000000006", "mobile":"00000000001", "homePhone":"00000000005", "email":"rafeeqkhaja@yopmail.com", "country":null, "city":null, "buildingNo":null, "area":null}], "actionType":null}, {"type":"Corporate", "salutation":null, "registrationNo":"16443", "registrationDate":null, "proposedNumberOfShares":null, "positions":"Auditor", "placeborn":null, "perMobile":"+971-551234567", "perEmail":"sss@gmail.com", "passports":[], "operatingNameArabic":"أرابيان اوتدور منطقة حرة-ذ.م.م", "operatingName":"Arabian Outdoor FZ-LLC", "nationality":"United Arab Emirates", "middleNameArabic":null, "middleName":null, "lastNameArabic":null, "lastName":null, "gender":null, "firstNameArabic":null, "firstName":null, "externalPassportUrl":null, "emiratesId":{"placeOfIssuance":null, "issueDate":null, "expiryDate":null, "docNo":null, "countryOfIssuance":null}, "ddaSFPassportUrl":null, "ddaId":"a06F700000AdUU0IAN", "dateOfIncorporation":"2007-10-30", "currentNumberOfShares":null, "countryOfIncorporation":"United Arab Emirates", "cessationDate":null, "birthDate":null, "addresses":[{"type":"HOME", "street":"0000", "postalCode":"1234", "phone":null, "mobile":"+971-551234567", "homePhone":null, "email":"sss@gmail.com", "country":"United Arab Emirates", "city":"Dubai", "buildingNo":"Dubai Media City", "area":null}, {"type":"UAE", "street":"0000", "postalCode":"1234", "phone":null, "mobile":null, "homePhone":null, "email":"sss@gmail.com", "country":null, "city":"Dubai", "buildingNo":"Dubai Media City", "area":null}], "actionType":null}, {"type":"Person", "salutation":"Mr.", "registrationNo":null, "registrationDate":null, "proposedNumberOfShares":null, "positions":"Director;Manager", "placeborn":"dfdsfsd", "perMobile":"+971-562351086", "perEmail":"xbbdfhd@t.com", "passports":[{"placeOfIssuance":"HYDERABAD", "issueDate":"2015-02-17", "expiryDate":"2025-02-16", "docNo":"M6197928", "countryOfIssuance":null}], "operatingNameArabic":null, "operatingName":null, "nationality":"India", "middleNameArabic":"امتحان", "middleName":null, "lastNameArabic":"امتحان", "lastName":"Gedupuri", "gender":"Male", "firstNameArabic":"امتحان", "firstName":"Ramesh Naidu", "externalPassportUrl":"/sites/DDA_BAUAT/Contacts/2024/RIC-00046011/Passport_Copy.pdf", "emiratesId":{"placeOfIssuance":null, "issueDate":"2023-02-08", "expiryDate":"2025-02-08", "docNo":"634-5435-4354353-5", "countryOfIssuance":null}, "ddaSFPassportUrl":"https://dcca--staging.sandbox.my.salesforce.com/sfc/p/F700000027P8/a/F7000000DYvw/r4zGlXf4qRHXrVMMMAx4mYMGdYUbFDx5UrICoqFLr.4", "ddaId":"a06F700000AdSRgIAN", "dateOfIncorporation":null, "currentNumberOfShares":null, "countryOfIncorporation":null, "cessationDate":null, "birthDate":"2000-02-16", "addresses":[{"type":"HOME", "street":"sdsdgsd", "postalCode":null, "phone":null, "mobile":"+971-562351086", "homePhone":null, "email":"xbbdfhd@t.com", "country":"Afghanistan", "city":"Hyderabad", "buildingNo":"dfgfdg", "area":null}, {"type":"UAE", "street":"sdgdsgs", "postalCode":"500018", "phone":null, "mobile":null, "homePhone":null, "email":"xbbdfhd@t.com", "country":null, "city":"Dubai", "buildingNo":"dfgfdg", "area":null}], "actionType":null}, {"type":"Person", "salutation":"Mr.", "registrationNo":null, "registrationDate":null, "proposedNumberOfShares":null, "positions":"Director", "placeborn":"Al Ain", "perMobile":"+971-0551234567", "perEmail":"ssss@hotmail.com", "passports":[{"placeOfIssuance":"Al Ain", "issueDate":"2020-06-14", "expiryDate":"2025-06-13", "docNo":"NnOP16923", "countryOfIssuance":null}], "operatingNameArabic":null, "operatingName":null, "nationality":"United Arab Emirates", "middleNameArabic":null, "middleName":null, "lastNameArabic":null, "lastName":"ALDARMAKI", "gender":"Male", "firstNameArabic":null, "firstName":"MOHAMED HAMAD ALI SAIF", "externalPassportUrl":null, "emiratesId":{"placeOfIssuance":null, "issueDate":null, "expiryDate":null, "docNo":null, "countryOfIssuance":null}, "ddaSFPassportUrl":null, "ddaId":"a06F700000AdT1lIAF", "dateOfIncorporation":null, "currentNumberOfShares":null, "countryOfIncorporation":null, "cessationDate":null, "birthDate":"1983-09-23", "addresses":[{"type":"HOME", "street":"123", "postalCode":null, "phone":null, "mobile":"+971-0551234567", "homePhone":null, "email":"ssss@hotmail.com", "country":"United Arab Emirates", "city":"AlAin", "buildingNo":null, "area":null}, {"type":"UAE", "street":null, "postalCode":null, "phone":null, "mobile":null, "homePhone":null, "email":"ssss@hotmail.com", "country":null, "city":null, "buildingNo":null, "area":null}], "actionType":null}, {"type":"Person", "salutation":"Mr.", "registrationNo":null, "registrationDate":null, "proposedNumberOfShares":null, "positions":"Secretary;Ultimate Beneficiary;Individual Shareholder", "placeborn":"Frankfort", "perMobile":"+971-00000000000", "perEmail":"0black_mamaba_test@test.com", "passports":[{"placeOfIssuance":"Frankfort", "issueDate":"2022-07-11", "expiryDate":"2032-07-10", "docNo":"C9G2KWC2C", "countryOfIssuance":null}], "operatingNameArabic":null, "operatingName":null, "nationality":"Germany", "middleNameArabic":null, "middleName":null, "lastNameArabic":"جراف", "lastName":"Graf", "gender":"Male", "firstNameArabic":"ستيفان", "firstName":"Stefan", "externalPassportUrl":"/sites/DDA_BAUAT/Contacts/2024/RIC-00039386/Passport_Copy.pdf", "emiratesId":{"placeOfIssuance":null, "issueDate":"2024-01-01", "expiryDate":"2028-01-01", "docNo":"784-1971-1234567-8", "countryOfIssuance":null}, "ddaSFPassportUrl":"https://dcca--staging.sandbox.my.salesforce.com/sfc/p/F700000027P8/a/F7000000DYwa/_fvcGTGWyhM_9jYhl0Gh9PuzGhgNQ12a2BQPmoQG96o", "ddaId":"a066F00001eIRcfQAG", "dateOfIncorporation":null, "currentNumberOfShares":25.00, "countryOfIncorporation":null, "cessationDate":null, "birthDate":"1971-03-22", "addresses":[{"type":"HOME", "street":"Karama", "postalCode":null, "phone":"00000000003", "mobile":"+971-00000000000", "homePhone":"00000000002", "email":"0black_mamaba_test@test.com", "country":"Afghanistan", "city":"Dubai", "buildingNo":"Karama", "area":null}, {"type":"UAE", "street":"123", "postalCode":"500018", "phone":"00000000006", "mobile":"00000000001", "homePhone":"00000000005", "email":"0black_mamaba_test@test.com", "country":null, "city":"Ajman", "buildingNo":"Karama", "area":null}], "actionType":null}, {"type":"Person", "salutation":"Mr.", "registrationNo":null, "registrationDate":null, "proposedNumberOfShares":null, "positions":"Director;Individual Shareholder", "placeborn":"sdfdsfds", "perMobile":"+971-00000000000", "perEmail":"0black_mamaba_test@test.com", "passports":[{"placeOfIssuance":"sdfdsfds", "issueDate":"2022-02-17", "expiryDate":"2032-02-17", "docNo":"TT2044212", "countryOfIssuance":null}], "operatingNameArabic":null, "operatingName":null, "nationality":"Japan", "middleNameArabic":null, "middleName":null, "lastNameArabic":"ناكامورا", "lastName":"Nakamura", "gender":"Male", "firstNameArabic":"توموهيرو", "firstName":"Tomohiro", "externalPassportUrl":"/sites/DDA_BAUAT/Contacts/2024/RIC-00039483/8TIAQ_Passport_Copy_-_Tomohiro_Nakamura.pdf", "emiratesId":{"placeOfIssuance":null, "issueDate":"2023-02-09", "expiryDate":"2025-02-09", "docNo":"784-1985-5926878-8", "countryOfIssuance":null}, "ddaSFPassportUrl":"https://dcca--staging.sandbox.my.salesforce.com/sfc/p/F700000027P8/a/F7000000DYzy/s31yjYTTHKpW5qLCDimXKLfff.c1JtD2Zzt9koDZOUI", "ddaId":"a066F00001fsEa8QAE", "dateOfIncorporation":null, "currentNumberOfShares":10.00, "countryOfIncorporation":null, "cessationDate":null, "birthDate":"1985-12-07", "addresses":[{"type":"HOME", "street":"Residence 1451, Al Barshaa First, Dubai", "postalCode":"11111", "phone":"00000000003", "mobile":"+971-00000000000", "homePhone":"00000000002", "email":"0black_mamaba_test@test.com", "country":"Afghanistan", "city":"Dubai", "buildingNo":"dfgfgfdgdfg", "area":null}, {"type":"UAE", "street":"3-17-5, Takaban, Meguro-ku", "postalCode":"11111", "phone":"00000000006", "mobile":"00000000001", "homePhone":"00000000005", "email":"0black_mamaba_test@test.com", "country":null, "city":"Dubai", "buildingNo":"dfgfgfdgdfg", "area":null}], "actionType":null}, {"type":"Person", "salutation":"Mr.", "registrationNo":null, "registrationDate":null, "proposedNumberOfShares":null, "positions":"Individual Shareholder", "placeborn":null, "perMobile":"00000000000", "perEmail":"0black_mamaba_test@test.com", "passports":[{"placeOfIssuance":null, "issueDate":"2021-03-27", "expiryDate":"2031-03-26", "docNo":"673758936", "countryOfIssuance":null}], "operatingNameArabic":null, "operatingName":null, "nationality":"United States", "middleNameArabic":null, "middleName":null, "lastNameArabic":"خان", "lastName":"Khan", "gender":"Male", "firstNameArabic":"واصف", "firstName":"Wasif Ahmed", "externalPassportUrl":null, "emiratesId":{"placeOfIssuance":null, "issueDate":null, "expiryDate":null, "docNo":null, "countryOfIssuance":null}, "ddaSFPassportUrl":null, "ddaId":"a066F00001fssrLQAQ", "dateOfIncorporation":null, "currentNumberOfShares":15.00, "countryOfIncorporation":null, "cessationDate":null, "birthDate":"1974-09-28", "addresses":[{"type":"HOME", "street":"475 E Kolberg Ct.", "postalCode":"11111", "phone":"00000000003", "mobile":"00000000000", "homePhone":"00000000002", "email":"0black_mamaba_test@test.com", "country":null, "city":"Villa Park", "buildingNo":null, "area":null}, {"type":"UAE", "street":null, "postalCode":null, "phone":"00000000006", "mobile":"00000000001", "homePhone":"00000000005", "email":"0black_mamaba_test@test.com", "country":null, "city":null, "buildingNo":null, "area":null}], "actionType":null}, {"type":"Person", "salutation":"Mr.", "registrationNo":null, "registrationDate":null, "proposedNumberOfShares":null, "positions":"Individual Shareholder", "placeborn":null, "perMobile":"00000000000", "perEmail":"0black_mamaba_test@test.com", "passports":[{"placeOfIssuance":null, "issueDate":"2015-09-19", "expiryDate":"2026-06-19", "docNo":"511024345", "countryOfIssuance":null}], "operatingNameArabic":null, "operatingName":null, "nationality":"United Kingdom", "middleNameArabic":null, "middleName":null, "lastNameArabic":"جوى", "lastName":"Guy", "gender":"Male", "firstNameArabic":"دافيد مايكل", "firstName":"David Michael", "externalPassportUrl":"/sites/DDA_BA/Contacts/2023/RIC-00040620/Valid_Passport_Copy.jpg", "emiratesId":{"placeOfIssuance":null, "issueDate":null, "expiryDate":null, "docNo":null, "countryOfIssuance":null}, "ddaSFPassportUrl":null, "ddaId":"a066F00001fsEWmQAM", "dateOfIncorporation":null, "currentNumberOfShares":10.00, "countryOfIncorporation":null, "cessationDate":null, "birthDate":"1969-04-11", "addresses":[{"type":"HOME", "street":"P.C 135, Knowledge Oasis Muscat KOM5", "postalCode":"53", "phone":"00000000003", "mobile":"00000000000", "homePhone":"00000000002", "email":"0black_mamaba_test@test.com", "country":null, "city":"Muscat", "buildingNo":null, "area":null}, {"type":"UAE", "street":null, "postalCode":null, "phone":"00000000006", "mobile":"00000000001", "homePhone":"00000000005", "email":"0black_mamaba_test@test.com", "country":null, "city":null, "buildingNo":null, "area":null}], "actionType":null}, {"type":"Person", "salutation":"Ms.", "registrationNo":null, "registrationDate":null, "proposedNumberOfShares":null, "positions":"Individual Shareholder", "placeborn":null, "perMobile":"00000000000", "perEmail":"0black_mamaba_test@test.com", "passports":[{"placeOfIssuance":null, "issueDate":"2018-06-19", "expiryDate":"2028-06-19", "docNo":"758191740", "countryOfIssuance":null}], "operatingNameArabic":null, "operatingName":null, "nationality":"Russian Federation", "middleNameArabic":null, "middleName":null, "lastNameArabic":"مايوروفا", "lastName":"Maiorova", "gender":"Female", "firstNameArabic":"كاترينا", "firstName":"Katerina", "externalPassportUrl":null, "emiratesId":{"placeOfIssuance":null, "issueDate":null, "expiryDate":null, "docNo":null, "countryOfIssuance":null}, "ddaSFPassportUrl":null, "ddaId":"a066F00001fsEeAQAU", "dateOfIncorporation":null, "currentNumberOfShares":15.00, "countryOfIncorporation":null, "cessationDate":null, "birthDate":"2000-04-03", "addresses":[{"type":"HOME", "street":"Michurinskiy Prospect, Olimpiyskaya derevnya 1-1-304", "postalCode":"11111", "phone":"00000000003", "mobile":"00000000000", "homePhone":"00000000002", "email":"0black_mamaba_test@test.com", "country":null, "city":"Moscow", "buildingNo":null, "area":null}, {"type":"UAE", "street":null, "postalCode":null, "phone":"00000000006", "mobile":"00000000001", "homePhone":"00000000005", "email":"0black_mamaba_test@test.com", "country":null, "city":null, "buildingNo":null, "area":null}], "actionType":null}], "ManagerInChargerPerMobile":"+971-562351086", "ManagerInChargerPerEmail":"xbbdfhd@t.com", "ManagerInChargerNationalityArabicCountry":"الهند", "ManagerInChargerNationality":"India", "ManagerInChargerName":"Ramesh Naidu Gedupuri", "ManagerInChargerFullNameArabic":"امتحان امتحان امتحان", "licenseNo":"102202", "LicenseIssueDate":"2024-02-08", "LicenseFirstIssueDate":"2022-07-01", "LicenseExpiryDate":"2025-02-09", "LicenseeNameArabic":"فينيفيا منطقة حرة-ذ.م.م", "LicenseeName":"Vinivia FZ-LLC", "licensedActivities":[{"segmentName":"Broadcasting TV", "segmentArabicName":null, "isRelatedtoTitles":false, "isRelatedtoChannel":true, "channelTitles":[], "activityName":"Over the Top Video Content Broadcasting", "activityDdaId":"a1290000007ysrSAAQ", "activityArabicName":null}], "LegalNameArabic":"فينيفيا منطقة حرة-ذ.م.م", "LegalName":"Vinivia FZ-LLC", "LegalFrameworkName":"Free Zone Limited Liability Company", "LegalFrameworkLegalFrameworkArabic":"شركة منطقة حرة ذات مسؤولية محدودة", "CountryofIncorporationName":"United Arab Emirates", "CountryofIncorporationArabi;;cCountryName":"الامارات العربية المتحدة", "companyDdaId":"a066F00001fsElfQAE"}], "isSuccess":true}';
            DDAMembersWrapper ref = (DDAMembersWrapper) System.JSON.deserialize(responseBody, DDAMembersWrapper.class);

        Test.stopTest();
    }
    static testmethod void test2() {

        g_Req__c req=new g_Req__c();
        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        List<g_srvcitm__c> srvitm = [select id from g_srvcitm__c where srvc__r.Name='Srvc' LIMIT 1];
        system.debug('srvitm=='+srvitm);
        List<g_srvcitm_Status__c> stng1 = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc' LIMIT 1];
        system.debug('stng1=='+stng1);
        g_srvcitm_Status__c stng = new g_srvcitm_Status__c(Id=stng1[0].id, Courier_Stage__c='Collection');
        update stng;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        g_Srvc__c gs = new g_Srvc__c(id=srvcLst[0].Id, stg__c=srvcsettings[0].Id, sdg__c=sd.id,
            sprrole__c='Employee;Non Sponsored;Student;Trainee', sprsta__c='Active', lbl__c='employee service',
            conrol__c='Employee', xoi__c='test', uid__c='155', AddOnSrv__c='inr;vfs;', dsc__c='Employee visa eligibility depends on the size of the facility (lease area) and the business activity.',
            Prk__c='Dubai Design District; Dubai Healthcare City; Dubai International Academic City; Dubai Internet City; Dubai Knowledge Park; Dubai Media City; Dubai Outsource City; Dubai Studio City; Dubai Production City; Dubai Science Park; Emirates Towers',
            AccTp__c='Customer - External; Customer - LAS', ckgsnc__c=true,
                snc__c='CA- Outstanding Dues; CA- Outstanding Dues (Penalties); CA- Required Docs; CA- Violation (Activity); CA- Violation (Guideline); CA- Violation (Licensing Regulation); FIN- Bounced Cheques; FIN- Outstanding Dues; FIN- Required Docs; GSO- Employee head count; GSO- Non Cancellation of unutilised EP; GSO- PO Box Expiry; GSO- Reconciliation Issues; GSO- Residence visa Expiry; GSO- Visit Visa Overstay; IRM- Outstanding Dues (Community Fees); IRM- Required (Renewed Lease AGMT); Lease- Insurance (Non submission); Lease- Insurance Expiry; Lease- Required (Building COMP CERT); Lease- Required (Building Layout SMRY); Lease- Required (Lease Addendum); Lease- Required (Original Lease AGMT); Lease- Required (Renewed Lease AGMT); Lease- Required (Sublease AGMT); Lease- Required (Visa Matrix Form); Lease- Short Term Lease Not Signed; RnL- Approval from DDG; RnL- Blacklist; RnL- Court Order; RnL- Dispute between Shareholders; RnL- National Security Request; RnL- Repossession; RnL- Required Docs');
        update gs;
        //PageReference myVfPage = Page.grqatt;
        PageReference myVfPage = new PageReference('/apex/grqatt');
        myVfPage.getParameters().put('sid', gs.Id);
        Test.setCurrentPage(myVfPage);
        String sid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sid'));
        Account acc = new Account(Id=Label.TecomAccnt);
        update acc;
        Test.startTest();
        ApplicantDetailController ac;
        ac = new ApplicantDetailController(new Apexpages.StandardController(new g_Srvc__c()));
        ac = new ApplicantDetailController();
        String err = ac.err;
        String pg =ac.pg;
        Contact emp =ac.emp;
        String lcl = ac.lcl;
        String dd  =ac.dd;
        boolean trueDoc = ac.trueDoc;
        String imageBase64 = ac.imageBase64;
        Boolean codeCheck =ac.codeCheck;
        String sitekey=ac.sitekey;
        String response=ac.response;
        boolean noSRfg = ac.noSRfg;
        String rqNo = ac.rqNo;
        String renewalRqId = ac.renewalRqId;
        list<g_req__c> lstActiveReq = ac.lstActiveReq;
        Boolean nCou = ac.nCou;
        Boolean nRV = ac.nRV;
        ac.getAtts();
        ac.getDedActsJson(); //
        ApexPages.currentPage().getParameters().put('cName', 'testing');
        ac.updateComponent();
        Test.setMock(HttpCalloutMock.class, new licenseAmendmentMock());
        ApexPages.currentPage().getParameters().put('ammendmentValue', 'Adding New Broadcasting Channels');
        ac.fetchAllDDAMembers();
        ApexPages.currentPage().getParameters().put('ammendmentValue', 'Remove Broadcasting Channels');
        ac.fetchAllDDAMembers();

        ApexPages.currentPage().getParameters().put('ammendmentValue', 'Add Activity');
        ac.fetchAllDDAMembers();
        ApexPages.currentPage().getParameters().put('ammendmentValue', 'Add Segment');
        ac.fetchAllDDAMembers();

        //ApexPages.currentPage().getParameters().put('ammendmentValue', 'Remove Segment');
        //ac.fetchAllDDAMembers();
        Test.stopTest();
    }

    static testmethod void test3() {

        List<Account> accLst = [select id, lc__c from Account where Name='Acc' LIMIT 1];
        //g_Req__c r =[select id from g_Req__c limit 1];

        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        system.debug('srvcLst----'+srvcLst);
        Contact c = new Contact(Id=conLst[0].Id, mbs__c=500000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3));
        update c;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        system.debug('conLst[0].Id'+conLst[0].Id);
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        DccaBatchUtil.LAResponseWrapper r1 = new DccaBatchUtil.LAResponseWrapper();
        r.xadtx4__c = JSON.serialize(r1);
        r.xcamc__c = 'Add';
        r.xcddocs__c = 'test';
        update r;
        system.Debug('request r'+r);

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new licenseAmendmentMock2());
        ApexPages.currentPage().getParameters().put('jsonVal', '{ "licenseNos": [ "'+accLst[0].lc__c+'" ] }');
        ApplicantDetailController ac = new ApplicantDetailController(new Apexpages.StandardController(new g_Srvc__c()));
        ac.Acc = accLst[0];
        ac.req = r;
        ac.fetchCalculationFees();
        Test.stopTest();
    }

    public class licenseAmendmentMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            system.debug(req.getEndPoint());
            system.debug(req);
            system.debug(Label.LA_DDA_End_Point);
            if (req.getEndpoint().endsWith('getLicenseInfo')) {
                DDAMembersWrapper wr = new DDAMembersWrapper();
                DDAMembersWrapper.LicenseInfos li = new DDAMembersWrapper.LicenseInfos();
                DDAMembersWrapper.Members m = new DDAMembersWrapper.Members();
                DDAMembersWrapper.LicensedActivities l = new DDAMembersWrapper.LicensedActivities();
                l.activityName = 'Test';
                l.isRelatedtoTitles = true;
                l.isRelatedtoChannel = true;
                DDAMembersWrapper.ChannelTitles c = new DDAMembersWrapper.ChannelTitles();
                l.channelTitles = new List<DDAMembersWrapper.ChannelTitles>();
                l.channelTitles.add(c);
                m.positions = 'Director';
                li.members = new List<DDAMembersWrapper.Members>();
                li.members.add(m);
                li.licensedActivities = new List<DDAMembersWrapper.LicensedActivities>();
                li.licensedActivities.add(l);
                wr.licenseInfos = new List<DDAMembersWrapper.LicenseInfos>();
                wr.licenseInfos.add(li);
                res.setBody(JSON.serialize(wr));
            } else if (req.getEndpoint().endsWith('onbordingapi')) {
                List<SegmentsActivitiesController.SegWrapper> sw = new List<SegmentsActivitiesController.SegWrapper>();
                SegmentsActivitiesController.SegWrapper w = new SegmentsActivitiesController.SegWrapper();
                SegmentsActivitiesController.ActWrapper a = new SegmentsActivitiesController.ActWrapper();
                w.Activities = new List<SegmentsActivitiesController.ActWrapper>();
                w.activities.add(a);
                sw.add(w);
                res.setBody(JSON.serialize(sw));
            }

            res.setStatusCode(200);
            return res;
        }
    }

    public class licenseAmendmentMock2 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            //if (req.getEndPoint() == Label.LA_DDA_End_Point) {
            DccaBatchUtil.LAResponseWrapper la = new DccaBatchUtil.LAResponseWrapper();
            DccaBatchUtil.srList s = new DccaBatchUtil.srList();
            DccaBatchUtil.SrAttachments att = new DccaBatchUtil.SrAttachments();
            s.srAttachments = new List<DccaBatchUtil.SrAttachments>();
            s.srAttachments.add(att);
            la.SrList = new List<DccaBatchUtil.srList>();
            la.srList.add(s);

            res.setBody(JSON.serialize(la));
            //}
            res.setStatusCode(200);
            return res;
        }
    }
}