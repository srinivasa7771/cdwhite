@istest
private class WS_GetReqDeatilsTest {
 static testmethod void test1() {

        RestRequest req = new RestRequest();

        RestResponse res = new RestResponse();
        req.requestURI = '/getDetails/'; //Request URL
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();

            Test.setMock(HttpCalloutMock.class, new MockWS_GetReqDeatils());
            WS_GetReqDeatils obj = new WS_GetReqDeatils();
            try{
                WS_GetReqDeatils.postRequest();
            }Catch(Exception e) {
                system.debug('Exception:::::::::::::');
            }

        Test.stopTest();
    }
    public class MockWS_GetReqDeatils implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"reqNumber":"110411120210317", "type":"request"}');
            res.setStatusCode(200);
            return res;
        }
    }
}