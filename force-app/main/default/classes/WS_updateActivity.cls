@RestResource(urlMapping='/updateactivity/*')
global class WS_updateActivity {

    @HttpPost
    global static void postRequest() {
        RestContext.response.addHeader('Content-Type', 'application/json');
        rqResp resp = new rqResp();
        String reqBody = RestContext.request.requestBody.toString();
        /*String reqBody = req.requestBody.toString();
        */ System.debug('reqBody: ' + reqBody);
        WS_updateActivity.ReqData rqData = (WS_updateActivity.ReqData) JSON.deserialize(reqBody, WS_updateActivity.ReqData.class);
        /*resp.axsId = lstRq[0].Id;
        resp.SRN = lstRq[0].Name;
        resp.conID = lstRq[0].Con__c;
        */ list < Task > t = [select id, Rating__c, whatid from task where CallObject =: rqData.taskId];
        if (t != null && t.size() > 0) {
            if (String.isBlank(t[0].whatid)) {
                t[0].whatid = Label.insertactivityDefaultAccount;
            }
            t[0].Rating__c = rqData.rating;
            if (Schema.sObjectType.Task.isUpdateable()) {
                update t;
            }
            resp.status = 'Success';
            resp.respMsg = 'Activity updated Successfully.';
            resp.respCode = '0';
        }
        else {
            resp.status = 'Failed';
            resp.respMsg = 'Activity not found.';
            resp.respCode = '1';
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }

    global class ReqData {
        webService String taskId;
        webService Integer rating;
    }

    global class rqResp {webService String respCode, status, respMsg;}

}