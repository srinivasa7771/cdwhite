@isTest
public class gctlConMgmtTest {
    static testmethod void test1() {
        test.starttest();

       user u= testData.createportalUser('puser');
        insert u;
           g_srvc_settings__c stg=testData.stgCrt();
         g_Srvc__c s=testData.srvcCrt(stg.Id);
        system.runAs(u) {
            ApexPages.StandardController stc = new ApexPages.StandardController(new g_req__c());
               gctlConMgmt grd = new gctlConMgmt(stc);
          List<user> uLst = [select id, contactid from user where Id=:u.id LIMIT 1];
            list<contact> cLst= [select id, accountid from contact where id=:uLst[0].contactid LIMIT 1];
            system.debug('uLst----'+uLst);
              system.debug('cLst----'+cLst);
            coninfo__c cinfo = new coninfo__c(acc__c=cLst[0].accountid, con__c=cLst[0].Id, sta__c='Active',
                rol__c='General Manager;HR Contact;Marketing Contact;Facility Management Contact;Admin Contact');
            insert cinfo;
             coninfo__c cinfo1 = new coninfo__c(name__c='Admin Contact', acc__c=cLst[0].accountid, con__c=cLst[0].Id, rol__c='Admin Contact', sta__c='Active');
            insert cinfo1;
            coninfo__c cinfo2 = new coninfo__c(name__c='HR Contact', acc__c=cLst[0].accountid, con__c=cLst[0].Id, rol__c='HR Contact', sta__c='Active');
            insert cinfo2;
            coninfo__c cinfo3 = new coninfo__c(name__c='Marketing Contact', acc__c=cLst[0].accountid, con__c=cLst[0].Id, rol__c='Marketing Contact', sta__c='Active');
            insert cinfo3;
            coninfo__c cinfo4 = new coninfo__c(name__c='Facility Management Contact', acc__c=cLst[0].accountid, con__c=cLst[0].Id, rol__c='Facility Management Contact', sta__c='Active');
            insert cinfo4;
            coninfo__c cinfo5 = new coninfo__c(name__c='Legal Contact', acc__c=cLst[0].accountid, con__c=cLst[0].Id, rol__c='Legal Contact', sta__c='Active');
            insert cinfo5;
            coninfo__c cinfo6 = new coninfo__c(name__c='Financial Contact', acc__c=cLst[0].accountid, con__c=cLst[0].Id, rol__c='Financial Contact', sta__c='Active');
            insert cinfo6;
             coninfo__c cinfo7 = new coninfo__c(name__c='Financial Contact', acc__c=cLst[0].accountid, con__c=cLst[0].Id, rol__c='Financial Contact', sta__c='Inactive');
            insert cinfo7;
            coninfo__c cinfo8 = new coninfo__c(id=cinfo7.id, sta__c='Active');
            update cinfo8;
           //PageReference myVfPage = Page.pageCompanyInfo;
           PageReference myVfPage = new PageReference('/apex/pageCompanyInfo');
        myVfPage.getParameters().put('mroles', 'Admin Contact;General Manager');
             myVfPage.getParameters().put('isselected', 'true');
              myVfPage.getParameters().put('sid', s.id);
        Test.setCurrentPage(myVfPage);
        String croles = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('mroles'));
          string ischeckbox = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('isselected'));
           String srvcId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sid'));

        system.debug('croles---'+croles);

        grd.loadData();
             grd.addCon();
             grd.rmvCon();
        grd.parseJsondata();
        grd.saveAccInfo();
        String   mgInName=grd.mgInName;
        String   mgInPriEmail    =grd.mgInPriEmail;
     String   mgInPriPhn =grd.mgInPriPhn;
     String   mgInSecEmail =grd.mgInSecEmail;
     String   mgInSecPhn =grd.mgInSecPhn;
         Integer  exCons   =grd.exCons;
     boolean  prolFlg    =grd.prolFlg;
     Boolean  usem =grd.usem;
     string   mroles   =grd.mroles;
     Boolean  success  =grd.success;
     string jsonString      =grd.jsonString;
            coninfo__c mgInConinfnew = grd.mgInConinfnew;

    }
        test.stoptest();
    }

}