@isTest
private class ddtectlTest {
static testMethod void doTest() {
    boolean blV;String sV;
    Test.startTest();
       testData.init();
    g_srvc_settings__c stg=testData.stgCrt();
    g_Srvc__c s=testData.srvcCrt(stg.Id);
    Account a=testData.accCrt(false);
    Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
    Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
    g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
    list<g_reqitem__c> ritms = new list<g_reqitem__c>();
    for (g_reqitem__c ri: r.Items__r) {
        ritms.add(ri);
    }
    //-----------------------------------------------
    ApexPages.currentPage().getParameters().put('Id', ritms[0].id);
    g_reqDoc__c rDoc=new g_reqDoc__c();
    rDoc.Name='Photo'; rDoc.RQ__c=r.id; rDoc.ats__c=1; insert rDoc;
    g_reqitemDoc__c riDoc=new g_reqitemDoc__c();
    riDoc.reqItm__c=ritms[0].id; riDoc.lbl__c='Photo'; riDoc.mxAts__c=1; riDoc.mnAts__c=1; riDoc.Req__c=true; riDoc.reqAts__c=true; riDoc.Tp__c='Photo'; riDoc.reqDoc__c=rDoc.Id; insert riDoc;
    Attachment attach=new Attachment();
    attach.Name='Unit Test Attachment'; Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); attach.body=bodyBlob; attach.parentId=ritms[0].id; insert attach;
    ddtectl obj=new ddtectl();
    obj.ParseContact();
    obj.ParseSponsor();
    obj.ParseVisa();
    obj.ParseECNo();
    obj.ParseEstName();
    obj.ParseFN();
    obj.ParseMohAddress();
    obj.ParseVVisa();
    obj.SetVVOccupation();
    //-----------------------------------------------
    Test.stopTest();
    }
}