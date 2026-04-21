@isTest
public class CTRLCustProfileUpdateTest1 {
    @testSetup static void setup() {
       /* testData.init();
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
        //gStg__c crtstng = testData.createSetting('test', 'testvalue'); */

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
        //g_Req__c r=testData.reqCrt(a.Id, s.Id, null, 'Draft', stg.reqq__c);
        List<Contact> conLst = [select id, accountid, Salutation, firstName, lastName, STA__c, rol__c, p__c, pid__c, ped__c, Ownerid, ptsta__c from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id, lc__c from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        g_srvcitm__c si = new g_srvcitm__c(srvc__c=srvcLst[0].id, name='Member Attributes', cd__c='ma', lbl__c='Member Attributes', ord__c=1);
        insert si;
        List<g_srvcitm_Status__c> stsList = new List<g_srvcitm_Status__c> ();
        g_srvcitm_Status__c ss = new g_srvcitm_Status__c(itm__c=si.id, name='Submitted for Verification', cd__c='v', lbl__c='Submitted for Verification');
        stsList.add(ss);
        //insert ss;
        g_srvcitm_Status__c ss1 = new g_srvcitm_Status__c(itm__c=si.id, name='Cancelled', cd__c='c', lbl__c='Cancelled');
        stsList.add(ss1);
        insert stsList;
        system.debug('---stsList---'+stsList);
        //insert ss1;
        //Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        string jsonStr = '{"methodname":"membersupdate", "data":{"licenseNum":"'+accLst[0].lc__c+'"}}';
        string dummyRespCs ='{ "responseCode": { "responseCode": 200, "errorMessage": "Success" }, "identityInfo": [{ "role": "Manager", "passportInfo": { "passportNumber": "R5475115", "passportIssueDate": "2017-05-17", "passportExpiryDate": "2027-05-16" }, "nationalIdNo": null, "identityName": "Mada Radhakrishnamurthy", "identityId": "a066F00001eItWmQAK", "emiratesIdInfo": { "emiratesIdNumber": null, "emiratesIdIssueDate": null, "emiratesIdExpiryDate": null }, "contactDetail": { "nationality": "India", "mobileNumber": "util_reset@test.com", "middleName": null, "lastName": "Radhakrishnamurthy", "gender": "Male", "firstName": "Mada", "emailAddress": "util_reset@test.com", "dateOfBirth": "8-Jan-1978" }, "addressDetailsInUAE": { "residencePhone": "util_reset@test.com", "POBoxNo": null, "officePhoneNo": "util_reset@test.com", "mobileNo": "util_reset@test.com", "emailAddress": "util_reset@test.com", "city": null, "address": null }, "addressDetailsInHomeCountryPermanent": { "residencePhone": "util_reset@test.com", "POBoxNo": "11111", "officePhoneNo": "util_reset@test.com", "mobileNo": "util_reset@test.com", "emailAddress": "util_reset@test.com", "country": null, "city": "HYDERABAD", "address": "HYDERABAD" } }, { "role": "Manager", "passportInfo": { "passportNumber": "S7749882", "passportIssueDate": "2019-07-12", "passportExpiryDate": "2023-07-11" }, "nationalIdNo": null, "identityName": "Venkata Ramana Prasad Surineni", "identityId": "a066F00001eItWoQAK", "emiratesIdInfo": { "emiratesIdNumber": "95333", "emiratesIdIssueDate": "2019-07-01", "emiratesIdExpiryDate": "2024-07-12" }, "contactDetail": { "nationality": "India", "mobileNumber": "+9713701231000", "middleName": null, "lastName": "Surineni", "gender": "Male", "firstName": "Venkata Ramana Prasad", "emailAddress": "joh@tecom.com", "dateOfBirth": "5-Jun-1974" }, "addressDetailsInUAE": { "residencePhone": "util_reset@test.com", "POBoxNo": null, "officePhoneNo": "util_reset@test.com", "mobileNo": "+971525994513", "emailAddress": "joh@tecom.com", "city": null, "address": null }, "addressDetailsInHomeCountryPermanent": { "residencePhone": "util_reset@test.com", "POBoxNo": null, "officePhoneNo": "util_reset@test.com", "mobileNo": "+9713701231000", "emailAddress": "joh@tecom.com", "country": null, "city": "ANDRA PRADESH", "address": "ANDRA PRADESH" } }, { "role": "Ultimate Beneficiary", "passportInfo": { "passportNumber": "S7749882", "passportIssueDate": "2019-07-12", "passportExpiryDate": "2023-07-11" }, "nationalIdNo": null, "identityName": "Mada Radhakrishnamurthy", "identityId": "a6o6F0000009qSJQAY", "emiratesIdInfo": null, "contactDetail": { "nationality": "India", "mobileNumber": "+9713701231000", "middleName": "", "lastName": "Mada Radhakrishnamurthy", "gender": "Male", "firstName": "", "emailAddress": null, "dateOfBirth": "1978-01-08" }, "addressDetailsInUAE": { "residencePhone": null, "POBoxNo": null, "officePhoneNo": null, "mobileNo": null, "emailAddress": null, "city": "HYDERABAD", "address": "HYDERABAD" }, "addressDetailsInHomeCountryPermanent": { "residencePhone": null, "POBoxNo": null, "officePhoneNo": null, "mobileNo": "+9713701231000", "emailAddress": null, "country": null, "city": null, "address": null } }, { "role": "Ultimate Beneficiary", "passportInfo": { "passportNumber": "U4795230", "passportIssueDate": "2020-08-24", "passportExpiryDate": "2023-06-23" }, "nationalIdNo": null, "identityName": "Vijaya lakshmi Mada", "identityId": "a6o6F0000009qSKQAY", "emiratesIdInfo": null, "contactDetail": { "nationality": "India", "mobileNumber": null, "middleName": "", "lastName": "Vijaya lakshmi Mada", "gender": "Female", "firstName": "", "emailAddress": null, "dateOfBirth": "1981-04-09" }, "addressDetailsInUAE": { "residencePhone": null, "POBoxNo": null, "officePhoneNo": null, "mobileNo": null, "emailAddress": null, "city": "HYDERABAD", "address": "HYDERABAD" }, "addressDetailsInHomeCountryPermanent": { "residencePhone": null, "POBoxNo": null, "officePhoneNo": null, "mobileNo": null, "emailAddress": null, "country": null, "city": null, "address": null } }] }';

        //contact con1 =[select id, ptsta__c from contact where id=:conLst[0].id];
        g_Req__c req=  new g_req__c();//testData.reqCrt(accLst[0].Id, srvcLst[0].Id, conLst[0].Id, 'Open', srvcsettings[0].reqq__c);
        req.acc__c=accLst[0].Id;
        req.srvc__c=srvcLst[0].Id;
        req.xadtx4__c=dummyRespCs;
        req.xadtx3__c=dummyRespCs;
        req.sta__c='';
        insert req;
        //g_req__c req1 = [select id, sta__c, (select id, sta__c from  items__r limit 1) from g_req__c where id=:r.id];
        //system.debug('--req--'+req);
        //system.debug('--req1.items__r--'+req1.items__r);
        /*mdWrapper mdw = new mdWrapper();
        mdWrapper.ContactDetail con= new mdWrapper.ContactDetail();
        con.dateOfBirth ='Today';
        con.Nationality ='India';
        con.middleName ='mn';
        con.lastName ='ln';
        con.gender ='Male';
        con.firstName ='fn';
        con.emailAddress ='test@test.com';
        con.mobileNumber='+971 500000000';
        mdWrapper.ResponseCode res = new mdWrapper.ResponseCode();
        res.responseCode   =200;
        res.errorMessage='Success';
        mdWrapper.AddressDetailsInUAE addUAE= new mdWrapper.AddressDetailsInUAE();
        addUAE.address='Dubai';
        addUAE.POBoxNo='1234';
        addUAE.officePhoneNo='12345';
        addUAE.mobileNo='util_reset@test.com';
        addUAE.emailAddress='test@test.com';
        addUAE.city='Dubai';
        addUAE.address='Dubai';
        addUAE.residencePhone='9080';
        mdWrapper.AddressDetailsInHomeCountryPermanent addHome= new mdWrapper.AddressDetailsInHomeCountryPermanent();
        addHome.address='Dubai';
        addHome.POBoxNo='1234';
        addHome.officePhoneNo='12345';
        addHome.mobileNo='util_reset@test.com';
        addHome.emailAddress='test@test.com';
        addHome.city='Dubai';
        addHome.address='Dubai';
        addHome.residencePhone='9080';
        addHome.country='India';
        mdWrapper.EmiratesIdInfo eid= new mdWrapper.EmiratesIdInfo();
        eid.emiratesIdExpiryDate='';
        eid.emiratesIdIssueDate='Today';
        eid.emiratesIdNumber = '12345';
        eid.isExpired=true;
        mdWrapper.PassportInfo pp= new mdWrapper.PassportInfo();
        pp.passportExpiryDate = 'Today';
        pp.passportIssueDate ='';
        pp.passportNumber='PPnumber';
        pp.isExpired=true;
        mdWrapper.IdentityInfo iden= new mdWrapper.IdentityInfo();
        iden.role ='Manager';
        iden.identityName ='test Identity';
        iden.nationalIdNo = '1234';
        iden.identityId ='a06';
        iden.passportInfo = pp;
        iden.addressDetailsInHomeCountryPermanent = addHome;
        iden.addressDetailsInUAE=addUAE;
        iden.contactDetail=con;
        iden.emiratesIdInfo=eid; */
        /*req.xadtx3__c=req.xadtx4__c;//json.serialize(iden);
        req.sta__c='Under Review';
        update req; */
    }
    static testmethod void test1() {

        mdWrapper mdw = new mdWrapper();
        mdWrapper.ContactDetail con= new mdWrapper.ContactDetail();
        con.dateOfBirth ='Today';
        con.Nationality ='India';
        con.middleName ='mn';
        con.lastName ='ln';
        con.gender ='Male';
        con.firstName ='fn';
        con.emailAddress ='test@test.com';
        con.mobileNumber='+971 500000000';
        mdWrapper.ResponseCode res = new mdWrapper.ResponseCode();
        res.responseCode   =200;
        res.errorMessage='Success';
        mdWrapper.AddressDetailsInUAE addUAE= new mdWrapper.AddressDetailsInUAE();
        addUAE.address='Dubai';
        addUAE.POBoxNo='1234';
        addUAE.officePhoneNo='12345';
        addUAE.mobileNo='util_reset@test.com';
        addUAE.emailAddress='test@test.com';
        addUAE.city='Dubai';
        addUAE.address='Dubai';
        addUAE.residencePhone='9080';
        mdWrapper.AddressDetailsInHomeCountryPermanent addHome= new mdWrapper.AddressDetailsInHomeCountryPermanent();
        addHome.address='Dubai';
        addHome.POBoxNo='1234';
        addHome.officePhoneNo='12345';
        addHome.mobileNo='util_reset@test.com';
        addHome.emailAddress='test@test.com';
        addHome.city='Dubai';
        addHome.address='Dubai';
        addHome.residencePhone='9080';
        addHome.country='India';
        mdWrapper.EmiratesIdInfo eid= new mdWrapper.EmiratesIdInfo();
        eid.emiratesIdExpiryDate='';
        eid.emiratesIdIssueDate='Today';
        eid.emiratesIdNumber = '12345';
        eid.isExpired=true;
        mdWrapper.PassportInfo pp= new mdWrapper.PassportInfo();
        pp.passportExpiryDate = 'Today';
        pp.passportIssueDate ='';
        pp.passportNumber='PPnumber';
        pp.isExpired=true;
        mdWrapper.IdentityInfo iden= new mdWrapper.IdentityInfo();
        iden.role ='Manager';
        iden.identityName ='test Identity';
        iden.nationalIdNo = '1234';
        iden.identityId ='a06';
        iden.passportInfo = pp;
        iden.addressDetailsInHomeCountryPermanent = addHome;
        iden.addressDetailsInUAE=addUAE;
        iden.contactDetail=con;
        iden.emiratesIdInfo=eid;
        g_Req__c req = [Select id, xadtx3__c, xadtx4__c from g_Req__c limit 1];
        Test.startTest();
        ApexPages.currentPage ().getParameters ().put ('id', req.Id);
        CTRLCustProfileUpdate1 ctrl = new CTRLCustProfileUpdate1();
        ctrl.info =(mdWrapper.IdentityInfo)System.JSON.deserialize(req.xadtx4__c, mdWrapper.IdentityInfo.class);
        ctrl.infoUpdated =(mdWrapper.IdentityInfo)System.JSON.deserialize(req.xadtx3__c, mdWrapper.IdentityInfo.class);
        PageReference pageRef =  Page.memberDeatilsUpdate;
       // req1.items__r[0].sta__c=stsList[0].id;
        //update req1.items__r[0];
        Test.setCurrentPage(pageRef);
        Test.setMock(HttpCalloutMock.class, new mockProfileIndfo());
        Test.setMock(HttpCalloutMock.class, new MockInsBatchGen());
        ctrl.reqId=req.id;
        ctrl.isgu= ctrl.isgu;
        ctrl.ispu= ctrl.ispu;
        //ctrl.updateDetails();
        //ctrl.submitRequest();
        //ctrl.getMember();
        //ctrl.saveReq();
        //ctrl.saveEmail();
        test.stopTest();

    }
    public class mockProfileIndfo implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String dummyResp ='[ { "responseCode": { "responseCode": 200, "errorMessage": "Error message here if any" }, "IdentityInfo": [ { "role": "manager", "passportInfo": { "passportNumber": "1123A1", "passportIssueDate": "2021-11-10", "passportExpiryDate": "2022-08-13" }, "nationalIdNo": "1D23F", "identityName": "Samiha", "identityId": "a060l000008cQRSAA2", "emiratesIdInfo": { "emiratesIdNumber": "51A4D113", "emiratesIdIssueDate": "2022-08-05", "emiratesIdExpiryDate": "2022-11-14" }, "contactDetail": { "nationality": "Lebanese", "mobileNumber": "+971307701231", "middleName": "Walid", "lastName": "Baker", "gender": "female", "firstName": "Sami", "emailAddress": "john@tecom.com", "dateOfBirth": "2002-12-15" }, "addressDetailsInUAE": { "residencePhone": "0131211111", "POBoxNo": "000", "officePhoneNo": "+96151231213", "mobileNo": "708001211", "emailAddress": "j@uae.com", "city": "Al Shariqa", "address": "5Rue" }, "addressDetailsInHomeCountryPermanent": { "residencePhone": "0131211111", "POBoxNo": "000", "officePhoneNo": "+96151231213", "mobileNo": "708001211", "emailAddress": "j@home.com", "country": "Lebanon", "city": "Jbeil", "address": "5Rue" } }, { "role": "shareholder", "passportInfo": { "passportNumber": "11441", "passportIssueDate": "2022-02-18", "passportExpiryDate": "2023-05-05" }, "nationalIdNo": "3X23F", "identityName": "Fahad", "identityId": "a060l000008bI3CAAU", "emiratesIdInfo": { "emiratesIdNumber": "1233fA2", "emiratesIdIssueDate": "2020-05-17", "emiratesIdExpiryDate": "2023-03-25" }, "contactDetail": { "nationality": "British", "mobileNumber": "+971307701231", "middleName": "Yaris", "lastName": "Saleh", "gender": "female", "firstName": "Tina", "emailAddress": "john@tecom.com", "dateOfBirth": "2002-12-15" }, "addressDetailsInUAE": { "residencePhone": "0131214411", "POBoxNo": "0400", "officePhoneNo": "+96151231213", "mobileNo": "708001211", "emailAddress": "j2@uae.com", "city": "Al Shariqa", "address": "6Rue" }, "addressDetailsInHomeCountryPermanent": { "residencePhone": "0132141111", "POBoxNo": "0400", "officePhoneNo": "+96151277213", "mobileNo": "708440211", "emailAddress": "j2@home.com", "country": "Lebanon", "city": "Saida", "address": "6Rue" } } ] } ]';
            res.setBody(dummyResp);
            res.setStatusCode(200);
            return res;
        }
    }
    public class MockInsBatchGen implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{"serviceRequest":[{"status":null, "servPdNm":null, "service":"CPU", "serNm":"CPU", "refAXS":"152344320230410", "permSd":null, "permEd":null, "nocType":null, "nameOD":null, "memInfo":{"role":"Manager", "passportInfo":{"passportNumber":"N7330120", "passportIssueDate":"2018-02-06", "passportExpiryDate":"2028-02-06", "isExpired":false}, "nationalIdNo":null, "identityName":"Venkata Ratnam Dhanemkulu", "identityId":"a06D000000Wl1nAIAR", "emiratesIdInfo":{"isExpired":false, "emiratesIdNumber":"784-2001-1234566-1", "emiratesIdIssueDate":"2023-03-26", "emiratesIdExpiryDate":"2024-04-10"}, "contactDetail":{"Nationality":"India", "mobileNumber":"543038688", "middleName":null, "lastName":"Dhanemkulu", "gender":"Male", "firstName":"Venkata Ratnam", "emailAddress":"mohammad.imtiyazuddin-v@dham.ae", "dateOfBirth":"1988-06-23"}, "addressDetailsInUAE":{"residencePhone":null, "POBoxNo":"54546", "officePhoneNo":null, "mobileNo":null, "emailAddress":null, "city":"68568", "address":"68567567ghgf"}, "addressDetailsInHomeCountryPermanent":{"residencePhone":null, "POBoxNo":"500033", "officePhoneNo":null, "mobileNo":"", "emailAddress":null, "country":"", "city":"Hyderabad", "address":"2, Saikrupa Nilayam, 55/A, Journalist Colony, Jubilee Hills"}}, "locAdd":null, "licenseNo":"91212", "isSucces":null, "isPaid":null, "extAXS":"a0E0p00000E12J7EAJ", "errorMessage":null, "dccapermtNo":"", "cFRReason":null, "cFRNotes":null, "auditedData":null, "attName":null, "attaFlag":null, "attach":null}]}');
          //  res.setBody('{"serviceRequest":[{"service":"a156F000006ui51QAA", "refAxs":"43084220180408", "locAdd":"R/C22-Outdoor Seating, Bldg 10, Ground 0, Dubai Media City", "licenseNo":"30849", "isSucces":true, "isPaid":true, "extAxs":"a0EN000000FBKmzMAH", "errorMessage":null, "attaFlag":null, "attach":null, "dccapermtNo":"12323"}]}');
            res.setStatusCode(200);
            return res;
        }
    }
}