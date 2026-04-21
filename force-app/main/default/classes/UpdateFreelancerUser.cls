public class UpdateFreelancerUser implements Database.Batchable < sObject > , Database.AllowsCallouts {
    public String query;
    public UpdateFreelancerUser() {
        query = 'SELECT Id, Name, contact.account.lc__c, isFrl__c, contact.account.Name, accname__c, Licvalid__c from user WHERE contact.account.Legal_Framework__c=\'Freelancer\' and isactive=true and lastModifiedDate=today and profile.name=\'Z\' LIMIT 100';
    }
    public UpdateFreelancerUser(String tp) {
        query = 'SELECT Id, Name, contact.account.lc__c, isFrl__c, contact.account.Name, accname__c, Licvalid__c from user WHERE contact.account.Legal_Framework__c=\'Freelancer\' and isactive=true and lastModifiedDate=today and profile.name=\'Z\' LIMIT 100';
        if (tp == 'all') query = 'SELECT Id, Name, contact.account.lc__c, isFrl__c, contact.account.Name, accname__c, Licvalid__c from user WHERE contact.account.Legal_Framework__c=\'Freelancer\' and isactive=true and profile.name=\'Z\'';
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        /*String query = 'SELECT Id, Name, contact.account.lc__c, isFrl__c, contact.account.Name, accname__c, Licvalid__c from user WHERE contact.account.Legal_Framework__c=\'Freelancer\' and isactive=true and lastModifiedDate=today and profile.name=\'Z\' LIMIT 100'; */
        if (query != null) return Database.getQueryLocator(query);
        return null;
    }
    public void execute(Database.BatchableContext BC, List < User > lstUsers) {
        String userActivities = fetchUserDetails(lstUsers);
        System.debug(' <execute> userActivities : ' + userActivities);
        if (String.isNotBlank(userActivities)) {
            lstUsers[0].seg__c = userActivities;
            lstUsers[0].isFrl__c = 'true';
            lstUsers[0].accname__c = lstUsers[0].contact.account.Name;
            lstUsers[0].Licvalid__c = 'true';
            System.debug(' <execute> userActivities : ' + lstUsers[0].Id);
            if (Schema.sObjectType.User.isUpdateable()) { update lstUsers[0]; }
        }
    }
    public void finish(Database.BatchableContext BC) {}
    public String fetchUserDetails(List < User > lstUsers) {
        Map < String, String > DDAactmap = new Map < String, String > ();
        list < DDA_Activities__c > DDAact = [select id, DDA_Activity_ID__c, Activities__c from DDA_Activities__c];
        for (DDA_Activities__c d: DDAact) {
            DDAactmap.put(d.Activities__c, d.DDA_Activity_ID__c);
        }
        String segmentDetails = '';
        String lcn = lstUsers[0].contact.account.lc__c;
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setHeader('Content-Length', '0');
        request.setEndpoint('callout:DCCA_Auth/apexrest/RnLIntegrationActLoc?licenseno=' + lcn + '&method=getActivities');
        request.setTimeout(120000);
        request.setMethod('POST');
        response = h.send(request);
        if (response.getStatusCode() == 200) {
            system.debug(response.getBody());
            grqWsDccaGetService.ActivityLocations allAct = new grqWsDccaGetService.ActivityLocations();
            List < grqWsDccaGetService.Activities > dccaActList = new List < grqWsDccaGetService.Activities > ();
            allAct = (grqWsDccaGetService.ActivityLocations) JSON.deserialize(response.getBody(), grqWsDccaGetService.ActivityLocations.class);
            if (allAct.act != null) {
                dccaActList = allAct.act;
                if (dccaActList.size() > 0) {
                    for (grqWsDccaGetService.Activities a: dccaActList) {
                        if (a != null && (segmentDetails.length() + a.ActivityId.length() + a.Name.length()) < 255) {
                            if (DDAactmap != null && !DDAactmap.isEmpty() && DDAactmap.containsKey(a.Name)) {
                                segmentDetails += DDAactmap.get(a.Name) + '|' + a.Name + ';';
                            }
                        }
                    }
                }
                return segmentDetails;
            }
        }
        return segmentDetails;
    }
    /*public String fetchUserDetails2(List<User> lstUsers) { String segmentDetails=''; String lcn = lstUsers[0].contact.account.lc__c;Http h = new Http(); HttpRequest request = new HttpRequest(); HttpResponse response = new HttpResponse(); request.setHeader('Content-Type', 'application/json'); request.setHeader('accept', 'application/json'); request.setHeader('Content-Length', '0');request.setEndpoint('callout:DCCA_Auth/apexrest/RnLIntegrationActLoc?licenseno=' + lcn + '&method=getActivities'); request.setTimeout(120000);       request.setMethod('POST');response = h.send(request);  if (response.getStatusCode() == 200) { system.debug(response.getBody());grqWsDccaGetService.ActivityLocations  allAct = new grqWsDccaGetService.ActivityLocations(); List<grqWsDccaGetService.Activities> dccaActList = new List<grqWsDccaGetService.Activities>(); allAct = (grqWsDccaGetService.ActivityLocations) JSON.deserialize( response.getBody(), grqWsDccaGetService.ActivityLocations.class); if (allAct.act != null) {dccaActList = allAct.act; if (dccaActList.size()>0) {for (grqWsDccaGetService.Activities a : dccaActList) {if (a != null && (segmentDetails.length() + a.ActivityId.length() + a.Name.length())<255) {segmentDetails += a.ActivityId+'|'+a.Name+';';}   }}return segmentDetails;} } return segmentDetails; }*/
}