@isTest
public class ObTmplCtlTest {
    @testSetup static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        //Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        User adminU = [Select Id, Name from User where Name = 'System Admin' LIMIT 1 ];
        Contact c = new Contact(accountid=a.id, Salutation = 'Mr.', firstName = 'fName', lastName = 'lName', STA__c = 'Active',
                                rol__c = 'Student', p__c = 'Pass1',
                                pid__c = date.today(), ped__c = date.today().addYears(1),
                                Owner = adminU, ptsta__c='Eligible');
        insert c;
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        g_Req__c r=testData.reqCrt(a.Id, s.Id, null, 'Draft', stg.reqq__c);
        List<Contact> conLst = [select id, accountid, Salutation, firstName, lastName, STA__c, rol__c, p__c, pid__c, ped__c, Ownerid, ptsta__c from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id, lc__c from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        g_srvcitm__c si = new g_srvcitm__c(srvc__c=srvcLst[0].id, name='Change of Secretary', cd__c='ma', lbl__c='Change of Secretary', ord__c=1);
        insert si;
        string jsonStr = '{ "licenseNos": [ "'+accLst[0].lc__c+'" ] }';
        string dummyRespCs ='{"srList":null, "message":null, "licenseInfos":[{"totalShareCapital":null, "totalNumberOfShares":null, "parentCompanyRegistrationNo":"CHE-112.095.930", "parentCompanyPermanentAddress":null, "parentCompanyNationality":"Switzerland", "parentCompanyName":"Geberit International Sales AG", "members":[{"type":"Corporate", "salutation":null, "registrationNo":"CHE-112.095.930", "registrationDate":null, "proposedNumberOfShares":null, "positions":"Parent", "placeborn":null, "perMobile":"00000000000", "perEmail":"0black_m   <... truncated: 7693 ...>   ameworkArabic":"شركة منطقة حرة ذات مسؤولية محدودة", "CountryofIncorporationName":"Switzerland", "CountryofIncorporationArabicCountryName":"سويسرا", "companyDdaId":"a066F00000vUe6JQAS"}], "isSuccess":true}';
        String json = '{"serviceRequests":[{"members":[{"visaId":"00PH1000008T4FdMAK", "salutation":"Mr.", "positions":"Manager", "placeborn":"JODHPUR", "perMobile":"+971-645645645", "perEmail":"m@a.com", "passports":[{"placeOfIssuance":"DUBAI", "issueDate":"2015-04-16", "expiryDate":"2025-04-15", "docNo":"D6112136"}], "nationality":"India", "lastName":"Vyas", "gender":"M", "firstName":"Goklendra", "emiratesId":{"issueDate":"2024-02-05", "expiryDate":"2024-02-28", "docNo":"545-3543-5435435-4"}, "EIDfId":"00PH1000008T4JTMA0", "EIDbId":"00PH1000008T4JOMA0", "birthDate":"1990-04-15", "attachmentId":"00PH1000008T3wdMAC", "addresses":[{"type":"UAE", "street":"fsdfds", "postalCode":"435435", "city":"Dubai", "buildingNo":"sfsdfds", "area":"fsdfdsf"}, {"type":"HOME", "street":"sdfdsf", "country":"India", "city":"sdfsdf"}], "actionType":"ADD"}], "isPaid":false}]}}';
        User u = createUser();
        g_Req__c req=  new g_req__c();//testData.reqCrt(accLst[0].Id, srvcLst[0].Id, conLst[0].Id, 'Open', srvcsettings[0].reqq__c);
        req.acc__c=accLst[0].Id;
        req.srvc__c=srvcLst[0].Id;
        req.xadtx4__c=dummyRespCs;
        req.xadtx3__c=json;
        req.sta__c='';
        //req.ownerid = u.Id;
        req.xcamc__c = 'Change of General Manager';
        insert req;
        system.debug('----request---'+req);
        g_reqDoc__c rdoc= new g_reqDoc__c(Name='test - Goklendra Vyas', RQ__c=req.Id, ats__c=5);
        insert rdoc;

    }
    static testmethod void test1() {

        user u = [select id from user where Email = 'mctesty.sahni@axsstg.com'];
        g_Req__c req = new g_Req__c();
        for (g_Req__c r : [Select id, Name, xadtx3__c, xadtx4__c, rmob__c, STA__c from g_Req__c]) {
            system.debug('----request---'+r);
            if (r.xadtx3__c != null) {
                req = r;
            }
        }
        List<g_reqDoc__c> rd = [Select id, Name from g_reqDoc__c];
        Test.startTest();
        // system.runAs(u) {
        System.debug('=='+req.Id);
        ApexPages.currentPage ().getParameters ().put ('id', req.Id);
        apexpages.currentpage().getparameters().put('mid', rd[0].id);
        System.debug('====pg=='+apexpages.currentpage().getparameters().get('id'));
        ObTmplCtl ctrl = new ObTmplCtl();
        ctrl.adhoc3Data =(LARequestWrapper)System.JSON.deserialize(req.xadtx3__c, LARequestWrapper.class);
        ctrl.memberInfo();
        ctrl.fetchMembers();
        ctrl.directorsInfo();
        ctrl.gmFullName = 'test';
        ctrl.gmPPNo = 'test';
        ctrl.gmNationality = 'test';
        ObTmplCtl.Member mm = new ObTmplCtl.Member();
        mm.name = 'testName';
        mm.position = 'Director';
        //}
        test.stoptest();
    }
    static user createUser() {
        user u = [Select id from user where id =: userInfo.getUserId()];
        system.runAs(u) {
            //Create account
            Account act = new Account(Name = 'Sample Account', OwnerId = userInfo.getUserId());
            Database.insert(act);

            //Create contact
            Contact contact1 = new Contact(FirstName = 'Test', Lastname = 'McTesty', AccountId = act.Id, Email = 'mctesty.sahni@axsstg.com');
            Database.insert(contact1);

            //Create Portal User
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name='W' Limit 1];
            User user1 = new User(
                UserName = contact1.Email,
                FirstName = contact1.FirstName,
                LastName = contact1.LastName,
                Alias = 'test123', Department__c= 'Finance',
                email = contact1.Email,
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                EmailEncodingKey = 'UTF-8',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
            return user1;
        }
        return null;
    }

    public class MockInsBatchGen implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('dummyResp');
            //res.setBody('[{"serviceRequest":[{"status":null, "servPdNm":null, "service":"CPU", "serNm":"CPU", "refAXS":"152344320230410", "permSd":null, "permEd":null, "nocType":null, "nameOD":null, "memInfo":{"role":"Manager", "passportInfo":{"passportNumber":"N7330120", "passportIssueDate":"2018-02-06", "passportExpiryDate":"2028-02-06", "isExpired":false}, "nationalIdNo":null, "identityName":"Venkata Ratnam Dhanemkulu", "identityId":"a06D000000Wl1nAIAR", "emiratesIdInfo":{"isExpired":false, "emiratesIdNumber":"784-2001-1234566-1", "emiratesIdIssueDate":"2023-03-26", "emiratesIdExpiryDate":"2024-04-10"}, "contactDetail":{"Nationality":"India", "mobileNumber":"543038688", "middleName":null, "lastName":"Dhanemkulu", "gender":"Male", "firstName":"Venkata Ratnam", "emailAddress":"mohammad.imtiyazuddin-v@dham.ae", "dateOfBirth":"1988-06-23"}, "addressDetailsInUAE":{"residencePhone":null, "POBoxNo":"54546", "officePhoneNo":null, "mobileNo":null, "emailAddress":null, "city":"68568", "address":"68567567ghgf"}, "addressDetailsInHomeCountryPermanent":{"residencePhone":null, "POBoxNo":"500033", "officePhoneNo":null, "mobileNo":"", "emailAddress":null, "country":"", "city":"Hyderabad", "address":"2, Saikrupa Nilayam, 55/A, Journalist Colony, Jubilee Hills"}}, "locAdd":null, "licenseNo":"91212", "isSucces":null, "isPaid":null, "extAXS":"a0E0p00000E12J7EAJ", "errorMessage":null, "dccapermtNo":"", "cFRReason":null, "cFRNotes":null, "auditedData":null, "attName":null, "attaFlag":null, "attach":null}]}');
            //  res.setBody('{"serviceRequest":[{"service":"a156F000006ui51QAA", "refAxs":"43084220180408", "locAdd":"R/C22-Outdoor Seating, Bldg 10, Ground 0, Dubai Media City", "licenseNo":"30849", "isSucces":true, "isPaid":true, "extAxs":"a0EN000000FBKmzMAH", "errorMessage":null, "attaFlag":null, "attach":null, "dccapermtNo":"12323"}]}');
            res.setStatusCode(200);
            return res;
        }
    }
}