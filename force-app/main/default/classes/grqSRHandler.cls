public class grqSRHandler{
    public static boolean isSrTrigger = true;
    public static void  createCase(List<Survey_Request__c> surReqList) {
        system.debug('createCase:::::');
        Set<Id> reqIds = new Set<Id>();
        Set<Id> SRIds = new Set<Id>();
        Set<String> SRNames = new Set<String>();
        Set<String> surNameswithCase1 = new Set<String>();
        Map<String, Case> surNameswithCase=new  Map<String, Case>();

        for (Survey_Request__c sr:surReqList) {
            reqIds.add(sr.Request__c);
            SRIds.add(sr.id);
            SRNames.add(sr.Name);
        }
        system.debug('SR Names::'+SRNames);
        List <case> caseList = new List<case>();
         List <case> upcaseList = new List<case>();
        caseList = [select id, Survey_Number__c, Description, Survey_Ans__c, Rating_Score__c from Case where Survey_Number__c<>null and Survey_Number__c=: SRNames];
        for (Case c : caseList) {
            surNameswithCase.put(c.Survey_Number__c, c);
        }
        system.debug('reqIds::::'+reqIds);
        Map<Id, g_Req__c> reqMap = new Map<Id, g_Req__c>();
        Map<String, Answer__c > srIdAnsMap = new Map<String, Answer__c >();
        Map<String, integer> srIdAnsValMap = new Map<String, integer>();
        Set<String> surSet = new Set<String>();
        Map<String, Case> surCaseMapToInsert = new Map<String, Case>();
        Map<String, g_Tran__c> transMap = new Map<String, g_Tran__c>();

        List<g_Req__c> reqList =[SELECT id, Acc__c, Acc__r.name, srvc__r.Name, Name, Con__c, rmob__c FROM g_Req__c WHERE ID=: reqIds];
        List<g_Tran__c> transList=[select id, CreatedBy.contactId, RQ__r.Name, RQ__c from g_Tran__c where RQ__c=:reqIds];

        List<Answer__c> answers=[select Answer_by_customer__c, Comments__c, Survey_Request__r.Owner.Name,
            Survey_Request__c, Survey_Request__r.Name, Value__c  from Answer__c where Survey_Request__c =:SRIds];
        system.debug('answers--'+answers);
        system.debug('SRIds--'+SRIds);

        for (Answer__c ans :answers) {
            if (ans.Answer_by_customer__c != null && ans.Answer_by_customer__c != '') {
                srIdAnsMap.put(ans.Survey_Request__r.Name, ans);
            }
            if (ans.Value__c != null) {
                srIdAnsValMap.put(ans.Survey_Request__r.Name, integer.valueOf(ans.Value__c));
            }
        }
        system.debug('srIdAnsMap--'+srIdAnsMap);
        for (g_Req__c req: reqList) {
            reqMap.put(req.id, req);
        }
        for (g_Tran__c ts: transList) {
            transMap.put(ts.RQ__c, ts);
        }

        system.debug('reqMap--'+reqMap);
        List<Case> insertCaselist = new List<Case>();
        Group axsqueue = [Select Id from Group where Name = 'AXS-VOC Contact Center'];

        for (Survey_Request__c sr :surReqList) {
            system.debug('sr.Survey_Score__c--'+sr.Survey_Score__c);
            if (sr.Survey_Score__c != null && (sr.Survey_Score__c == 1 ||sr.Survey_Score__c == 2 || sr.Survey_Score__c == 3)) {
                String bkRes='';
                if (sr.Back_Office_Response__c != null && sr.Back_Office_Response__c != '') {
                    bkRes = sr.Back_Office_Response__c;
                }
                String sub=Sr.Category__c+' survery response from customer '+ reqMap.get(sr.Request__c).Acc__r.name;
                String description =sr.Name;
                String srAns ='', rating = '';
                system.debug('description:'+description);
                system.debug('SR Comments:'+((!srIdAnsMap.isEmpty() && srIdAnsMap.containskey(sr.Name))?srIdAnsMap.get(sr.Name).Comments__c:''));
                if (!srIdAnsMap.isEmpty() && srIdAnsMap.get(sr.Name).Comments__c != null && srIdAnsMap.get(sr.Name).Comments__c!='') {
                    description=srIdAnsMap.get(sr.Name).Comments__c;
                    srAns=srIdAnsMap.get(sr.Name).Answer_by_customer__c;
                }
                if (!srIdAnsValMap.isEmpty() && srIdAnsValMap.containsKey(sr.Name) && srIdAnsValMap.get(sr.Name) != null) {
                    rating = String.valueOf(srIdAnsValMap.get(sr.Name));

                }
                system.debug('description1:'+description);
                if (!surNameswithCase.containskey(sr.Name)) {
                Case c = new Case(Status='Open',
                                  Survey_Ans__c=srAns,
                                  Rating_Score__c = rating,
                                  //RecordTypeId='0126D000001uIde',
                                  RecordTypeId = Label.SurRecType,
                                  Subject=sub, Survey_Category__c=Sr.Category__c,
                                  Description = description,
                                  Escalated_to__c='AXS-VOC Contact Center',
                                  Survey_Number__c=sr.Name,
                                  OwnerId =axsqueue.id,
                                  Origin='Survey',
                                  Request__c=sr.Request__c,
                                  AccountId=reqMap.get(sr.Request__c).Acc__c,
                                  ContactId =(!transMap.isEmpty() && transMap.get(sr.Request__c).CreatedBy.contactId != null)?transMap.get(sr.Request__c).CreatedBy.contactId:reqMap.get(sr.Request__c).Con__c,
                                  Secondary_Email_Id__c =sr.email__c,
                                  Secondary_Phone_Number__c=reqMap.get(sr.Request__c).rmob__c,
                                  Type='Survey Response',
                                  Category__c='Survey Response',
                                  Sub_Category__c='Survey Response',
                                  Root_Cause__c='Survey Response');
                if (reqMap.get(sr.Request__c).rmob__c != null &&reqMap.get(sr.Request__c).rmob__c != '') {

                }
                surCaseMapToInsert.put(sr.Name, c);
                }else{
                   system.debug('Update Case Des:'+description);
                   Case c= surNameswithCase.get(sr.Name);
                    c.Description=description;
                    c.Survey_Ans__c=srAns;
                    c.Rating_Score__c = rating;
                    upcaseList.add(c);
                }
            }

        }
        try{

            insertCaselist = surCaseMapToInsert.values();
            if (!insertCaselist.isEmpty()) {
                system.debug('insertCaselist size:::'+insertCaselist.size());
            if (Schema.sObjectType.Case.isCreateable()) {
                insert insertCaselist;
            }
            }
            if (!upcaseList.isEmpty()) {
                system.debug('updateCaselist size:::'+upcaseList.size());
            if (Schema.sObjectType.case.isUpdateable()) {
                update upcaseList;
            }
            }

        }catch (Exception e) {
            system.debug('insertCaselist Exception'+e.getMessage());
        }

    }

}