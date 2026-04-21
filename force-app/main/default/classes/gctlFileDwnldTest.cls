@IsTest
private class gctlFileDwnldTest {
    static testmethod void loadDataIdNull() {
        Case cse=new Case();
        insert cse;

        Attachment attach=new Attachment();
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cse.id;
        insert attach;

        Test.startTest();
        //PageReference vfpage = Page.grqstatus;
        PageReference vfpage = new PageReference('/apex/grqstatus');
        vfpage.getParameters().put('id', attach.Id);
        Test.setCurrentPage(vfpage);
        gctlFileDwnld obj = new gctlFileDwnld();
        obj.getDocCopy();
        Test.stopTest();
    }
}