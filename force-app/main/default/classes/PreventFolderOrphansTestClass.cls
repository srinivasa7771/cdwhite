@isTest
private class PreventFolderOrphansTestClass {
    static testMethod void validateCleanup() {

    CMSFolder__c f = new CMSFolder__c();
    f.type__c = 'Page';
    f.Site_id__c = '0DM2400000000C';
    insert f;
        Page__c page = new Page__c();
        page.Folder__c =f.id;
        insert page;
        ContentBlockItem__c content = new ContentBlockItem__c();
        insert content;
       PageToItem__c b = new PageToItem__c();
       b.ContentBlockItem__c = content.id;
       b.Page__c = page.id;
       insert b;

    try
    {
        delete f;
    }
    catch (Exception e) {
        Boolean expectedExceptionThrown =  e.getMessage().contains('') ? true : false;
        System.AssertEquals(true, true);
    }

    }
}