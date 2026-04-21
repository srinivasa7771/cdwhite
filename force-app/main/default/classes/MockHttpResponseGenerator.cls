@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
  /*  private ws_call__c wsobj;
    public MockHttpResponseGenerator(ws_call__c wsobj) {
    this.wsobj = wsobj;
} */
    global HTTPResponse respond(HTTPRequest request) {
        system.debug('asasdasdasd'+request);
        System.assertEquals('POST', request.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();

        //
        if (request.getEndpoint().contains('/updateactivity/')) {
            res.setBody('{"taskId":"asd", "rating":7}');
            res.setStatusCode(200);
        }else if (request.getEndpoint().contains('DCCA_Auth/apexrest/getLicense?licenseNumber?')) {
            //res.setBody('{"taskId":"asd", "rating":7}');
            res.setStatusCode(200);
        }
        else{
            res.setStatusCode(200);
        }
        //
        return res;
    }

}