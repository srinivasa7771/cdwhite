global class caseHandler
{
    public static void handleCasesBeforeUpdate(map<Id,Case> oldMap,map<Id,Case> newMap)
    {
        detectPortalUsers(newMap.Values());
        updateMileStones(oldMap,newMap);
    }

    public static void handleCasesBeforeInsert(List<Case> newCases)
    {
      detectPortalUsers(newCases);
    }

    public static void detectPortalUsers(List<Case> cases)
    {
      Set<Id> ContactsId = new Set<Id>();
        Set<Id> caseIds = new Set<Id>();
        set<string> emailids = new set<string>();
        Id csrecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('AXS').getRecordTypeId();
      For(Case cs : cases)
      {
        caseIds.add(cs.id);
            if (cs.ContactId != null){contactsId.add(cs.ContactId);}
            //Added by CB cs.origin != 'Phone' APD-3553
            if (cs.origin!='Email' && cs.origin != 'Phone'){
                cs.RecordTypeId=csrecordTypeId;
                cs.Division__c=cs.origin=='Survey'?'Survey':'Portal';
            }
            if (cs.origin=='Email'&&!string.isblank(cs.Subject)&&cs.Subject.containsIgnoreCase('complaint')){cs.Priority='High';}
            if (!string.isblank(cs.SuppliedEmail)){emailids.add(cs.SuppliedEmail);}
      }
         list<contact> conList=new list<contact>();
         if (!emailids.isEmpty()){
          conList = new List<Contact>([select id,accountId from contact where email in:emailids and account.name not in('TECOM Investments FZ-LLC','test identity 1','Business Visit Visas-Internal') ]);
         }

        list<case> existingCSlist = [select id,ise__c,SuppliedEmail from case where SuppliedEmail in:emailids and ise__c =true order by lastmodifieddate desc limit 1];
        Map<Id,User> usersMap = new Map<Id,User>();
        if (!conList.isEmpty() && !emailids.isEmpty()){
            for (Case cs : cases){
                if ( cs.origin=='Email'){
                }
            }
        }
      For(User us : [Select Id,ContactId From User Where ContactId in: contactsId and IsActive=true])
      {
        usersMap.put(us.ContactId,us);
      }

      For(Case cs : cases)
      {
            if (trigger.isbefore && trigger.isInsert && !existingCSlist.isEmpty() && existingCSlist.size()>0 &&  !string.isBlank(cs.SuppliedEmail) && cs.SuppliedEmail==existingCSlist[0].SuppliedEmail && existingCSlist[0].ise__c){
                   cs.addError('This Case cannot be Created. The email is from Spam-->'+cs.SuppliedEmail);
            }
        if (cs.ContactId != null)
        {
          cs.Is_Portal_User__c = (usersMAp.get(cs.ContactId) != null);
        }
      }
    }
    public static void updateMileStones(map<Id,Case> oldMap,map<Id,Case> newMap)
    {
        List<Id> casesForLevel1 = new List<Id>();
        List<Id> casesForLevel2 = new List<Id>();
        List<Id> casesForLevel3 = new List<Id>();
         BusinessHours bh = [SELECT ID FROM BusinessHours WHERE IsDefault=true];
         user agentUser  =[select id,profile.name,FirstName,lastname,username from user where id=:userinfo.getUserId() ];
        Map<string, string> coMap = new Map<string, string>();//case_Owner__c.getAll();
        List<case_Owner__c> coList = case_Owner__c.getAll().values();
        for (case_Owner__c objco:coList){
            if (!coMap.containsKey(objco.Name)){
              coMap.put(objco.name,objco.Queue_Name__c);
            }
        }
        For(Case cs : newMap.Values())
        {
            if (!cs.IsStopped && ((string.isblank(oldMap.get(cs.Id).Jira_Number__c) && !string.isblank(cs.Jira_Number__c)) ||(string.isblank(oldMap.get(cs.Id).LINKIT__c) && !string.isblank(cs.LINKIT__c)) )){//LINKIT__c
               cs.IsStopped=true;
            }
            //if (oldMap.get(cs.Id).ownerId!=cs.ownerId){cs.status='In Progress';}
            cs.Resolution__c = (cs.Origin!='Email')?cs.Resolution_Notes__c:(cs.Origin=='Email' && (cs.Type=='Enquiry'||cs.Type=='Compliments'))?cs.comment__c:(cs.Origin=='Email' && (cs.Type=='Complaint'||cs.Type=='Request'))?cs.ac__c:null;
            if (cs.Origin!='Survey'){
                if (oldMap.get(cs.Id).Status == 'Open' && cs.Status != 'Waiting for Client' && cs.Status != 'Waiting Other Department' && cs.Status != 'Open'){casesForLevel1.add(cs.Id);}
                if ((oldMap.get(cs.Id).Status != 'Closed' || oldMap.get(cs.Id).Status != 'Rejected') && (cs.Status == 'Closed' || cs.Status == 'Rejected')){casesForLevel2.add(cs.Id);}
            }

            if (cs.Origin=='Survey'){
                if (oldMap.get(cs.Id).Status == 'Open' && cs.Status != 'Open'){casesForLevel1.add(cs.Id);}
                if ((oldMap.get(cs.Id).OwnerId != '00G2y000000hhvl' || oldMap.get(cs.Id).OwnerId != '00G2y000000hhvlEAA') && (cs.OwnerId == '00G2y000000hhvl' || cs.OwnerId == '00G2y000000hhvlEAA')  && (cs.Status == 'In Progress')){casesForLevel2.add(cs.Id);}
                if ((oldMap.get(cs.Id).Status != 'Closed' || oldMap.get(cs.Id).Status != 'Rejected') && (cs.Status == 'Closed' || cs.Status == 'Rejected')){casesForLevel3.add(cs.Id);}
            }
            if ( (cs.origin == 'Email' || cs.origin == 'Portal' || cs.origin == 'Phone') && !string.isblank(cs.Escalated_to__c)&& oldMap.get(cs.Id).Escalated_to__c!=cs.Escalated_to__c){
                    cs.OwnerId = caseHandler.getQueueDevName(cs.Escalated_to__c);
                }
            if (cs.origin == 'Email' || cs.origin == 'Phone'){


                /*if (cs.cot__c!=null && cs.cob__c!=null && oldMap.get(cs.Id).ownerId!=cs.ownerId && (string.isblank(cs.Type) || string.isblank(cs.Category__c) || string.isblank(cs.brand__c) || string.isblank(cs.Sub_Category__c) || string.isblank(cs.ms__c ) || string.isblank(cs.Comment__c ))){
                    cs.addError('Please make sure you have filled the Type,Brand, Category, Subcategory,Milestone, Agent Comment ');
                }*/
                if (string.isblank(oldMap.get(cs.Id).comment__c) && !string.isblank(cs.comment__c)){cs.acu__c=true;}

                if (agentUser.profile.name=='CC2' && string.isblank(oldMap.get(cs.Id).Comment__c) && !string.isblank(cs.Comment__c)){cs.acb__c=agentUser.username;}
                if ( (cs.Type=='Request' || cs.Type=='Complaint')  && oldMap.get(cs.Id).Escalated_to__c!=cs.Escalated_to__c){//&& oldMap.get(cs.Id).Escalated_to__c =='AXS Support'
                    cs.status='In Progress';cs.ccod__c = system.now();cs.aMin__c = cs.cot__c!=null?BusinessHours.diff(bh.id,cs.cot__c,cs.ccod__c)/60000:BusinessHours.diff(bh.id,system.now(),cs.ccod__c)/60000;
                }
                if ((cs.Type=='Enquiry' || cs.Type=='Compliments') && cs.Status != 'Waiting for Client' && !string.isblank(cs.Type) && !string.isblank(cs.Category__c) && !string.isblank(cs.Sub_Category__c) && !string.isblank(cs.brand__c) && !string.isBlank(cs.Comment__c) ){
                   cs.Status='Closed'; cs.Resolution_Notes__c = cs.Type;
                }
                if ((cs.Type=='Request' || cs.Type=='Complaint')&&cs.Status != 'Waiting for Client' &&cs.Division__c=='Brand' && cs.category__c=='Partner Relations'){
                    string caseOwner = cs.brand__c+''+cs.category__c;
                    string ownrId = cs.OwnerId;
                    if (!ownrId.startsWith('005') )cs.OwnerId = caseHandler.getQueueDevName(coMap.get(caseOwner));
                }
            }
        }
        DateTime currentDateTime = System.Now();
        completeMilestone(casesForLevel1,'Investigation',currentDateTime);
        completeMilestone(casesForLevel2,'Resolution',currentDateTime);
        completeMilestone(casesForLevel3,'Closure',currentDateTime);
    }

    public static void completeMilestone(List<Id> caseIds, String milestoneName, DateTime complDate)
    {
      List<CaseMilestone> cmsToUpdate = [select Id, completionDate from CaseMilestone cm where caseId in :caseIds and cm.MilestoneType.Name=:milestoneName and completionDate = null limit 1];
      if (cmsToUpdate.isEmpty() == false){
          for (CaseMilestone cm : cmsToUpdate){
            cm.completionDate = complDate;
          }
          SObjectAccessDecision secDec = Security.stripInaccessible(AccessType.UPDATABLE, cmsToUpdate);
          update secDec.getRecords();
      }
    }
    public static id objQId;
    public static id getQueueDevName(string queueDevName){
         objQId = [select id,name from group where (Developername=:queueDevName OR Name=:queueDevName) and type='Queue'].id;

        if (!string.isBlank(objQId))return objQId;
        else return null;
    }
/*public static void handleAfterUpsert(List<Case> newCases, Map<Id, Case> oldMap) { List<Case> casesToUpdate = new List<Case>(); for (Case cs : newCases) { String oldToEmail = oldMap != null && oldMap.containsKey(cs.Id)? oldMap.get(cs.Id).To_Email__c:null; if (cs.Origin == 'Email' &&string.isBlank(cs.To_Email__c)) { casesToUpdate.add(new Case(Id = cs.Id,Division__c = 'Brand',Type = 'Enquiry',Brand__c = 'TECOM',Status = 'Closed',Resolution_Notes__c = 'Invalid Case',Category__c = 'Invalid Case',Sub_Category__c = 'Invalid Case',Root_Cause__c = 'Invalid Case',Comment__c='Auto Acknowledge')); } } if (!casesToUpdate.isEmpty()) { update casesToUpdate; } }*/
}