@RestResource(urlMapping = '/smsservices/*')
global class SMSService {
    @HttpPost
    global static void postData() { RestRequest req = RestContext.request; RestResponse res = RestContext.response; String reqBody = req.requestBody.toString(); system.debug('reqBody::::::::' + reqBody); ReqData rqData = (ReqData) JSON.deserialize(reqBody, ReqData.class); String rqNo = rqData.reqNumber + '%'; String reqNo = rqData.reqNumber; String mobNo = rqData.mobileNumber; rqResp resp = new rqResp(); list < g_req__c > t = [SELECT id, Name, Acc__r.VIP__c, SLA_Status__c, amsgs__c, i_STA__c, xcfn__c, xcslt__c FROM g_req__c WHERE Name LIKE: rqNo and CreatedDate = last_N_days: 366 limit 1]; if (t.size() > 0) { system.debug('mobNo::::::::' + mobNo); String status = sendSMS(t[0], mobNo); if (status == 'sent') { resp.status = status; resp.respMsg = 'Success'; resp.respCode = '0'; } else { resp.status = status; resp.respMsg = 'Failed'; resp.respCode = '1'; } } else if (t.size() == 0) { res.statusCode = 404; resp.status = 'Not Found'; resp.respMsg = 'Request number not found '; resp.respCode = '0'; } res.addHeader('Content-Type', 'application/json'); res.responseBody = Blob.valueOf(JSON.serialize(resp)); }
    /*{"requestId":"409686431703865190852903","destination":"971554480164","validUnitlTimestamp":"2021-06-29 06:17:51","createdTimestamp":"2021-06-29 06:07:51","lastEventTimestamp":"2021-06-29 06:07:51","status":"Sent"}*/
    public static void otpInfo(String mobileNumber,String rqId){

        system.debug('mobileNumber::::::::::::' + mobileNumber);
        String apiKey = LABEL.SMSAPIKEY;//'d17e86039c3a547655e34d532309a849'; //'b957d3a7990b0c4c1941b27492a3865e';
        String apiSecret = LABEL.SMSAPISECRET;//'4211228b248a5f68d9351bfe2ebcedd3'; //a9e642f177462e036749aecedb1ad0b3';
        String reqMethod = 'GET';
        String reqURI = '/v2/sms?destination='+mobileNumber+'&limit=1';
        String host = 'api.smsglobal.com';
        String port = '443';
        String endPoint = 'https://api.smsglobal.com/v2/sms?destination='+mobileNumber+'&limit=1';
        String timeStamp = getTimeStamp();
        String nonce = generateNonce();
        String hash = generateHash(timeStamp, nonce, reqMethod, reqURI, host, port, apiSecret);
        String headerValue = 'id="' + apiKey + '",ts="' + timeStamp + '",nonce="' + nonce + '",mac="' + hash + '"';
        String authorizationHeader = 'MAC ' + headerValue;
        HttpRequest req = New HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', 'application/json');
        req.setTimeout(90000);
        req.setEndPoint(endPoint);
        req.setMethod(reqMethod);
        Http http = New Http();
        HTTPResponse res = http.send(req);
        String responseBody = res.getBody();
        system.debug('responseBody::::::::' + responseBody);
        JSONParser parser = JSON.createParser(responseBody);
        String status ='';
        String message='';

        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status')) {
                parser.nextToken();
                status = parser.getText();
            }
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'message')) {
                parser.nextToken();
                message = parser.getText();
            }
        }
        system.debug('status::'+status+':message::'+message);
        if ( String.isNotBlank(status) && String.isNotBlank(message) && (status == 'Sent' || status == 'delivered')){
            List<g_reqitem__c> riLst =  [select id,rq__r.xceml__c from g_reqitem__c where RQ__c=:rqId and itm__r.cd__c in ('dr','frl')];
            if (riLst != null && !riLst.isEmpty()){
                ws_call__c ws = new ws_call__c();
                ws.mtd_nm__c = 'OTP';
                ws.rq_jsn__c = message;
                ws.rq_itm__c = riLst[0].id;
                ws.Rq_email__c = riLst[0].rq__r.xceml__c;
                insert ws;
            }
        }
    }
    public static String sendSMS(g_Req__c rq,String x){ return null;}
    public static String sendOTP( String mobileNumber,String rqId) {
        system.debug('mobileNumber::::::::::::' + mobileNumber);
        String apiKey = LABEL.SMSAPIKEY;//'d17e86039c3a547655e34d532309a849'; //'b957d3a7990b0c4c1941b27492a3865e';
        String apiSecret = LABEL.SMSAPISECRET;//'4211228b248a5f68d9351bfe2ebcedd3';
        String reqMethod = 'POST';
        String reqURI = '/v2/otp';
        String host = 'api.smsglobal.com';
        String port = '443';
        String endPoint = 'https://api.smsglobal.com/v2/otp';
        String timeStamp = getTimeStamp();
        String nonce = generateNonce();
        String hash = generateHash(timeStamp, nonce, reqMethod, reqURI, host, port, apiSecret);
        String headerValue = 'id="' + apiKey + '",ts="' + timeStamp + '",nonce="' + nonce + '",mac="' + hash + '"';
        String authorizationHeader = 'MAC ' + headerValue;
        SMSReqWrapper wrapper = new SMSReqWrapper();
        wrapper.origin = 'axs';
        //wrapper.message = '{*code*} is your one time password (OTP) for freelance license setup. Do not share it with anyone.'; //
        wrapper.message = 'Your OTP is {*code*}. Please do not share your OTP with anyone.';
        wrapper.length= 6;
        wrapper.destination = mobileNumber;
        String postDataStr = JSON.serialize(wrapper);
        system.debug('postDataStr::::::::' + postDataStr);
        HttpRequest req = New HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', 'application/json');
        req.setBody(postDataStr);
        req.setEndPoint(endPoint);
        req.setMethod(reqMethod);
        Http http = New Http();
        HTTPResponse res = http.send(req);
        String responseBody = res.getBody();
        system.debug('responseBody::::::::' + responseBody);
        JSONParser parser = JSON.createParser(responseBody);
        String status;
        String requestId='NA';
        String destinationNo='';
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status')) {
                parser.nextToken();
                status = parser.getText();
            }
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'requestId')) {
                parser.nextToken();
                requestId = parser.getText();
            }
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'destination')) {
                parser.nextToken();
                destinationNo = parser.getText();
            }
        }
        if (String.isNotBlank(requestId) && String.isNotBlank(status) && (status == 'Sent' || status == 'delivered'))
            otpInfo(destinationNo,rqId);
        If(String.isBlank(requestId) || requestId=='NA'){
            requestId ='ERROR:' + responseBody;
        }
        return requestId;
    }
    public static String  otpValidate( String requestId,String userCode) {

        system.debug('requestId::' + requestId + '  ::userCode:: ' + userCode);
        String apiKey = LABEL.SMSAPIKEY;//'d17e86039c3a547655e34d532309a849'; //'b957d3a7990b0c4c1941b27492a3865e';
        String apiSecret = LABEL.SMSAPISECRET;//'4211228b248a5f68d9351bfe2ebcedd3';

       // String apiKey = 'd17e86039c3a547655e34d532309a849';//'b957d3a7990b0c4c1941b27492a3865e';
       // String apiSecret ='4211228b248a5f68d9351bfe2ebcedd3';//'a9e642f177462e036749aecedb1ad0b3';
        String reqMethod = 'POST';
        String reqURI = '/v2/otp/requestid/'+requestId+'/validate';
        String host = 'api.smsglobal.com';
        String port = '443';
        String endPoint = 'https://api.smsglobal.com/v2/otp/requestid/'+requestId+'/validate';
        String timeStamp = getTimeStamp();
        String nonce = generateNonce();
        String hash = generateHash(timeStamp, nonce, reqMethod, reqURI, host, port, apiSecret);
        String headerValue = 'id="' + apiKey + '",ts="' + timeStamp + '",nonce="' + nonce + '",mac="' + hash + '"';
        String authorizationHeader = 'MAC ' + headerValue;

        SMSValidate wrapper=new SMSValidate();
        wrapper.code = userCode;
        String postDataStr = JSON.serialize(wrapper);
        system.debug('postDataStr::::::::' + postDataStr);
        HttpRequest req = New HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Accept', 'application/json');
        req.setBody(postDataStr);
        req.setEndPoint(endPoint);
        req.setMethod(reqMethod);
        Http http = New Http();
        HTTPResponse res = http.send(req);
        String responseBody = res.getBody();
        system.debug('responseBody::::::::' + responseBody);
        JSONParser parser = JSON.createParser(responseBody);
        system.debug('parser::::::::' + parser);
        String status = res.getStatus();

        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status')) {
                parser.nextToken();
                status = parser.getText();
            }

        }
        return status;
    }
    // SECURITY: Removed sensitive debug log
    @TestVisible private static String getTimeStamp() {
        DateTime dateTimeNow = dateTime.now();
        return '' + (dateTimeNow.getTime() / 1000);
    }
    @TestVisible private static String generateNonce() {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < 32) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx + 1);
        }
        return EncodingUtil.base64Encode(Blob.valueOf(randStr)).remove('=');
    }
    @TestVisible private static String generateHash(String timeStamp, string nonce, String reqMethod, string reqURI, String host, string port, string apiSecret) {
        String hashString = timeStamp + '\n' + nonce + '\n' + reqMethod + '\n' + reqURI + '\n' + host + '\n' + port + '\n\n';
        Blob hmacData = Crypto.generateMac('HmacSHA256', Blob.valueOf(hashString), Blob.valueOf(apiSecret));
        return EncodingUtil.base64Encode(hmacData);
    }
    public class ReqData {
        public String reqNumber;
        public String mobileNumber;
    }
    global class rqResp {
        webService String respCode, status, respMsg;
    }
    public class SMSValidate {
        public String code {
            get;
            set;
        }
    }
    public class SMSReqWrapper {
        public String origin {
            get;
            set;
        }
        public String destination {
            get;
            set;
        }
        public String message {
            get;
            set;
        }
        public integer length {
            get;
            set;
        }



    }
}