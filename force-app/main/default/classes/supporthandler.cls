public class supporthandler {
    public static void IB(List < Issue_Tracker__c > listsupport) {
        Id ownerqueid ;
        List < BusinessHours > mBH = [select id from BusinessHours where IsDefault = true];
        List <Id> reqIds=new List <Id>(); List <Id> userIds=new List <Id>();
        for (Issue_Tracker__c i: listsupport) {userIds.add(i.CurrentUser__c);}

        List<User> users=[Select Id, Name, Email, ContactId, accountId, Profile.Name from User where Id in :userIds and isActive = true];
        Map<Id, User> UserFromUserId = new Map<Id, User>();
        for (User u: users){UserFromUserId.put(u.Id, u);}
        for (Issue_Tracker__c i: listsupport) {
            if (i.Account__c == null) {
               if (i.Type__c=='Contact us'){i.Channel__c='Contact us';}
                if (i.Type__c!='Contact us' && UserFromUserId.get(i.CurrentUser__c).Profile.Name=='CC'){i.Channel__c='Phone';}
                if (i.Request__c <> null){reqIds.add(i.Request__c);}
                if (i.Type__c!='Contact us' && UserFromUserId.get(i.CurrentUser__c).Profile.Name<>'CC'){
                    i.Account__c = (UserFromUserId.get(i.CurrentUser__c).AccountId != null) ? UserFromUserId.get(i.CurrentUser__c).AccountId : i.Account__c;
                }
            }

            //Decimal dThresholdHrs = gU.csNum('Threshold Hours');
            i.Threshold_Date__c = BusinessHours.add(mBH[0].id, System.now(), 60 * 60 * 1000L * 12);

            //Decimal dClosureHrs = gU.csNum('Closure Hours');
            i.Estimated_Date__c = BusinessHours.add(mBH[0].id, System.now(), 60 * 60 * 1000L * 16);

        }
        if (reqIds!=null && reqIds.size()>0){
            List <g_Req__c> reqAcc=[Select g.Id, g.Acc__c From g_Req__c g where id in :reqIds];
            Map<Id, Id> AccIdFromReqId = new Map<Id, Id>();
            for (g_Req__c r: reqAcc){AccIdFromReqId.put(r.Id, r.Acc__c);}
            for (Issue_Tracker__c i: listsupport) {
                if (i.Account__c == null) {
                    if (i.Request__c <> null && UserFromUserId.get(i.CurrentUser__c).Profile.Name=='CC'){i.Account__c=AccIdFromReqId.get(i.Request__c);}
                }
            }
        }
    }
    public static void IA(List < Issue_Tracker__c > listsupport) {
    try{
        List<FeedItem> fitems=new List<FeedItem>();
         for (Issue_Tracker__c i: listsupport) {
          if (i.Type__c=='Enquiry' || i.Type__c=='Complaints' || i.Type__c=='Compliment' || i.Type__c=='Feedback'){
           FeedItem fitem = new FeedItem(Body='', ParentId = i.Id, Type='TextPost');
            if (i.Type__c=='Compliment'){
                fitem.Body='Thank you.';
            }
            else{
                fitem.Body='Thank you for connecting with us. We will attend to you shortly.';
            }
            fitem.Visibility='AllUsers';
            fitem.CreatedById='00520000003dOFe';
            fitems.add(fitem);
            }
         }
        SObjectAccessDecision secDec = Security.stripInaccessible(AccessType.CREATABLE, fitems);
        insert secDec.getRecords();
    } catch (Exception e){system.debug(e.getStackTraceString());}
}
    public static void UB(Map < id, Issue_Tracker__c > newMap, Map < id, Issue_Tracker__c > oldMap) {
        BusinessHours mBH = [select id from BusinessHours where IsDefault = true];
        List<FeedItem> fitems=new List<FeedItem>();
        List <Id> reqIds=new List <Id>();
        for (Issue_Tracker__c i: newMap.values()) {
            Issue_Tracker__c old = oldMap.get(i.id);
            if (old != null && old.OwnerId <> i.OwnerId && i.Status__c == 'In Process') {
                i.Assignment_Date__c=System.now();
                long businessMillisecondsDiff = BusinessHours.diff(mBH.Id, i.createddate, i.Assignment_Date__c);
                decimal businessHoursDiff = businessMillisecondsDiff / (1000.0*60.0*60.0);
                i.Assignment_Duration__c = businessHoursDiff;
            }
            if (old != null && old.Acknowledge__c==true && i.Acknowledge__c==false){
                i.addError('Can not uncheck acknowledge once checked. Thank you.');
            }
            if (old != null && old.Status__c == 'Closed' && i.Status__c == 'In Process') {
                i.addError('Can not change status from [Closed] to [In Process]. Please submit new ticket. Thank you.');
            }
            else if (old != null && old.Status__c == 'In Process' && i.Status__c == 'Closed') {
                i.Closure_date__c = System.now();
                if (i.Assignment_Date__c<>null){
                    long businessMillisecondsDiff = BusinessHours.diff(mBH.Id, i.Assignment_Date__c, i.Closure_date__c);
                    decimal businessHoursDiff = businessMillisecondsDiff / (1000.0*60.0*60.0);
                    i.Actual_Closure_Duration__c = businessHoursDiff;
                }
                if (i.Type__c=='Enquiry' || i.Type__c=='Complaints' || i.Type__c=='Compliment' || i.Type__c=='Feedback'){
                FeedItem fitem = new FeedItem(Body='', ParentId = i.Id, Type='TextPost');
                fitem.Body='Your ticket has been resolved. Thank you.';
                fitem.Visibility='AllUsers';
                fitem.CreatedById='00520000003dOFe';
                fitems.add(fitem);
                }
            }
            if (i.Account__c == null) {
                if (i.Request__c <> null){
                    reqIds.add(i.Request__c);
                }
            }
        }
        SObjectAccessDecision secDec2 = Security.stripInaccessible(AccessType.CREATABLE, fitems);
        insert secDec2.getRecords();
        if (reqIds.size()>0){
            List <g_Req__c> reqAcc=[Select g.Id, g.Acc__c From g_Req__c g where id in :reqIds];
            Map<Id, Id> AccIdFromReqId = new Map<Id, Id>();
            for (g_Req__c r: reqAcc){
                AccIdFromReqId.put(r.Id, r.Acc__c);
            }
            for (Issue_Tracker__c j: newMap.values()) {
                if (j.Account__c == null) {
                    if (j.Request__c <> null){
                        j.Account__c=AccIdFromReqId.get(j.Request__c);
                    }
                }
            }
        }
    }

}