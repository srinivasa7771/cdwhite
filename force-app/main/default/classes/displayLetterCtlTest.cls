@isTest 
public class displayLetterCtlTest {
    static testMethod void doTestLetter() {
        Test.startTest();
         testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
            Contact emp=testData.conCrt(sp,a.Id,'Active','Employee','Pass2','Egypt');
            g_Req__c r=testData.reqCrt(a.Id,s.Id,emp.Id,'Open',stg.reqq__c);
        Attachment attach=new Attachment();   	
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('UniSt Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=r.id;
        insert attach;
        Apexpages.StandardController sc = new Apexpages.StandardController(r);
        displayLetterCtl ext = new  displayLetterCtl(sc); 
       
        Test.stopTest();
    }
}