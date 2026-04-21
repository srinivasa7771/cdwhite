@isTest(SeeAllData=true)
public class reqstssearchctlTest {

    static testMethod void doTest() {
        reqstssearchctl reqS = new reqstssearchctl();
        List<g_Req__c> reqList = [Select Id, Name, Letter_dt__c from g_Req__c where Service_Code__c=:'ltp' limit 1 ];
        reqS.searchstring=reqList[0].Name;
        reqS.search();
        reqS.clear();

    }

    static testMethod void doTestFalse() {
        reqstssearchctl reqS = new reqstssearchctl();
        List<g_Req__c> reqList = [Select Id, Name, Letter_dt__c from g_Req__c where Service_Code__c=:'ltn' limit 1 ];
        reqS.searchstring=reqList[0].Name;

        reqS.codeCheck=false;
        reqS.search();
        reqS.clear();

    }

}