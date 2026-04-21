/* Apex class to implement inbound email service for AXS IT Support, which creates a records in salesforce.com (support__c: Object)automatically*/

 global class SupportEmail implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        Support__c supportObj = new Support__c();
        //supportObj.Name = email.fromname.substring(0,email.fromname.indexOf('' ));
        supportObj.Subject__c = email.subject;
        supportObj.Rasied_By__c = envelope.fromAddress;
        supportObj.Description__c = email.plainTextBody;
        insert supportObj ;

        System.debug('====> Created contact==> '+contact.Id);

        if (email.binaryAttachments != null &&  email.binaryAttachments.size() > 0) {
        for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
            Attachment attachment = new Attachment();
            // attach to the newly created contact record
            attachment.ParentId = supportObj .Id;
            attachment.Name = email.binaryAttachments[i].filename;
            attachment.Body = email.binaryAttachments[i].body;
            insert attachment;
                 }
            }
            return result;
      }
 }