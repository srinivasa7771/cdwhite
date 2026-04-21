@isTest
public class grCtrlCustProfUpTest {
    @testSetup static void setup() {

        testData.init();
        Account a = testData.accCrt(false);
        User adminU = [Select Id, Name from User where Name = 'System Admin'
            LIMIT 1
        ];
        Contact c = new Contact(accountid = a.id, Salutation = 'Mr.', firstName = 'fName', lastName = 'lName', STA__c = 'Active',
            rol__c = 'Student', p__c = 'Pass1',
            pid__c = date.today(), ped__c = date.today().addYears(1),
            Owner = adminU, ptsta__c = 'Eligible');
        insert c;
        testData.bRulesReqCrt();
        testData.bRulesItemCrt();
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        g_Req__c r = testData.reqCrt(a.Id, s.Id, c.Id, 'Draft', stg.reqq__c);
        r.xintp__c = 'Basic';
        r.xcmob__c = '+971555555555';
        r.xceml__c = 'test.test@test.com';
        r.xard__c = true;
        r.xceidid__c = '784197653865890';
        update r;
        List < Contact > conLst = [select id, accountid, Salutation, firstName, lastName, STA__c, rol__c, p__c, pid__c, ped__c, Ownerid, ptsta__c from Contact where firstName = 'fName'
            LIMIT 1
        ];
        List < Account > accLst = [select id, lc__c from Account where Name = 'Acc'
            LIMIT 1
        ];
        List < g_Srvc__c > srvcLst = [select id from g_Srvc__c where Name = 'Srvc'
            LIMIT 1
        ];
        List < g_srvc_settings__c > srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name = 'srvcStg'
            LIMIT 1
        ];
        g_srvcitm__c si = new g_srvcitm__c(srvc__c = srvcLst[0].id, name = 'Member Attributes', cd__c = 'ma', lbl__c = 'Member Attributes', ord__c = 1);
        insert si;
        List < g_srvcitm_Status__c > stsList = new List < g_srvcitm_Status__c > ();
        g_srvcitm_Status__c ss = new g_srvcitm_Status__c(itm__c = si.id, name = 'Submitted for Verification', cd__c = 'v', lbl__c = 'Submitted for Verification');
        stsList.add(ss);
        g_srvcitm_Status__c ss1 = new g_srvcitm_Status__c(itm__c = si.id, name = 'Cancelled', cd__c = 'c', lbl__c = 'Cancelled');
        stsList.add(ss1);
        insert stsList;


        string jsonStr = '{"methodname":"membersupdate", "data":{"licenseNum":"' + accLst[0].lc__c + '"}}';
        string dummyRespCs = '{ "responseCode": { "responseCode": 200, "errorMessage": "Success" }, "identityInfo": [{ "role": "Manager", "passportInfo": { "passportNumber": "R5475115", "passportIssueDate": "2017-05-17", "passportExpiryDate": "2027-05-16", "isExpired":true }, "nationalIdNo": null, "identityName": "Mada Radhakrishnamurthy", "identityId": "a066F00001eItWmQAK", "emiratesIdInfo": { "emiratesIdNumber": null, "emiratesIdIssueDate": null, "emiratesIdExpiryDate": null }, "contactDetail": { "nationality": "India", "mobileNumber": "util_reset@test.com", "middleName": null, "lastName": "Radhakrishnamurthy", "gender": "Male", "firstName": "Mada", "emailAddress": "util_reset@test.com", "dateOfBirth": "8-Jan-1978" }, "addressDetailsInUAE": { "residencePhone": "util_reset@test.com", "POBoxNo": null, "officePhoneNo": "util_reset@test.com", "mobileNo": "util_reset@test.com", "emailAddress": "util_reset@test.com", "city": null, "address": null }, "addressDetailsInHomeCountryPermanent": { "residencePhone": "util_reset@test.com", "POBoxNo": "11111", "officePhoneNo": "util_reset@test.com", "mobileNo": "util_reset@test.com", "emailAddress": "util_reset@test.com", "country": null, "city": "HYDERABAD", "address": "HYDERABAD" } }, { "role": "Manager", "passportInfo": { "passportNumber": "S7749882", "passportIssueDate": "2019-07-12", "passportExpiryDate": "2023-07-11" }, "nationalIdNo": null, "identityName": "Venkata Ramana Prasad Surineni", "identityId": "a066F00001eItWoQAK", "emiratesIdInfo": { "emiratesIdNumber": "95333", "emiratesIdIssueDate": "2019-07-01", "emiratesIdExpiryDate": "2024-07-12" }, "contactDetail": { "nationality": "India", "mobileNumber": "+9713701231000", "middleName": null, "lastName": "Surineni", "gender": "Male", "firstName": "Venkata Ramana Prasad", "emailAddress": "joh@tecom.com", "dateOfBirth": "5-Jun-1974" }, "addressDetailsInUAE": { "residencePhone": "util_reset@test.com", "POBoxNo": null, "officePhoneNo": "util_reset@test.com", "mobileNo": "+971525994513", "emailAddress": "joh@tecom.com", "city": null, "address": null }, "addressDetailsInHomeCountryPermanent": { "residencePhone": "util_reset@test.com", "POBoxNo": null, "officePhoneNo": "util_reset@test.com", "mobileNo": "+9713701231000", "emailAddress": "joh@tecom.com", "country": null, "city": "ANDRA PRADESH", "address": "ANDRA PRADESH" } }, { "role": "Ultimate Beneficiary", "passportInfo": { "passportNumber": "S7749882", "passportIssueDate": "2019-07-12", "passportExpiryDate": "2023-07-11" }, "nationalIdNo": null, "identityName": "Mada Radhakrishnamurthy", "identityId": "a6o6F0000009qSJQAY", "emiratesIdInfo": null, "contactDetail": { "nationality": "India", "mobileNumber": "+9713701231000", "middleName": "", "lastName": "Mada Radhakrishnamurthy", "gender": "Male", "firstName": "", "emailAddress": null, "dateOfBirth": "1978-01-08" }, "addressDetailsInUAE": { "residencePhone": null, "POBoxNo": null, "officePhoneNo": null, "mobileNo": null, "emailAddress": null, "city": "HYDERABAD", "address": "HYDERABAD" }, "addressDetailsInHomeCountryPermanent": { "residencePhone": null, "POBoxNo": null, "officePhoneNo": null, "mobileNo": "+9713701231000", "emailAddress": null, "country": null, "city": null, "address": null } }, { "role": "Ultimate Beneficiary", "passportInfo": { "passportNumber": "U4795230", "passportIssueDate": "2020-08-24", "passportExpiryDate": "2023-06-23" }, "nationalIdNo": null, "identityName": "Vijaya lakshmi Mada", "identityId": "a6o6F0000009qSKQAY", "emiratesIdInfo": null, "contactDetail": { "nationality": "India", "mobileNumber": null, "middleName": "", "lastName": "Vijaya lakshmi Mada", "gender": "Female", "firstName": "", "emailAddress": null, "dateOfBirth": "1981-04-09" }, "addressDetailsInUAE": { "residencePhone": null, "POBoxNo": null, "officePhoneNo": null, "mobileNo": null, "emailAddress": null, "city": "HYDERABAD", "address": "HYDERABAD" }, "addressDetailsInHomeCountryPermanent": { "residencePhone": null, "POBoxNo": null, "officePhoneNo": null, "mobileNo": null, "emailAddress": null, "country": null, "city": null, "address": null } }] }';
        User u = createUser();
        g_Req__c req = new g_req__c();
        req.acc__c = accLst[0].Id;
        req.srvc__c = srvcLst[0].Id;
        req.xadtx4__c = dummyRespCs;
        req.xadtx3__c = dummyRespCs;
        req.sta__c = '';
        req.ownerid = u.Id;
        insert req;

        g_reqDoc__c doc = new g_reqDoc__c();
        doc.RQ__c = r.id;
        doc.name = 'Passport';
        insert doc;

        g_reqDoc__c docEm = new g_reqDoc__c();
        docEm.RQ__c = r.id;
        docEm.name = 'Emirates';
        insert docEm;

        g_reqDoc__c docRic = new g_reqDoc__c();
        docRic.RQ__c = r.id;
        docRic.name = 'RIC';
        insert docRic;

    }
    static testmethod void test1() {

        mdWrapper mdw = new mdWrapper();
        mdWrapper.ContactDetail con = new mdWrapper.ContactDetail();
        con.dateOfBirth = 'Today';
        con.Nationality = 'India';
        con.middleName = 'mn';
        con.lastName = 'ln';
        con.gender = 'Male';
        con.firstName = 'fn';
        con.emailAddress = 'test@test.com';
        con.mobileNumber = '+971 500000000';
        con.isMobilePhoneVerified = true;
        con.mobilePhoneVerificationDatetime = System.now();
        con.isEmailVerified = true;
        con.emailVerificationDatetime = System.now();
        con.firstNameArabic = 'Axs';
        con.lastNameArabic = 'DHAM';
        con.visitedUAE = true;
        con.birthCountry = 'UAE';
        con.placeOfBirth = 'Dubai';
        mdWrapper.ResponseCode res = new mdWrapper.ResponseCode();
        res.responseCode = 200;
        res.errorMessage = 'Success';
        mdWrapper.AddressDetailsInUAE addUAE = new mdWrapper.AddressDetailsInUAE();
        addUAE.address = 'Dubai';
        addUAE.POBoxNo = '1234';
        addUAE.officePhoneNo = '12345';
        addUAE.mobileNo = 'util_reset@test.com';
        addUAE.emailAddress = 'test@test.com';
        addUAE.city = 'Dubai';
        addUAE.address = 'Dubai';
        addUAE.residencePhone = '9080';
        mdWrapper.AddressDetailsInHomeCountryPermanent addHome = new mdWrapper.AddressDetailsInHomeCountryPermanent();
        addHome.address = 'Dubai';
        addHome.POBoxNo = '1234';
        addHome.officePhoneNo = '12345';
        addHome.mobileNo = 'util_reset@test.com';
        addHome.emailAddress = 'test@test.com';
        addHome.city = 'Dubai';
        addHome.address = 'Dubai';
        addHome.residencePhone = '9080';
        addHome.country = 'India';
        mdWrapper.EmiratesIdInfo eid = new mdWrapper.EmiratesIdInfo();
        eid.emiratesIdExpiryDate = '';
        eid.emiratesIdIssueDate = 'Today';
        eid.emiratesIdNumber = '12345';
        eid.isExpired = true;
        mdWrapper.PassportInfo pp = new mdWrapper.PassportInfo();
        pp.passportExpiryDate = 'Today';
        pp.passportIssueDate = '';
        pp.passportNumber = 'PPnumber';
        pp.isExpired = true;
        pp.passportIssuePlace = 'Dubai';
        mdWrapper.IdentityInfo iden = new mdWrapper.IdentityInfo();
        iden.role = 'Manager';
        iden.identityName = 'test Identity';
        iden.nationalIdNo = '1234';
        iden.identityId = 'a06';
        iden.passportInfo = pp;
        iden.addressDetailsInHomeCountryPermanent = addHome;
        iden.addressDetailsInUAE = addUAE;
        iden.contactDetail = con;
        iden.emiratesIdInfo = eid;
        g_Req__c req = new g_Req__c();
        g_Req__c req2 = new g_Req__c();
        for (g_Req__c r: [Select id, Name, xadtx3__c, xadtx4__c, rmob__c, STA__c from g_Req__c]) {
            if (r.xadtx3__c != null) {
                req = r;
            } else {
                req2 = r;
            }
        }
        user u = [select id from user where Email = 'mctesty.sahni@axsstg.com'];
        req2.OwnerId = u.Id;
        req2.xdei__c = '12345';
        req2.rmob__c = '+971-5052323323';
        update req2;

        Test.startTest();
        system.runAs(u) {
            ApexPages.currentPage().getParameters().put('id', req.Id);
            grCtrlCustProfUp ctrl = new grCtrlCustProfUp();
            ctrl.mobileNumberJson = '{"countrycode_rmob__c":"+971"}';
            ctrl.info = (mdWrapper.IdentityInfo) System.JSON.deserialize(req.xadtx4__c, mdWrapper.IdentityInfo.class);
            ctrl.infoUpdated = (mdWrapper.IdentityInfo) System.JSON.deserialize(req.xadtx3__c, mdWrapper.IdentityInfo.class);
            PageReference pageRef = Page.memberDeatilsUpdate;
            Test.setCurrentPage(pageRef);
            Test.setMock(HttpCalloutMock.class, new mockProfileIndfo());
            ctrl.reqId = req.id;
            ctrl.isgu = ctrl.isgu;
            ctrl.ispu = ctrl.ispu;

            ctrl.updateDetails();
            try {
                ctrl.saveReqLR();
            } catch (Exception e) {}
            try {
                ctrl.saveReq();
            } catch (Exception e) {}
            //ctrl.req = req;
            try {
                ctrl.getMember();
            } catch (Exception e) {}
            ctrl.req = req2;

            ctrl.callSMService();
            ctrl.sendOTP();
            ctrl.validateOtp();
            ctrl.saveEmail();
            ctrl.docName = 'Passport';
            ctrl.imageBase64 = 'Testing';
            ctrl.saveAttachment();
            ctrl.docName = 'Emirates';
            ctrl.saveAttachment();
            ctrl.docName = 'RIC';
            ctrl.saveAttachment();
            Attachment att = [Select id from Attachment limit 1];
            ApexPages.currentPage().getParameters().put('attId', att.Id);
            ctrl.deleteAttach();
            try {
                ctrl.cancelR();
            } catch (Exception e) {}
            ctrl.otpResult = '';
            ctrl.otpAttempt = 2;
            ctrl.draftIns = '';
            ctrl.showedit = false;
            ctrl.responseBody = '';
            ctrl.mobNumber = '';
            ctrl.mapInfo = new map < string, mdWrapper.IdentityInfo > ();
            ctrl.getUpdateMobileFields('+971-5052323323');
            ctrl.req = req;

            try {
                ctrl.submitRequest();
            } catch (Exception e) {}
            try {
                ctrl.saveDraftR();
            } catch (Exception e) {}
        }
        test.stopTest();
    }




    public class mockProfileIndfo implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            List < mdWrapper > wrapList = new List < mdWrapper > ();
            mdWrapper wrap = new mdWrapper();
            mdWrapper.PassportInfo p = new mdWrapper.PassportInfo();
            p.isExpired = true;
            wrap.IdentityInfo = new List < mdWrapper.IdentityInfo > ();
            mdWrapper.ContactDetail detail = new mdWrapper.ContactDetail();
            detail.emailAddress = 'test@gmail.com';
            mdWrapper.IdentityInfo info = new mdWrapper.IdentityInfo();
            info.role = 'sample';
            info.contactDetail = detail;
            info.passportInfo = p;
            wrap.IdentityInfo.add(info);
            wrapList.add(wrap);
            res.setBody(JSON.serialize(wrapList));
            res.setStatusCode(200);
            return res;
        }
    }
    public class MockInsBatchGen implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('dummyResp');
            //res.setBody('[{"serviceRequest":[{"status":null,"servPdNm":null,"service":"CPU","serNm":"CPU","refAXS":"152344320230410","permSd":null,"permEd":null,"nocType":null,"nameOD":null,"memInfo":{"role":"Manager","passportInfo":{"passportNumber":"N7330120","passportIssueDate":"2018-02-06","passportExpiryDate":"2028-02-06","isExpired":false},"nationalIdNo":null,"identityName":"Venkata Ratnam Dhanemkulu","identityId":"a06D000000Wl1nAIAR","emiratesIdInfo":{"isExpired":false,"emiratesIdNumber":"784-2001-1234566-1","emiratesIdIssueDate":"2023-03-26","emiratesIdExpiryDate":"2024-04-10"},"contactDetail":{"Nationality":"India","mobileNumber":"543038688","middleName":null,"lastName":"Dhanemkulu","gender":"Male","firstName":"Venkata Ratnam","emailAddress":"mohammad.imtiyazuddin-v@dham.ae","dateOfBirth":"1988-06-23"},"addressDetailsInUAE":{"residencePhone":null,"POBoxNo":"54546","officePhoneNo":null,"mobileNo":null,"emailAddress":null,"city":"68568","address":"68567567ghgf"},"addressDetailsInHomeCountryPermanent":{"residencePhone":null,"POBoxNo":"500033","officePhoneNo":null,"mobileNo":"","emailAddress":null,"country":"","city":"Hyderabad","address":"2, Saikrupa Nilayam, 55/A, Journalist Colony, Jubilee Hills"}},"locAdd":null,"licenseNo":"91212","isSucces":null,"isPaid":null,"extAXS":"a0E0p00000E12J7EAJ","errorMessage":null,"dccapermtNo":"","cFRReason":null,"cFRNotes":null,"auditedData":null,"attName":null,"attaFlag":null,"attach":null}]}');
            //  res.setBody('{"serviceRequest":[{"service":"a156F000006ui51QAA","refAxs":"43084220180408","locAdd":"R/C22-Outdoor Seating,Bldg 10,Ground 0,Dubai Media City","licenseNo":"30849","isSucces":true,"isPaid":true,"extAxs":"a0EN000000FBKmzMAH","errorMessage":null,"attaFlag":null,"attach":null,"dccapermtNo":"12323"}]}');
            res.setStatusCode(200);
            return res;
        }
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
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'W'
                Limit 1
            ];
            User user1 = new User(
                UserName = contact1.Email,
                FirstName = contact1.FirstName,
                LastName = contact1.LastName,
                Alias = 'test123', Department__c = 'Finance',
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
}