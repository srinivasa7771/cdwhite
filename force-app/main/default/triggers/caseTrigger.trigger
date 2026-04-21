trigger caseTrigger on Case (before update,before insert,after insert,after update) 
{

   if(trigger.IsBefore)
    {
        for(Case cs : Trigger.New){if(cs.root_Cause__c != null){cs.Reason = cs.Root_Cause__c;}}        
        if(trigger.IsInsert)
        {
            caseHandler.handleCasesBeforeInsert(Trigger.New);
           
        }
        if(trigger.IsUpdate)
        {
            caseHandler.handleCasesBeforeUpdate(Trigger.oldMap,Trigger.NewMap);
        }  
        
    }
    if(trigger.isAfter && trigger.Isupdate){
        //CaseHandler.handleAfterUpsert(Trigger.new, Trigger.oldMap);
    }
    /* 
   
    if(trigger.IsBefore && trigger.IsUpdate)
    {
        List<Id> casesForLevel1 = new List<Id>();
        List<Id> casesForLevel2 = new List<Id>();
        
        For(Case cs : Trigger.New)
        {
            if(Trigger.oldMap.get(cs.Id).Status == 'Open' && cs.Status != 'Open')
            {
                casesForLevel1.add(cs.Id);
            }
            
            if((Trigger.oldMap.get(cs.Id).Status != 'Closed' || Trigger.oldMap.get(cs.Id).Status != 'Rejected') && (cs.Status == 'Closed' || cs.Status == 'Rejected'))
            {
                casesForLevel2.add(cs.Id);
            }
        }
        DateTime currentDateTime = System.Now();
        milestoneUtils.completeMilestone(casesForLevel1,'Investigation',currentDateTime);
        milestoneUtils.completeMilestone(casesForLevel2,'Resolution',currentDateTime);
    }
    */
}