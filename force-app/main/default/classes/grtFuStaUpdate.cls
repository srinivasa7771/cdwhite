@RestResource(urlMapping = '/FuStaUpdate/*')
global class grtFuStaUpdate {
   public List < ReqData > rqData;
    @HttpPost
    global static void doPost() {
        StatusResponse res = new StatusResponse();
        String reqBody = RestContext.request.requestBody.toString();
        ws_call__c wc = null;
        g_Tran__c t=null;
        try {
                system.debug('Req Body::' + reqBody);
                ReqData  reqd= (ReqData) JSON.deserialize(reqBody, ReqData.class);

                Data dataList=reqd.data;
                Data reqdata =new Data();
                //if (dataList != null && !dataList.isEmpty()) {
                reqdata=dataList;
                //}
                //ReqData reqdata= ReqData[0];
                String TransNo='NA';
               system.debug('=====reqdata.ReceiptNumber==='+reqdata.ReceiptNumber);

                if (reqdata.ReceiptNumber != null && (reqdata.ReceiptNumber).length()>0) {
                    TransNo=reqdata.ReceiptNumber;
                }else if (reqdata.TransactionNumber != null && (reqdata.TransactionNumber).length()>0) {
                    TransNo=reqdata.TransactionNumber;
                    TransNo=TransNo.replace('_DM' , '');

                }

                List<g_Tran__c> transList=[select id, name, OraReceiptStatus__c, OraReversalCategory__c,
                    DMTransactionNumber__c, ORAReversalReason__c, ORAReversalComment__c, DMCustomerTrnsactionId__c,
                    DMStatus__c, ORAErrorMessage__c from g_Tran__c where Name=:TransNo];
                if (transList != null && !transList.isEmpty()) {
                    t=transList[0];
                    t.OraReceiptStatus__c=reqdata.ReceiptStatus;
                    t.OraReversalCategory__c=reqdata.ReversalCategory;
                    t.ORAReversalReason__c=reqdata.ReversalReason;
                    t.ORAReversalComment__c=reqdata.ReversalComment;
                    t.DMCustomerTrnsactionId__c=reqdata.CustomerTransactionId;
                    t.DMTransactionNumber__c= reqdata.TransactionNumber;
                    t.DMStatus__c=reqdata.Status;
                    t.ORAErrorMessage__c=reqdata.ErrorMessage;

                    Update t;
                 res.msg = 'SUCCESS';
                 res.msgcode = '0';
                 res.status = 'S';
               }
            else{
                res.msg = 'Receipt not found';
                res.msgcode = 'F';
            }

        } catch (Exception e) {
            system.debug(e.getStackTraceString());
            res.msg = 'ERROR Message:'+e.getStackTraceString();
            res.msgcode = 'F';
        }
        system.debug('res Message::' + res.msg);
        RestContext.response.addHeader('Content-Type', 'application/json'); /*return res;*/
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
    }

    global class StatusResponse {
        webservice String msg {
            set;
            get;
        }
        webservice String msgcode {
            set;
            get;
        }
        webservice String status {
            set;
            get;
        }
        webservice String axsAccId {set;get;}
        webservice String axsSrNo {set;get;}
    }
    global class Data {
        webservice String ReceiptNumber, ReceiptStatus, ReversalCategory, ReversalReason, ReversalComment,
            TransactionNumber, CustomerTransactionId, Status, ErrorMessage;
    }
    global class ReqData {
        webservice String Method;
        webservice Data data;
    }

}