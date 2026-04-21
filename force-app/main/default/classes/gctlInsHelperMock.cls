@isTest
public class gctlInsHelperMock implements HttpCalloutMock {
    
    public String str;
    public gctlInsHelperMock(String str) {
        this.str = str;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        if(str == 'CalPremSuccess') {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Decrypted-Text":"test"}');
            res.setStatusCode(200);
        } else if(str == 'CalPremError') {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Decrypted-Text":"test"}');
            res.setStatus('Partner-IV');
            res.setStatusCode(400);
        }
        return res;
    }
}