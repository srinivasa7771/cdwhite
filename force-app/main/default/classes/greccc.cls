public class greccc {
    public class TranSTA {
        public String SPTRN, DEGTRN, TRANSDATE, PAYMENTMETHOD, MESSAGE, MESSAGECODE, id;
    }

    /*public  TranSTA checkTrn(String trnId){ String response; try{ DEGRec.Timestamp t = new DEGRec.Timestamp(); t.Created = system.now(); t.Expires = System.now().addMinutes(5); DEGRec.UsernameToken u = new DEGRec.UsernameToken(); u.username = gU.csStr('gwrcusr'); u.password = gU.csStr('gwrcpss'); DEGRec.Security hd = new DEGRec.Security(); hd.usernameToken = u; hd.TimeStamp = t;  DEGRec.ePayTransactionInquiryHttpsSoap11Endpoint    cls = new DEGRec.ePayTransactionInquiryHttpsSoap11Endpoint(); cls.Header = hd; response = cls.getTransactionStatus(gU.csStr('gwspc'),gU.csStr('gwsc'),trnId); System.debug(response); }catch(Exception e){e.getStackTraceString();} return ParseTrans(response,trnId); } */
    /*    public  TranSTA ParseTrans(String response,String trnId){ TranSTA t=new TranSTA(); Dom.Document doc = new Dom.Document(); if(response != null){ doc.load(response); Dom.XMLNode trans = doc.getRootElement(); if(trans != NULL){ String SPTRN,DEGTRN,TRANSDATE,PAYMENTMETHOD,MESSAGE,MESSAGECODE; if(trans.getChildElement('SPTRN', null) != NULL) t.SPTRN = trans.getChildElement('SPTRN', null).getText(); if(trans.getChildElement('DEGTRN', null) != NULL) t.DEGTRN = trans.getChildElement('DEGTRN', null).getText(); if(trans.getChildElement('TRANSDATE', null) != NULL) t.TRANSDATE = trans.getChildElement('TRANSDATE', null).getText(); if(trans.getChildElement('PAYMENTMETHOD', null) != NULL) t.PAYMENTMETHOD = trans.getChildElement('PAYMENTMETHOD', null).getText(); if(trans.getChildElement('MESSAGE', null) != NULL) t.MESSAGE = trans.getChildElement('MESSAGE', null).getText(); if(trans.getChildElement('MESSAGECODE', null) != NULL) t.MESSAGECODE = trans.getChildElement('MESSAGECODE', null).getText();  t.id=trnId; } } return t; }*/

    public PaymentRes getPaymentResponse(String ref) {
        PaymentRes payres = new PaymentRes();
        String resStr = '';
        String niAPIKey = gU.csStr('NI-APIKEY');
        String niEndPoint = gU.csStr('NIENDPOINT');
        String niPayUrl = gU.csStr('NIPAYMENTURL');
        try {
            HttpRequest req = New HttpRequest();
            /* req.setHeader('Content-Type', 'application/x-www-form-urlencoded;grant_type:client_credentials'); 17062025*/
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            /*basic + API key will be chnagedin production*/
            req.setHeader('Authorization', 'Basic:' + niAPIKey); /*req.setHeader('Authorization', 'Basic:NDVlNzFjOTAtYjk1ZS00YmE4LWJlZGMtOWI2YjlhMTBhYmE1OmMwODc2OTBjLTM4ZmQtNGZlMS04YjFiLWUzOWQ1ODdiMDhjYg==');*/
            req.setMethod('POST');
            req.setBody('grant_type=client_credentials'); /* no change in end point move it to custom settings*/ /* req.setEndpoint('https://identity-uat.ngenius-payments.com/auth/realms/ni/protocol/openid-connect/token');*/
            req.setEndpoint(niEndPoint);
            Http http = New Http();
            system.debug('Grant type header set');
            HTTPResponse res = http.send(req);
            system.debug('Response received, status: ' + res.getStatusCode());
            resStr = res.getBody();
            payres = getJsonResponse(resStr, 'AccessToken');
        } catch (Exception e) {}
        try {
            HttpRequest req = New HttpRequest();
            req.setHeader('Content-Type', 'application/vnd.ni-payment.v2+json');
            req.setHeader('Authorization', 'Bearer ' + payres.accessToken);
            req.setMethod('GET'); /*req.setEndpoint(' https://api-gateway-uat.ngenius-payments.com/transactions/outlets/d0e91b8f-476d-4a4b-aae7-075755b0159a/orders/'+ref);*/
            req.setEndpoint(niPayUrl + '/' + ref);
            Http http = New Http();
            HTTPResponse res = http.send(req);
            resStr = res.getBody();
            system.debug('Response received, status: ' + res.getStatusCode());
            payres = getJsonResponse(resStr, 'authResponse');
        } catch (Exception e) {}
        return payres;
    }
    private PaymentRes getJsonResponse(String jsonStr, String jsonType) {
        PaymentRes res = new PaymentRes();
        Decimal tranAmount = 0;
        try {
            /*String accessToken = '{ "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIxMDhmNWQ4Yy03ZDU5LTQ3ZWUtYWJjNC03MzVlMjE0NjNhMGIiLCJleHAiOjE1NjEyOTQzNjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IkJlYXJlciIsImF6cCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjQ5YTU5YjdlLTY4MjctNDk5ZC05MWI4LTM3ZGUxY2VhNTllZSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIiwiY2xpZW50SWQiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJjbGllbnRIb3N0IjoiMTAxLjUzLjE2NC44IiwicmVhbG0iOiJuaSIsImdpdmVuX25hbWUiOiJFLUNvbSBBY2NvdW50IiwiY2xpZW50QWRkcmVzcyI6IjEwMS41My4xNjQuOCIsImhpZXJhcmNoeVJlZnMiOlsiMTE0NGRmZDktZjUyYS00NGQxLTkwN2QtY2NkM2Y4M2E2MjIyIl19.qA9epI6Nj4IqLBoWiq58SzE3FFmESTtA5ndsA-PuvvtaNcJPhZgLNKVJNnc2ejXuw8Tjb4t6gqAHfGgGFHjxVzqq1kyizFcj7dCxT2IDK2kHL6ziZ-TtmxuFs50N5qFpVcqgtv05QXzWnNbUf_NgHS_rM5F2nO8v9IeKSpmYhA_IQFOfhy1slraR2WJi7muk5Od3yW1FtLa9ldn3S92FscMWM-nS-MHBdq8y6vpTMz9f2Z4AwHCcAOp4jeydFS4S_PkhJDpEiKEdkKpU8FvYCEIQ9SoZsbG4eoBIYRz6NSSvQHjGkmYBA6wg5irZFVJpqubX1C1PPuHGV3NLJNNRQg", "expires_in": 300, "refresh_expires_in": 1800, "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIwZDRkMWQ5OC0xMjRiLTQ2NDUtODMzYi0wYzA1MjE1NjA5YjkiLCJleHAiOjE1NjEyOTU4NjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IlJlZnJlc2giLCJhenAiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiI0OWE1OWI3ZS02ODI3LTQ5OWQtOTFiOC0zN2RlMWNlYTU5ZWUiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIn0.eIf5FjbWEE3OBwTJJA0cO96iI5Q1tflioCVhPMoA-xPPs90HGXQp9-CsBIG6PCXTYS6g3zD5hwP48CZ7kQXbyqHYRUzLfV3z3oJfJ95YhBCdcJh4DWBc11eAj2TmHmJ3Ih6zvHYkY4404rvWRAaiIKHFOtAf5sOt0R94nK_uu8MPSNbJJRqRSOnjgGzVI7AdC_nrn2joO4gN9DKu49eCcHH2lndXAW8e3fOeqxWSuNNlkHv1PXajy0v6veIFjjtlz2wRLdWoMU7VCM_kSZ7Qx-JQraqU0os6lefPgRAQUY225bQsR9ELGf8nTxpwRpkZDeE5wYmFwXPv-sS9xOU5aA", "token_type": "bearer", "not-before-policy": 0, "session_state": "49a59b7e-6827-499d-91b8-37de1cea59ee", "scope": "" }'; String paymnetJson = '{ "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIxMDhmNWQ4Yy03ZDU5LTQ3ZWUtYWJjNC03MzVlMjE0NjNhMGIiLCJleHAiOjE1NjEyOTQzNjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IkJlYXJlciIsImF6cCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjQ5YTU5YjdlLTY4MjctNDk5ZC05MWI4LTM3ZGUxY2VhNTllZSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIiwiY2xpZW50SWQiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJjbGllbnRIb3N0IjoiMTAxLjUzLjE2NC44IiwicmVhbG0iOiJuaSIsImdpdmVuX25hbWUiOiJFLUNvbSBBY2NvdW50IiwiY2xpZW50QWRkcmVzcyI6IjEwMS41My4xNjQuOCIsImhpZXJhcmNoeVJlZnMiOlsiMTE0NGRmZDktZjUyYS00NGQxLTkwN2QtY2NkM2Y4M2E2MjIyIl19.qA9epI6Nj4IqLBoWiq58SzE3FFmESTtA5ndsA-PuvvtaNcJPhZgLNKVJNnc2ejXuw8Tjb4t6gqAHfGgGFHjxVzqq1kyizFcj7dCxT2IDK2kHL6ziZ-TtmxuFs50N5qFpVcqgtv05QXzWnNbUf_NgHS_rM5F2nO8v9IeKSpmYhA_IQFOfhy1slraR2WJi7muk5Od3yW1FtLa9ldn3S92FscMWM-nS-MHBdq8y6vpTMz9f2Z4AwHCcAOp4jeydFS4S_PkhJDpEiKEdkKpU8FvYCEIQ9SoZsbG4eoBIYRz6NSSvQHjGkmYBA6wg5irZFVJpqubX1C1PPuHGV3NLJNNRQg", "expires_in": 300, "refresh_expires_in": 1800, "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIwZDRkMWQ5OC0xMjRiLTQ2NDUtODMzYi0wYzA1MjE1NjA5YjkiLCJleHAiOjE1NjEyOTU4NjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IlJlZnJlc2giLCJhenAiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiI0OWE1OWI3ZS02ODI3LTQ5OWQtOTFiOC0zN2RlMWNlYTU5ZWUiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIn0.eIf5FjbWEE3OBwTJJA0cO96iI5Q1tflioCVhPMoA-xPPs90HGXQp9-CsBIG6PCXTYS6g3zD5hwP48CZ7kQXbyqHYRUzLfV3z3oJfJ95YhBCdcJh4DWBc11eAj2TmHmJ3Ih6zvHYkY4404rvWRAaiIKHFOtAf5sOt0R94nK_uu8MPSNbJJRqRSOnjgGzVI7AdC_nrn2joO4gN9DKu49eCcHH2lndXAW8e3fOeqxWSuNNlkHv1PXajy0v6veIFjjtlz2wRLdWoMU7VCM_kSZ7Qx-JQraqU0os6lefPgRAQUY225bQsR9ELGf8nTxpwRpkZDeE5wYmFwXPv-sS9xOU5aA", "token_type": "bearer", "not-before-policy": 0, "session_state": "49a59b7e-6827-499d-91b8-37de1cea59ee", "scope": "" }'; String jsonStr = '{ "_embedded": { "payment": [ { "_id": "urn:payment:1533d314-d988-4694-9663-63699430f31e", "_links": { "self": { "href": "https://api-gateway-uat.ngenius-payments.com/transactions/outlets/e209b88c-9fb6-4be8-ab4b-e4b977ad0e0d/orders/6c225eca-0843-415a-bb4b-5281e2c8706c/payments/1533d314-d988-4694-9663-63699430f31e" }, "curies": [ { "name": "cnp", "href": "https://api-gateway-uat.ngenius-payments.com/docs/rels/{rel}", "templated": true } ] }, "paymentMethod": { "expiry": "2020-12", "cardholderName": "Test", "name": "MASTERCARD", "pan": "510510******5100" }, "savedCard": { "maskedPan": "510510******5100", "expiry": "2020-12", "cardholderName": "Test", "scheme": "MASTERCARD", "cardToken": "dG9rZW5pemVkUGFuLy92MS8vU0hPV19OT05FLy94ejFlNXRpNWh6YWxwODFo", "recaptureCsc": true }, "state": "CAPTURED", "amount": { "currencyCode": "AED", "value": 100 }, "updateDateTime": "2019-06-24T12:23:07.598Z", "outletId": "e209b88c-9fb6-4be8-ab4b-e4b977ad0e0d", "orderReference": "6c225eca-0843-415a-bb4b-5281e2c8706c", "authResponse": { "authorizationCode": "657400", "success": true, "resultCode": "00", "resultMessage": "Successful approval/completion or that VIP PIN verification is valid" }, "_embedded": { "cnp:capture": [ { "_links": { "self": { "href": "https://api-gateway-uat.ngenius-payments.com/transactions/outlets/e209b88c-9fb6-4be8-ab4b-e4b977ad0e0d/orders/6c225eca-0843-415a-bb4b-5281e2c8706c/payments/1533d314-d988-4694-9663-63699430f31e/captures/c6c45c15-4ecb-4aa8-aced-8afc1ad0dd61" } }, "amount": { "currencyCode": "AED", "value": 100 }, "createdTime": "2019-06-24T12:23:07.598Z", "state": "SUCCESS" } ] } } ] } }*/
            Map < String, Object > results = (Map < String, Object > ) JSON.deserializeUntyped(jsonStr);
            if (jsonType == 'AccessToken') res.accessToken = (String) results.get('access_token');
            else if (jsonType == 'authResponse') {
                Map < string, Object > links = (Map < string, Object > ) results.get('_embedded');
                Map < string, Object > amtmap = (Map < string, Object > ) results.get('amount');
                List < Object > paymentLst = (List < Object > ) links.get('payment');
                Map < string, Object > payment = (Map < string, Object > ) paymentLst[0];
                String dtm = (String) payment.get('updateDateTime');
                tranAmount = amtmap.get('value') != null ? (Decimal) amtmap.get('value') / 100 : 0;
                if (dtm != null) {
                    dtm = dtm.replace('T', ' ');
                    res.updateTime = Datetime.valueOf(dtm);
                } else {
                    res.updateTime = Datetime.now();
                }
                res.STATE = (String) payment.get('state');
                if (String.isNotBlank(res.STATE) && res.STATE == 'CAPTURED') {
                    /*Map < string, Object > threeds = (Map < string, Object > ) payment.get('3ds');
                    res.THREEDS_STATUS = (String) threeds.get('status');*/
                    if (payment.containsKey('3ds2')) {
                        Map < string, Object > threeds = (Map < string, Object > ) payment.get('3ds2');
                        String transStatus = (String) threeds.get('transStatus');
                        res.THREEDS_STATUS = (transStatus == 'C' || transStatus == 'Y') ? 'SUCCESS' : '';
                    } else {
                        Map < string, Object > threeds = (Map < string, Object > ) payment.get('3ds');
                        res.THREEDS_STATUS = (String) threeds.get('status');
                    }
                    Map < string, Object > authResponse = (Map < string, Object > ) payment.get('authResponse');
                    res.THREEDS_STATUS = 'SUCCESS';
                    res.AUTHCODE = (String) authResponse.get('authorizationCode');
                    res.MESSAGECODE = (String) authResponse.get('resultCode');
                    res.messageStatus = string.valueOf(authResponse.get('success'));
                    res.MESSAGE = (String) authResponse.get('resultMessage');
                    res.AMOUNT = tranAmount;
                    
                    system.debug('Authorization code received');
                    system.debug((String) authResponse.get('resultCode'));
                    system.debug(string.valueOf(authResponse.get('success')));
                    system.debug((String) authResponse.get('resultMessage'));
                    system.debug((String) payment.get('state'));
                    
                }
            }
        } catch (Exception ex) {
            system.debug('ex::' + ex.getStackTraceString());
        }
        return res;
    }
    public class PaymentRes {
        public string accessToken {
            set;
            get;
        }
        public Decimal AMOUNT {
            set;
            get;
        }
        public string MESSAGECODE {
            set;
            get;
        }
        public string messageStatus {
            set;
            get;
        }
        public string MESSAGE {
            set;
            get;
        }
        public string AUTHCODE {
            set;
            get;
        }
        public Datetime updateTime {
            set;
            get;
        }
        public string STATE {
            set;
            get;
        }
        public string THREEDS_STATUS {
            set;
            get;
        }
    }

    //public void updateTransactions(Map < String, greccc.TranSTA > repMap, list < g_Tran__c > trans) { List < g_Tran__c > courierB = new List < g_Tran__c > (); List < g_TranItem__c > Tis = new List < g_TranItem__c > (); Set < Id > riIds = new Set < Id > (); for (g_Tran__c T: trans) { TranSTA rt = repMap.get(T.id); if (rt.MESSAGECODE == '0') { T.STA__c = 'Completed'; g_reqitem__c ri; for (g_TranItem__c i: T.Items__r) { i.STA__c = T.STA__c; Tis.add(i); if (i.itm__r.sta__r.Courier_Stage__c == 'Collection' || i.itm__r.sta__r.Courier_Stage__c == 'Delivery') { courierB.add(T); } } } else if (rt.MESSAGECODE == '70011') { T.STA__c = 'Cancelled'; for (g_TranItem__c i: T.Items__r) { i.STA__c = T.STA__c; Tis.add(i); } } else if (rt.MESSAGECODE != '80013' && rt.MESSAGECODE != '80014') { T.STA__c = 'Failed'; for (g_TranItem__c i: T.Items__r) { i.STA__c = T.STA__c; Tis.add(i); } } T.gwrf__c = rt.DEGTRN; T.gwcd__c = rt.MESSAGECODE; if (rt.TRANSDATE != NULL && rt.TRANSDATE != '') T.gwdt__c = parseDateDEG(rt.TRANSDATE); T.gwmsg__c = rt.MESSAGE; if (rt.PAYMENTMETHOD != NULL && rt.PAYMENTMETHOD != '') T.md__c = rt.PAYMENTMETHOD; } for (g_Tran__c T: courierB) { try { g_reqitem__c ri; for (g_TranItem__c i: T.Items__r) { if (i.itm__r.sta__r.Courier_Stage__c == 'Collection' || i.itm__r.sta__r.Courier_Stage__c == 'Delivery') { ri = i.itm__r; } } Boolean isCour = false; XMLParserforEmpostWebservice cour = new XMLParserforEmpostWebservice(); if (ri != null && (ri.sta__r.Courier_Stage__c == 'Collection' || ri.sta__r.Courier_Stage__c == 'Delivery') && !isCour) { cour.courierBooking(ri, T.RQ__r, false, ''); isCour = false; } } catch (Exception e) {} } if (trans != null) { update trans; } if (Tis != null) { update Tis; } for (g_Tran__c T: trans) { if (T.STA__c == 'Completed') { riIds.clear(); for (g_TranItem__c i: T.Items__r) { riIds.add(i.itm__c); } system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'); system.debug(T.RQ__r); grqH.rH h = new grqH.rH(); h.AP(T.RQ__r, T, riIds); } } }
    /*public void updateTransactions(Map < String, greccc.TranSTA > repMap, list < g_Tran__c > trans) { List < g_Tran__c > courierB = new List < g_Tran__c > (); List < g_TranItem__c > Tis = new List < g_TranItem__c > (); Set < Id > riIds = new Set < Id > (); for (g_Tran__c T: trans) { if(repMap.containsKey(T.id)){ TranSTA rt = repMap.get(T.id); if (rt.MESSAGECODE == '0') { T.STA__c = 'Completed'; g_reqitem__c ri; for (g_TranItem__c i: T.Items__r) { i.STA__c = T.STA__c; Tis.add(i); if (i.itm__r.sta__r.Courier_Stage__c == 'Collection' || i.itm__r.sta__r.Courier_Stage__c == 'Delivery') { courierB.add(T); } } } else if (rt.MESSAGECODE == '70011') { T.STA__c = 'Cancelled'; for (g_TranItem__c i: T.Items__r) { i.STA__c = T.STA__c; Tis.add(i); } } else if (rt.MESSAGECODE != '80013' && rt.MESSAGECODE != '80014') { T.STA__c = 'Failed'; for (g_TranItem__c i: T.Items__r) { i.STA__c = T.STA__c; Tis.add(i); } } T.gwrf__c = rt.DEGTRN; T.gwcd__c = rt.MESSAGECODE; if (rt.TRANSDATE != NULL && rt.TRANSDATE != '') T.gwdt__c = parseDateDEG(rt.TRANSDATE); T.gwmsg__c = rt.MESSAGE; if (rt.PAYMENTMETHOD != NULL && rt.PAYMENTMETHOD != '') T.md__c = rt.PAYMENTMETHOD; } } for (g_Tran__c T: courierB) { try { g_reqitem__c ri; for (g_TranItem__c i: T.Items__r) { if (i.itm__r.sta__r.Courier_Stage__c == 'Collection' || i.itm__r.sta__r.Courier_Stage__c == 'Delivery') { ri = i.itm__r; } } Boolean isCour = false; XMLParserforEmpostWebservice cour = new XMLParserforEmpostWebservice(); if (ri != null && (ri.sta__r.Courier_Stage__c == 'Collection' || ri.sta__r.Courier_Stage__c == 'Delivery') && !isCour) { cour.courierBooking(ri, T.RQ__r, false, ''); isCour = false; } } catch (Exception e) {} } if (trans != null) { update trans; } if (Tis != null) { update Tis; } for (g_Tran__c T: trans) { if (T.STA__c == 'Completed') { riIds.clear(); for (g_TranItem__c i: T.Items__r) { riIds.add(i.itm__c); } system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'); system.debug(T.RQ__r); grqH.rH h = new grqH.rH(); h.AP(T.RQ__r, T, riIds); } }  }
     */
    public void updateTransactions(Map < String, greccc.PaymentRes > repMap, list < g_Tran__c > trans) {
        List < g_Tran__c > courierB = new List < g_Tran__c > ();
        List < g_TranItem__c > Tis = new List < g_TranItem__c > ();
        Set < Id > riIds = new Set < Id > ();
        for (g_Tran__c T: trans) {
            if (repMap.containsKey(T.id)) {
                PaymentRes rt = repMap.get(T.id);
                if (rt.MESSAGECODE == '00' && (rt.STATE).touppercase() == 'CAPTURED' && (rt.THREEDS_STATUS).touppercase() == 'SUCCESS') {
                    T.STA__c = 'Completed';
                    g_reqitem__c ri;
                    for (g_TranItem__c i: T.Items__r) {
                        i.STA__c = T.STA__c;
                        Tis.add(i);
                        if (i.itm__r.sta__r.Courier_Stage__c == 'Collection' || i.itm__r.sta__r.Courier_Stage__c == 'Delivery') {
                            courierB.add(T);
                        }
                    }
                    T.niord__c = T.gwrf__c;
                    T.gwrf__c = rt.AUTHCODE;
                    T.gwcd__c = rt.MESSAGECODE;
                    T.gwdt__c = rt.updateTime;
                    T.gwmsg__c = rt.MESSAGE;
                } else if ((rt.STATE).touppercase() == 'STARTED') {
                    T.STA__c = 'Cancelled';
                    for (g_TranItem__c i: T.Items__r) {
                        i.STA__c = T.STA__c;
                        Tis.add(i);
                    }
                    T.gwmsg__c = rt.STATE;
                } else {
                    T.STA__c = 'Failed';
                    for (g_TranItem__c i: T.Items__r) {
                        i.STA__c = T.STA__c;
                        Tis.add(i);
                    }
                    T.gwmsg__c = rt.STATE;
                }
            }
        }
        for (g_Tran__c T: courierB) {
            try {
                g_reqitem__c ri;
                for (g_TranItem__c i: T.Items__r) {
                    if (i.itm__r.sta__r.Courier_Stage__c == 'Collection' || i.itm__r.sta__r.Courier_Stage__c == 'Delivery') {
                        ri = i.itm__r;
                    }
                }
                Boolean isCour = false;
                XMLParserforEmpostWebservice cour = new XMLParserforEmpostWebservice();
                if (ri != null && (ri.sta__r.Courier_Stage__c == 'Collection' || ri.sta__r.Courier_Stage__c == 'Delivery') && !isCour) {
                    cour.courierBooking(ri, T.RQ__r, false, '');
                    isCour = false;
                }
            } catch (Exception e) {}
        }
        if (trans != null) {
            update trans;
        }
        if (Tis != null) {
            update Tis;
        }
        for (g_Tran__c T: trans) {
            if (T.STA__c == 'Completed') {
                riIds.clear();
                for (g_TranItem__c i: T.Items__r) {
                    riIds.add(i.itm__c);
                }
                system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                system.debug(T.RQ__r);
                grqH.rH h = new grqH.rH();
                h.AP(T.RQ__r, T, riIds);
            }
        }
    }
    @TestVisible private DateTime parseDateDEG(String dt) {
        return datetime.valueOf(dt.substring(6, 10) + '-' + dt.substring(3, 5) + '-' + dt.substring(0, 2) + dt.substring(10, 19));
    }
}