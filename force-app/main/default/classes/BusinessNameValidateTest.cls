@isTest(SeeAllData=false)
public class BusinessNameValidateTest {
public static String dummyResp='';
static testmethod void testBusinessNameValidate() {
          Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockGetResp());
         dummyResp = 'test';
    BusinessNameValidate.validateBusiness('tset', '');
         BusinessNameValidate.validate('tset');
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