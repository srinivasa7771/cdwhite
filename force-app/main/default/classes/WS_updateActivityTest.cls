@istest
private class WS_updateActivityTest {
    static testmethod void test1() {

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/updateactivity/'; //Request URL
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockWS_updateActivity());
            WS_updateActivity obj = new WS_updateActivity();
            try{
                WS_updateActivity.postRequest();
            }Catch(Exception e) {
                system.debug('Exception:::::::::::::');
            }

        Test.stopTest();
    }
    public class MockWS_updateActivity implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"taskId":"asd", "rating":7}');
            res.setStatusCode(200);
            return res;
        }
    }
}