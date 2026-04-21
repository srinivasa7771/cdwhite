@istest
private class WS_insertActivityTest {
    static testmethod void test1() {

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/updateactivity/'; //Request URL
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
            //Test.setMock(HttpCalloutMock.class, new MockWS_updateActivity());
            WS_insertActivity obj = new WS_insertActivity();
            try{
                WS_insertActivity.postRequest();
            }Catch(Exception e) {
                system.debug('Exception:::::::::::::');
            }

        Test.stopTest();
    }

}