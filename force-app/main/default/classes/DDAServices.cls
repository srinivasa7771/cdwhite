public class DDAServices {

    public static String getDDAServices(string endpoint, string url, String requestMethod, String requestJson) {
        system.debug('getDDAServices::::');
        string responseJson;
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setEndpoint('callout:'+endpoint+'/apexrest/'+url);
        request.setHeader('Content-Type', 'application/json');
        request.setMethod(requestMethod);
        request.setTimeout(120000);
        request.setBody(requestJson);
        response = h.send(request);
        system.debug('code:::'+response.getStatusCode());
        if (response.getStatusCode() == 200 && response != null) {
            responseJson =response.getBody();
        }
        return responseJson;
    }
}