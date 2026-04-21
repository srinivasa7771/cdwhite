@isTest
public class gctlprtstuTest {
    @testSetup static void setup(){
        testData.init();
        
        User u = testData.createportalUser('ttt55');
        insert u;
        
        User u1 = [select id from User where alias = 'ttt55' limit 1];
        //system.runAs(u1){
        Account a=new account(name='StudentPermit');
        insert a;
        User adminU = [Select Id, Name from User where Name = 'System Admin' LIMIT 1 ];
        Contact c = new Contact(accountid=a.id,Salutation = 'Mr.', firstName = 'fName', lastName = 'lName', STA__c = 'Active',
                                rol__c = 'Student', p__c = 'Pass1',
                                pid__c = date.today(), ped__c = date.today().addYears(1), 
                                Owner = adminU,ptsta__c='Eligible');
        insert c; 
        //}
        
        //136 - g_Srvc__c s 
        
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s = new g_Srvc__c(Name = 'Student Part Time Employment Permit', lbl__c = 'Student Part Time Employment Permit', stg__c = stg.id, uid__c = '136', actv__c = true, ckgsnc__c = true, Prk__c = 'Dubai Internet City', AccTp__c = 'Customer - External', ConRol__c = 'Employee', ConSTA__c = 'Active', payMd__c = 'Advance Deposit; Cash; Credit / Debit Card', Category__c = 'Employees Services', Sub_Category__c = 'Renewal Visa', Milestone_Stage__c = 'Ep;Medical;Rp;', Milestone_SLA__c = '10;2;6');
        g_Srvc__c s2 = new g_Srvc__c(Name = 'Student Part Time Employment Permit', lbl__c = 'Student Part Time Employment Permit', stg__c = stg.id, uid__c = '326', actv__c = true, ckgsnc__c = true, Prk__c = 'Dubai Internet City', AccTp__c = 'Customer - External', ConRol__c = 'Employee', ConSTA__c = 'Active', payMd__c = 'Advance Deposit; Cash; Credit / Debit Card', Category__c = 'Employees Services', Sub_Category__c = 'Renewal Visa', Milestone_Stage__c = 'Ep;Medical;Rp;', Milestone_SLA__c = '10;2;6');
        
        insert new List<g_Srvc__c> {s, s2};
    }
    
    public static  testmethod void method1(){
        
        
        Test.startTest();
        List<Contact> conLst = [select id,accountid,Salutation,firstName,lastName,STA__c,rol__c,p__c,pid__c,ped__c,Ownerid,ptsta__c from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Student Part Time Employment Permit' LIMIT 1];
        List<user> loggedinUser=[select contactId, AccountId, FirstName,LastName,Id, username,Acc_Id__c,Contact.account.Prk__c,contact.accountID,Contact.account.Name,contact.account.lcsta__c,contact.account.lcedt__c,
                                 contact.account.lcrndt__c from User where  IsPortalEnabled =true and isactive=true limit 1];
        Account acc = loggedinUser[0].contact.account;
        Account a2 = [Select id from Account limit 1];
        Contact c2 = [Select id from Contact where AccountId =: a2.Id limit 1 ];
        List<g_srvc_settings__c> srvcsettings = [select id,reqq__c,docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        system.debug([select id from Contact]);
        g_Req__c r=testData.reqCrt(a2.Id,srvcLst[0].Id,c2.Id,'Completed',srvcsettings[0].reqq__c);
        //r.Service_Code__c = '136'; // Under Review
        //update r;
        List<g_srvcitm__c> srvitm = [select id from g_srvcitm__c where 	srvc__r.Name='Srvc' LIMIT 1];
        List<g_srvcitm_Status__c> stng1 = [select id,cd__c from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc'];
        system.debug('---stng1---'+stng1);
        List<g_req__c> prtTimeRqs = [select id,InsChk__c,con__r.name, name,sta__c,(select id,itm__c,sta__c,sta__r.cd__c from items__r limit 1) from g_req__c where id=:r.id];
        r.InsChk__c = true;
        update r;
        r.sta__c = 'Cancelled';
        //update r;
        User u = [select id from User where alias = 'ttt55' limit 1];
        system.runAs(u){
             Account a=new Account(Name = 'Acc');//testData.accCrt(false);
            //insert a;
            system.debug([select id, Name from Account]);
        //User adminU = [Select Id, Name from User where Name = 'System Admin' LIMIT 1 ];
       // Contact c = new Contact(accountid=a.id,Salutation = 'Mr.', firstName = 'fName', lastName = 'lName', STA__c = 'Active',
                               // rol__c = 'Student', p__c = 'Pass1',
                                //pid__c = date.today(), ped__c = date.today().addYears(1), 
                               //ptsta__c='Eligible');
        //insert c; 
            PageReference pageRef = Page.gptelgstu;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(r);
            ApexPages.currentPage().getParameters().put('Id',r.id);
            ApexPages.currentPage().getParameters().put('ofr','All');
            gctlprtstu ctrl = new gctlprtstu();
            ctrl.selectedCon = c2.Id;
            ctrl.selectedCon_Can = c2.Id;
            ctrl.alwdHrs = '2';
            ctrl.resendRq=r.id;
            
            try {
                ctrl.createReq();
            } catch(Exception e) {
                
            }
            ctrl.offerFilter();
            ctrl.clearFilters();
            ctrl.resendOffer();
            try {
                ctrl.CancelOffer();
            } catch(Exception e) {}
            //ctrl.revokeOffer();
            ctrl.sendPermit();
            Test.stopTest();
        }
    }
}