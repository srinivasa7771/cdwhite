@isTest
public class gctlstultTest {
   @testSetup static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        //Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        User adminU = [Select Id, Name from User where Name = 'System Admin' LIMIT 1 ];
        Contact c = new Contact(accountid=a.id, Salutation = 'Mr.', firstName = 'fName', lastName = 'lName', STA__c = 'Active',
                                                                    rol__c = 'Student', p__c = 'Pass1',
                                                                    pid__c = date.today(), ped__c = date.today().addYears(1),
                                                                     Owner = adminU, ptsta__c='Eligible');
        insert c;
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        //gStg__c crtstng = testData.createSetting('test', 'testvalue');

    }
    public static  testmethod void method1() {
         List<Contact> conLst = [select id, accountid, Salutation, firstName, lastName, STA__c, rol__c, p__c, pid__c, ped__c, Ownerid, ptsta__c from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
         List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        //contact con1 =[select id, ptsta__c from contact where id=:conLst[0].id];
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, conLst[0].Id, 'Open', srvcsettings[0].reqq__c);
        PageReference pageRef = Page.gstult;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(r);
        ApexPages.currentPage().getParameters().put('Id', r.id);
        test.startTest();
        gctlstult ctrl = new gctlstult(sc);
        //ctrl.accpetOffer();
        test.stopTest();
    }
}