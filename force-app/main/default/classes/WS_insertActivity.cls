@RestResource(urlMapping='/insertactivity/*')
global class WS_insertActivity {

    @HttpPost
    global static void postRequest() {
        RestContext.response.addHeader('Content-Type', 'application/json');
        rqResp resp = new rqResp();
        String reqBody = RestContext.request.requestBody.toString();
        String AccountId = null;
        System.debug('reqBody: ' + reqBody);
        ReqData rqData = (ReqData)JSON.deserialize(reqBody, ReqData.class);
        try{
            system.debug('rqData.AccountId>>'+rqData.AccountId);
            if ((rqData.AccountId == null || !String.isNotBlank(rqData.AccountId))) {
                system.debug('rqData.AccountId>> is null');
                AccountId =Label.insertactivityDefaultAccount;
            }
            else{
                system.debug('rqData.AccountId>> is not null');
                AccountId =rqData.AccountId;
            }
            system.debug('AccountId >>'+ AccountId);
            if (rqData != null && AccountId != null && String.isNotBlank(AccountId)) {
                list<Account> acLst = [Select id from Account where id=: AccountId Limit 1];
                if (acLst != null && acLst.size()>0) {
                    Task tsk = new Task();
                    /*tsk.Owner = rqData.AssignedTo;
                    */ tsk.WhatId = acLst[0].id;
                    tsk.Subject = rqData.Subject;
                    tsk.Brand__c = rqData.Brand;
                    tsk.IVRLanguage__c = rqData.IVRLanguage;
                    if (rqData.CallType != null) tsk.CallType = rqData.CallType;
                    tsk.Last_IVR_Menu__c = rqData.LastIvrMenu;
                    tsk.Disposition__c = rqData.Disposition;
                    tsk.Transfer_to_Survey__c = rqData.TransferToSurvey;
                    if (rqData.CallDurationInSeconds != null) tsk.CallDurationInSeconds = Integer.valueOf(rqData.CallDurationInSeconds);
                    tsk.CallObject = rqData.callObject;
                    if (rqData.Rating != null) tsk.Rating__c = Integer.valueOf(rqData.Rating);
                    tsk.Interaction_Link__c = rqData.InteractionLink;
                    tsk.ActivityDate = Date.today();
                    tsk.Status = 'Completed';
                    /*rqData.Status;
                    */ tsk.Priority = 'Normal';
                    /*rqData.Priority;
                    */ tsk.Description = rqData.comments;
                    tsk.Agent__c=rqData.Agent;
                    tsk.Phone__c = rqData.Phone;
                    if (Schema.sObjectType.Task.isCreateable()) {
                        insert tsk;
                    }
                    system.debug('inserted tsk >>'+tsk);
                    resp.status = 'Success';
                    resp.respMsg = 'Activity Inserted Successfully.';
                    resp.respCode='0';
                    resp.recordId = tsk.id;
                    system.debug('Success resp >>'+resp);
                }
            }
            else{
                resp.status = 'Failed';
                resp.respMsg = 'Specified Account Not Found.';
                resp.respCode='1';
                system.debug('Failed resp >>'+resp);
            }
        }
        catch (Exception ex) {
            resp.status = 'Failed';
            resp.respMsg = ex.getMessage();
            resp.respCode='1';
            system.debug('Exception resp >>'+resp);
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }

    global class ReqData {

        webService  String  Subject;
        webService  String Brand;
        webService  String IVRLanguage;
        webService  String CallType;
        webService  String LastIvrMenu;
        webService  String Disposition;
        webService  String TransferToSurvey;
        webService  Integer CallDurationInSeconds;
        webService  String callObject;
        webService  Integer Rating;
        webService  String InteractionLink;
         webService  String Agent;
        webService  String AccountId;
        webService  String Phone;
        webService  String  comments;

        webService String taskId;

    }

    global class rqResp {webService String respCode, status, respMsg, recordId;}

}