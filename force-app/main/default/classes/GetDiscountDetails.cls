public with sharing class GetDiscountDetails {
 public g_Disc__c discount{set;get;}
 public boolean selected{set;get;}
 public Date sdate{get; set;}
 public Date edate{get; set;}
 public GetDiscountDetails(ApexPages.StandardController controller) {
     this.discount = (g_Disc__c)controller.getRecord();
 }

 public PageReference proceedtodiscount() {
      system.debug('selected'+selected);
     g_Disc__c disc= new g_Disc__c();
     disc.Acc__c=discount.Acc__c;
     disc.sd__c=discount.sd__c;
      disc.ed__c=discount.ed__c;
      disc.prct__c=discount.prct__c;
      disc.Priority__c=discount.Priority__c;
      disc.Category__c=discount.Category__c;
     try{
if (Schema.sObjectType.g_Disc__c.isCreateable()) {
    insert disc;
}

 PageReference ref = new PageReference('/apex/Submit_Process');
 ref.setRedirect(true);
      return ref;

}
catch (Exception ex) {
System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
}
return null;
 }
}