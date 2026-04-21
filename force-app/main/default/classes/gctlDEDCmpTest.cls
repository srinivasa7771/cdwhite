@isTest
public class gctlDEDCmpTest {

    static testMethod void testMethod1() {

        List<DED_Activity__c> lstDED = new List<DED_Activity__c>();
        DED_Activity__c d1 = new DED_Activity__c();
        d1.Name = 'Test1';
         d1.DED_Activity_Name_Arabic__c = 'Test1';
        d1.Is_Active__c = True;
        lstDED.add(d1);

         DED_Activity__c d2 = new DED_Activity__c();
        d2.Name = 'Test1';
         d2.DED_Activity_Name_Arabic__c = 'Test1';
        d2.Is_Active__c = True;
        lstDED.add(d2);

         DED_Activity__c d3 = new DED_Activity__c();
        d3.Name = 'Test1';
         d3.DED_Activity_Name_Arabic__c = 'Test1';
        d3.Is_Active__c = True;
        lstDED.add(d3);

        Insert lstDED;
        g_Req__c req = new g_Req__c();
         Test.startTest();
    //   Test.setCurrentPage(Page.dedActivityCmp);
     //   ApexPages.currentPage().getParameters().put('c', '204');
                gctlDEDCmp gctl = new gctlDEDCmp();
       gctl.getSelectedAct();
        gctl.rqDraft = req;
        gctl.getCurrentActList();
        gctl.activityChange();
      //  gctl.ClearAll();
         gctl.SearchAct();
      //  gctl.BuildWhere();
        gctl.SortToggle();
        gctl.saveActivity();
       // gctl.ActSelInfo;
       // gctl.ActInfo;
        //
        //
         Test.stopTest();
            //select id, name from DED_Activity__c

    }
}