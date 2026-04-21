@isTest(SeeAllData=false)
public class BatchOnboardCrtUsrTest {
public static String dummyResp='';
    @testSetup
    static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        a.bkflg__c = true;
        a.ccrm_sfid__c = a.id;
        update a;

    }
    static testmethod void testUploadDoc() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockGetResp());
         dummyResp = '{"workorders":[{"status":"Pending For Payment", "recType":"License_Registration_Request", "recid":"0WO2R0000059TZQWA2", "parentid":null, "members":null, "ddaRQNo":null, "ddaRQId":null}, {"status":"Approved", "recType":"Security_Clearance", "recid":"0WO2R0000059NhHWAU", "parentid":null, "members":null, "ddaRQNo":null, "ddaRQId":null}], "usrName":"Mohammed Shareef", "scWorkid":"0WO2R0000059NhHWAU", "respMsg":"Success", "requestid":null, "quotes":[], "proposedLegalForm":"DDA", "prmPhone":"04 3902549", "prmMobile":"+971 0503481587", "prmLastName":"Shareef", "prmFirstName":"Mohammed", "prmEmail":"mohammed.shareef@dmc.ae", "paymentSchedules":[], "oppId":null, "onbReqid":"a2l2R000004NyfSQAS", "nameResWorkid":"0WO2R0000059TZQWA2", "members":[{"website":null, "uboType":null, "uboRelatedTo":null, "uboOwnedbyUAE":null, "uboDeclaration":null, "street":null, "stockExchangeListed":null, "sh":"null", "security":null, "salutation":null, "rpNo":null, "rpExpDate":null, "role":"General Manager", "postalCode":null, "placeissued":"DUBAI", "pIssuedDate":null, "phoneno":"0527420153", "pExpDate":"2028-12-12", "passportNo":"T0675252", "nationality":"India", "mobile":"0527420153", "mname":null, "mailingStreet":null, "mailingPostalCode":null, "mailingCountry":null, "mailingCity":null, "lnameAr":null, "lname":"Maloo", "legals":null, "iAuthority":null, "gender":"Male", "fnameAr":null, "fname":"Shresth", "email":"shresthmaloo@gmail.com", "eid":null, "eExpDate":null, "dob":"1997-05-20", "ctgCode":null, "cshType":null, "corpORind":null, "conid":"0032R00002KWYxJQAX", "city":null, "birthplace":null}], "lrWorkid":null, "licenseType":"DDA", "legalFramework":"DDA", "lcExpdate":null, "isSuccess":true, "Invoices":[], "hseWorkid":null, "documents":[{"name":"Valid Passport Copy - Shresth Maloo", "isFileAttached":false, "isCallforReview":false, "gracePeriod":false, "description":"Valid Passport Copy - Shresth Maloo", "ddaDocId":"a3e6F0000018QtrQAE", "ccrmParentId":"0WO2R0000059TZQWA2", "ccrmDocId":"a0H2R00001IwdYKUAZ"}], "DDAReqNo":null, "crmAccName":"Shresth  Maloo", "crmAccId":"0012R00002H0sasQAB", "caseid":null, "businessPark":"DDA", "brandWorkid":null, "actvities":[{"title":null, "segment":"Dubai Media City Freelancers", "name":"Aerial Shoot Photographer", "channel":null, "actId":"a0L2R00000KCyrYUAT"}, {"title":null, "segment":"Dubai Media City Freelancers", "name":"Marketing Specialist", "channel":null, "actId":"a0L2R00000KCysXUAT"}, {"title":null, "segment":"Dubai Media City Freelancers", "name":"Photographer", "channel":null, "actId":"a0L2R00000KCynqUAD"}]}';
        BatchOnboardCrtUsr obj1 = new BatchOnboardCrtUsr('tst');
        BatchOnboardCrtUsr obj = new BatchOnboardCrtUsr();
        Database.executeBatch(obj, 1);
        Test.stopTest();
     }
    public class mockGetResp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(dummyResp);
            res.setStatusCode(200);

            return res;
        }
    }
}