@RestResource(urlMapping='/AXSCSWS/*')
global class AXS_Call_Center_WS
{
    @HttpPost
    global static AXSJsonResponse doPost(String Function, Map<String, String> Params) {
        try
        {
            if (Function == 'UpdateRating') { return UpdateCallRating(Params);}
            if (Function == 'Status') {return new AXSJsonResponse(True, '', '', 'All Systems are Working : ' + System.Now(), 0);}
            else {return new AXSJsonResponse(false, '', '', 'No Function Specified / Invalid Function', 0); }
        }
        catch (exception ex) {return new AXSJsonResponse(false, '', '', ex.getMessage() + ' ' +ex.getStackTraceString(), 0);}
    }

    private static AXSJsonResponse UpdateCallRating(Map<String, String> Params) {
        try
        {
            String CallObjectId = params.get('CallObjectId');
            Integer rating = Integer.ValueOf(params.get('Rating'));

            List<Task> lstActivities = new list<Task>();
            lstActivities = [Select Id, whatid from Task Where CallObject =: CallObjectId];
            if (lstActivities == null || lstActivities.Size() ==0) {return new AXSJsonResponse(false, 'Task', '', 'No Task found with Call Object Id ' + CallObjectId + ' .', 0);}

            /*Task ac = lstActivities.get(0);*/
            Task ac = new Task();
            ac.id= lstActivities[0].id;
            if (String.isBlank(lstActivities[0].whatid))
              ac.whatid = Label.insertactivityDefaultAccount;
            //TODO : Add Rating Field and update it
            ac.Rating__c = Decimal.Valueof(rating);
            if (Schema.sObjectType.Task.isUpdateable()) {
                update ac;
            }
            return new AXSJsonResponse(true, 'Task', ac.Id, '', 201);
        }
        catch (exception ex) {
            return new AXSJsonResponse(false, '', '', ex.getMessage() + ' ' +ex.getStackTraceString(), 0);
        }
    }

    global class AXSJsonResponse
    {
        public Boolean success {get;set;}
        public String ObjectName {get;set;}
        public String ObjectID {get;set;}
        public String Error {get;set;}
        public Integer ResponseCode {get;set;}

        public AXSJsonResponse(Boolean iSuccess, String iObjectName, String iOBjectID, String ierror, Integer rCode) {
            success = iSuccess;
            ObjectName = iObjectName;
            ObjectID = iObjectID;
            error = iError;
            responseCode = rCode;
        }
    }
}