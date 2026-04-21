@RestResource(urlMapping='/edlaxsint/*')
global class WS_EdlAxs {

    @HttpPost
    global static void postRequest() {
        RestContext.response.addHeader('Content-Type', 'application/json');
        List<Token_Details__c> tkList = new List<Token_Details__c>();
        String reqBody  = RestContext.request.requestBody.toString(); //String reqBody = req.requestBody.toString();
        System.debug('reqBody: ' + reqBody);

        WS_EdlAxs.TokenDetails tokenDetails = (WS_EdlAxs.TokenDetails)JSON.deserialize(reqBody, WS_EdlAxs.TokenDetails.class);
        // System.debug('TokenDetails: ' + tokenDetails);
        List<ReqData> listRqData = tokenDetails.TokenDetails;

        for (ReqData rq : listRqData) {
            Token_Details__c tk = new Token_Details__c();
            tk.assistanceSubType__c = rq.assistanceSubType;
            tk.assistanceTime__c = Integer.valueof(rq.assistanceTime);
            tk.assistanceType__c = rq.assistanceType;
            tk.CounterNumber__c = rq.CounterNumber;
            tk.entityID__c = rq.entityID;
            tk.entityName__c = rq.entityName;
            tk.mobileNumber__c = rq.mobileNumber;
            tk.serviceName__c = rq.serviceName;
            tk.subServiceSelection__c = rq.subServiceSelection;
            tk.ticketIssueTime__c = DateTime.valueOf((rq.ticketIssueTime).replaceAll('/', '-'));
            tk.ticketNumber__c = rq.ticketNumber;
            tk.ticketType__c = rq.ticketType;
            tk.user__c = rq.user;
            tk.waitingTime__c = Integer.valueof(rq.waitingTime);
            tkList.add(tk);
        }
        if (tkList.size()>0) {
            try{
                if (Schema.sObjectType.Token_Details__c.isCreateable()) {
                    insert tkList;
                }
            }catch (exception e) {System.debug('exception===='+e);}
        }

        rqResp resp = new rqResp();

        if (listRqData.size()>0 && String.isNotBlank(listRqData[0].entityID)) {
            resp.status = 'Success'; resp.respMsg = 'Data Inserted Sucessfully.'; resp.respCode='0';
        }else{
            resp.status = 'Failed to Insert.';   resp.respCode='1';
            resp.respMsg = 'Technical error. Please try after some time or contact axs-support.';
        }

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }

    global class ReqData {
        webService String entityID, entityName, mobileNumber, waitingTime, assistanceTime, serviceName, subServiceSelection, assistanceSubType, assistanceType;
        webService String ticketNumber, ticketIssueTime, CounterNumber, user, ticketType;
    }

    global class TokenDetails {
        webService List<ReqData> TokenDetails;
    }

    global class rqResp {webService String respCode, status, respMsg;}

}