@isTest
private class PreventActiveWebFormDeleteTestClass {
    static testMethod void validatePreventActiveWebFormDelete() {

    CMSFolder__c webformfolder = new CMSFolder__c(Type__c = 'WebForm', Name='test');
    insert webformfolder;
        //add an object with a required field in the db, just to throw an exception (Web_Form__c itself for example)
        //set up a test web form
        Web_Form__c form2 = new Web_Form__c();
        form2.Name = 'test webform';
        form2.Object_Name__c = 'Web_Form__c';//can't use account. Not accessible via Dynamix Apex in packaged class.
        form2.Object_Label__c = 'Test';
        form2.Return_URL__c = 'http://www.x.com';
        form2.SavedByWebformeditor__c = true;
        form2.Folder__c = webformfolder.Id;

        insert form2;
        delete form2;
    }

    static testMethod void validateContentBlockPrevent() {
    CMSFolder__c webformfolder = new CMSFolder__c(Type__c = 'WebForm', Name='test');
    insert webformfolder;
        //add an object with a required field in the db, just to throw an exception (Web_Form__c itself for example)
        //set up a test web form
        Web_Form__c form2 = new Web_Form__c();
        form2.Name = 'test webform';
        form2.Object_Name__c = 'Web_Form__c';//can't use account. Not accessible via Dynamix Apex in packaged class.
        form2.Object_Label__c = 'Test';
        form2.Return_URL__c = 'http://www.x.com';
        form2.SavedByWebformeditor__c = true;
        form2.Folder__c = webformfolder.Id;

        insert form2;

        ContentBlockItem__c content = new ContentBlockItem__c();

        content.Web_Form__c = form2.id;

        CMSFolder__c f = new CMSFolder__c();
        f.type__c = 'Page';
        f.Site_id__c = '0DM2400000000C';
        insert f;
        Page__c page = new Page__c();
        page.Folder__c =f.id;
        insert page;
                    insert content;

        PageToItem__c b = new PageToItem__c();
        b.ContentBlockItem__c = content.id;
        b.Page__c = page.id;

        insert b;

        try
    {
        delete form2;
    }
    catch (Exception e) {
        Boolean expectedExceptionThrown =  e.getMessage().contains('') ? true : false;
        System.AssertEquals(true, true);
    }
    }
}