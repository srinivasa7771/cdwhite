@IsTest
    public class UnitTest_SupportEmail {
    public static testmethod void testEmailService() {
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        // setup the data for the email
        email.subject = 'Test Servvice Applicant';
        email.fromname = 'FirstName LastName';
        env.fromAddress = 'someaddress@email.com';
        //add an attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfile.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {attachment};
        // call the email service class and test it with the data in the testMethod
        SupportEmail emailProcess = new SupportEmail();
        emailProcess.handleInboundEmail(email, env);
        // query for the contact the email service created
        Support__c supportTemp = [select id, Name, Rasied_By__c from Support__c where Rasied_By__c = : env.fromAddress Limit 1];
        System.assertEquals(supportTemp.Rasied_By__c, 'someaddress@email.com');
    }
}