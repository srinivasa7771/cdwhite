@isTest
private class GetDiscountDetailsTest {
 static testmethod void test1() {
Account a=testData.accCrt(false);
g_Disc__c gc = new g_Disc__c();
gc.Acc__c=a.Id;
insert gc;
     Test.startTest();
   List<g_Disc__c> ritm = [select id, Acc__c, sd__c, ed__c, prct__c, Priority__c, Category__c from g_Disc__c where id=:gc.id LIMIT 1];
        ApexPages.StandardController setCon = new ApexPages.StandardController(ritm[0]);
        GetDiscountDetails gdd = new GetDiscountDetails(setCon);
        gdd.sdate=system.today();
        gdd.edate=system.today();
        gdd.proceedtodiscount();
        Test.StopTest();
}

}