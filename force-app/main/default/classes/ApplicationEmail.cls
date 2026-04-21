//Apex class to implement inbound email service for DHA Medical to attach Medical form to Request Document.
global class ApplicationEmail implements Messaging.InboundEmailHandler {
   global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
       system.debug('handleInboundEmail+++++'+email.subject);
       system.debug('body::'+email.htmlBody);
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
      // envelope.fromAddress == 'noreply@salem.dha.gov.ae' &&
       if (email.subject != null && email.subject.contains('Application Document')){

           String ref = email.subject.substringBetween('Application (', ') رقم الطلب - Application Document');
           system.debug('test1:::'+ref);
           uploadDocs(ref,'Medical Application Form',email);
       }
       else if (email.subject != null && email.subject.contains('Certificate Document')){
           String ref = email.subject.substringBetween('Application (', ') رقم الطلب - Certificate Document');
           system.debug('test1:::'+ref);
           uploadDocs(ref,'Medical Certificate Document',email);
       }
        return result;
      }

     private void uploadDocs(String refNo, string docName, Messaging.InboundEmail email){
          system.debug('test2:::');

         List<g_reqitemDoc__c> riDocLst =  [select id,reqDoc__c,Req__c,reqAts__c from g_reqitemDoc__c where name=:docName and reqItm__r.xf__c =:refNo];
         system.debug('riDocLst:: '+riDocLst.size());
         try{
               if (riDocLst != null && !riDocLst.isEmpty()){
              riDocLst[0].Req__c = true;
              riDocLst[0].reqAts__c = true;
              SObjectAccessDecision secDec = Security.stripInaccessible(AccessType.UPDATABLE, riDocLst);
              update secDec.getRecords();
              //g_reqDoc__c rdoc =  [select id from g_reqDoc__c where id=:riDocLst[0].reqDoc__c];
              list<Attachment> attLst = [select id from Attachment where ParentId=:riDocLst[0].reqDoc__c];
              if (attLst != null && !attLst.isEmpty())
                 delete attLst;
              if (email.binaryAttachments != null &&  email.binaryAttachments.size() > 0) {
                 for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
                   Attachment attachment = new Attachment();
                   // attach to the newly created contact record
                   attachment.ParentId = riDocLst[0].reqDoc__c;
                   attachment.Name = email.binaryAttachments[i].filename;
                   attachment.Body = email.binaryAttachments[i].body;
                   insert attachment;
                 }
               }
           }
         }
         catch (Exception ex){
             system.debug('ex::'+ex.getStackTraceString());
         }


     }
}