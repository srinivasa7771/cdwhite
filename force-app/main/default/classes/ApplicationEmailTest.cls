@isTest
public class ApplicationEmailTest {
   public static testmethod void testApplicationEmail() {

       testData.init();
        List<gStg__c> lstGStg = new List<gStg__c>();
        gStg__c bh = new gStg__c(name='BH', Text_Value__c = '01m20000000BKEa');
        lstGStg.add(bh);
        insert lstGStg;
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrtOptItems(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c, 'md');
          g_reqitem__c ri = [select id, RQ__c from g_reqitem__c where itm__r.cd__c = 'md' and RQ__c=:r.id];
          ri.xf__c = '12345';
          update ri;
       g_reqDoc__c rDoc = new g_reqDoc__c(Name='Medical Application Form', RQ__c=r.id );
       insert rDoc;
       g_reqitemDoc__c riDoc = new g_reqitemDoc__c(Name = 'Medical Application Form', lbl__c = 'Medical Application Form',
           reqItm__c = ri.Id, reqDoc__c = rDoc.id, Req__c = false, reqOr__c = false, reqAts__c = false,
           mnAts__c = 0, mxAts__c = 2, Tp__c = 'Access Permit 12');
       insert riDoc;
       // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        // setup the data for the email
        email.subject = 'Application (12345) رقم الطلب - Application Document';
        email.fromname = 'FirstName LastName';
        env.fromAddress = 'someaddress@email.com';
        //add an attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfile.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {attachment};
        // call the email service class and test it with the data in the testMethod
        ApplicationEmail emailProcess = new ApplicationEmail();
        emailProcess.handleInboundEmail(email, env);

    }
    public static testmethod void testApplicationEmail1() {

       testData.init();
        List<gStg__c> lstGStg = new List<gStg__c>();
        gStg__c bh = new gStg__c(name='BH', Text_Value__c = '01m20000000BKEa');
        lstGStg.add(bh);
        insert lstGStg;
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrtOptItems(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c, 'md');
          g_reqitem__c ri = [select id, RQ__c from g_reqitem__c where itm__r.cd__c = 'md' and RQ__c=:r.id];
          ri.xf__c = '12345';
          update ri;
       g_reqDoc__c rDoc = new g_reqDoc__c(Name='Medical Application Form', RQ__c=r.id );
       insert rDoc;
       g_reqitemDoc__c riDoc = new g_reqitemDoc__c(Name = 'Medical Application Form', lbl__c = 'Medical Application Form',
           reqItm__c = ri.Id, reqDoc__c = rDoc.id, Req__c = false, reqOr__c = false, reqAts__c = false,
           mnAts__c = 0, mxAts__c = 2, Tp__c = 'Access Permit 12');
       insert riDoc;
       // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        // setup the data for the email
        email.subject = 'Application (12345) رقم الطلب - Certificate Document';
        email.fromname = 'FirstName LastName';
        env.fromAddress = 'someaddress@email.com';
        //add an attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfile.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {attachment};
        // call the email service class and test it with the data in the testMethod
        ApplicationEmail emailProcess = new ApplicationEmail();
        emailProcess.handleInboundEmail(email, env);

    }
}