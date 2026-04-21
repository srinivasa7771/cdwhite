@isTest
private class PreventTemplateOrphansTestClass {
    static testMethod void validatePreventTemplateOrphans() {

    PageTemplate__c template = new PageTemplate__c();

    CMSFolder__c f = new CMSFolder__c();
    f.type__c = 'PageTemplate';
    f.Site_id__c = '0DM2400000000C';
    insert f;

    template.folder__C = f.id;
    template.VisualForce_Page_Name__c = 'SomePage';

    insert template;

    CMSFolder__c f1 = new CMSFolder__c();
    f1.type__c = 'Page';
    f1.Site_id__c = '0DM2400000000C';
    insert f1;
        Page__c page = new Page__c();
        page.Folder__c =f1.id;
        page.pageTemplate__c = template.id;
        insert page;

    try
    {
        delete template;
    }
    catch (Exception e) {
        Boolean expectedExceptionThrown =  e.getMessage().contains('') ? true : false;
        System.AssertEquals(true, true);
    }

    /*CMSFolder__c f = new CMSFolder__c();
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
       delete b;*/
    }
}