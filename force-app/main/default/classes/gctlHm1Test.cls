@istest
private class gctlHm1Test {
    @testSetup 
    static void setup(){
        testData.init();
        User usr = testData.createportalUser('test');
        insert usr;
        
        List<user> ulist = [select contactid from user where id=:usr.id LIMIT 1];
        List<Contact> conList = [select id,accountid from contact where id=:ulist[0].contactid LIMIT 1];
        account a = new account(id=conList[0].accountid,os__c='Intiated',ORACLE_PARTY_ID__c='32710',Type='Customer - Incubation');
        update a;
        
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        s.uid__c='216';
        update s;
        
        g_Req__c req=testData.reqCrt(conList[0].accountId,s.Id,conList[0].Id,'Open',stg.reqq__c);
        
        update req;
    }
    static testmethod void testPositive(){
        Test.startTest();
        gStg__c custSett = new gStg__c();
        custSett.Name='gpPrfls';
        custSett.Text_Value__c='00e20000001AkRt;00e20000001AjBw;00e20000001AjBwAAK;00e20000001AkRtAAK';
        insert custSett;
        
        List<user> ulist = [select id from user where Email='portaluser@testorg.com' LIMIT 1];
        Account acc=[SELECT id,lc__c from Account where name='portal account' limit 1];
        acc.type='Customer - Incubation;Customer - Member';
        acc.snc__c ='CA- Outstanding Dues; CA- Outstanding Dues (Penalties)';
        acc.Prk__c='Dubai Internet City';
        update acc;
        Contact con =[SELECT id,accountid from Contact where lastname='portalcontact' limit 1];
        
        coninfo__c testConInfo = new coninfo__c(name__c='HR Contact',acc__c=con.accountid,con__c=con.Id,rol__c='VAT Contact; Billing Contact; Office Admin/Manager',sta__c='Active');
        insert testConInfo;
        
        system.runAs(ulist[0]){
            PageReference vfpage = new PageReference('/apex/pagepastrequests');
            vfpage.getParameters().put('flg','drft');
            vfpage.getParameters().put('uid','111');
            Test.setCurrentPage(vfpage);
            
        	gctlHm1 obj = new gctlHm1();
            obj.ispu = true;
            obj.loadEmployeeData();
        	obj.saveAttachment();//Write Negative scenario
        	obj.obr();
            obj.checkParkingUser();
            obj.A=acc;
            obj.getnotificationRQs();
            obj.getpendingRQs();
            obj.checkTRNnumber();
            obj.saveAccount();
            obj.inValidtrn=obj.inValidtrn; 
            obj.licCopy=obj.licCopy;
            obj.conMap=obj.conMap;
            obj.aList=obj.aList;
            obj.oList=obj.oList;
            obj.multiMap=obj.multiMap;
            //obj.minBG=obj.minBG;
           // obj.maxBG=obj.maxBG;
  			obj.leaseDt=obj.leaseDt;
            obj.notificationRqs=obj.notificationRqs;
            obj.notificationRqs3=obj.notificationRqs3;
            obj.rcRqs=obj.rcRqs;
            obj.draftRqs=obj.draftRqs;
            obj.pendingRqs=obj.pendingRqs;
       		obj.pendingRq5=obj.pendingRq5;
            
            g_Srvc__c  srv =[SELECT id,uid__c FROM g_Srvc__c where uid__c='216' limit 1];
            srv.uid__c='223';
            srv.actv__c=true;
            srv.Category__c='Dependents';
            srv.Prk__c =acc.Prk__c;
            srv.AccTp__c =acc.Type;
            srv.Menu_Category__c='Visas';
            update srv;
            obj.setRenewalRequest();
            
            List<ParkingDetails> pdetailList = new List<ParkingDetails>();
            obj.lst_pdClone = pdetailList;
            obj.lst_pd = pdetailList;
            obj.parkingString='test';
            obj.loadCards2('');
            obj.getConInfo();
            
            obj.days='5';
            obj.status='testtt';
            obj.searchByStatus1();
            
            obj.LoadPrivateMethods();
            obj.getdraftRQs();
            //obj.getnotificationRQs();
            //obj.getpendingRQs();
            obj.getNopmntRQs();
            
            g_Req__c req =[SELECT id,(SELECT ap__c from Items__r) FROM g_Req__c WHERE Acc__c=: acc.id limit 1 ];
            req.xcfn__c ='Test';
            req.xcln__c ='test2';
            req.STA__c = 'Open';
            update req ;
            
            obj.prsn='Test test2';
            obj.searchPersons();
            obj.getallDPRQs();
            obj.sta='Open';
            obj.searchByStatus();
            obj.dat='3';
            obj.searchByDate();
            Integer t = obj.TotalPages;
            Integer t1 = obj.MaxNumberOfRecords;
            Integer pageNo= obj.PageNumber;
            obj.next();
            obj.pageNo='10';
            obj.getSelectedPageList();
            obj.getallDPRqs1();
            obj.enUser();
           //obj.getRCRQs();
        }
        Test.stopTest();
    }
   
    
}