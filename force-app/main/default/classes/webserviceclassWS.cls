public class webserviceclassWS {
    public static void processWsCall(ws_call__c ws) {
          List<ws_call__c> wsList = new List<ws_call__c>();
                   Http h = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept', 'application/json');
            request.setEndpoint('callout:DCCA_Auth/apexrest/createSanction/');
            request.setTimeout(120000);
            request.setMethod('POST');
            request.setBody(ws.rq_jsn__c);//jsonBody
            try {

                response = h.send(request);
                if (response.getStatusCode() == 200) {
                    ws.intsts__c = 'Success';
                    ws.res_jsn__c= response.getBody();
                }else {

                    ws.res_jsn__c= response.getBody();
                    ws.intsts__c = 'Failed';
                }
            }catch (System.CalloutException e) {
                System.debug('Callout error: ' + e);
                ws.res_jsn__c= String.ValueOF(e);
                ws.intsts__c = 'Failed';
             }
            wsList.add(ws);
        if (!wsList.isEmpty())
          Update wsList;
        }
    }