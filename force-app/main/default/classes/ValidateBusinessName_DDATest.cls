@isTest(SeeAllData=false)
public class ValidateBusinessName_DDATest {
public static String dummyResp='';
static testmethod void testValidateBusinessName_DDA() {
          Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockGetResp());
         dummyResp = 'test';
    ValidateBusinessName_DDA.validateNameInDDA('tset');

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