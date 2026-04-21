@isTest
public class gctldvTest {
    static testMethod void doTest() {
        Test.startTest();
        testData.init();
        List<g_Req__c> rq = new List<g_Req__c>();
        Account a=testData.accCrt(false);
        Contact c = new Contact();
        c.idtxt__c = '2730';
        c.rp__c = 'qwdqwed';
        c.lastName = 'khan';
        insert c;

        Contact c1 = new Contact();
        c1.rp__c = 'qwdqwed';
        c1.lastName = 'khan';
        c1.Spon__c = c.id;
        c1.rol__c = 'Spouse';
        c1.Salutation = 'Female';
        c1.accountid = a.id;
        insert c1;

        g_Srvc__c srv = new g_Srvc__c(Id=Label.SpouseSid);
        update srv;

        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('id', '2730');
        System.currentPageReference().getParameters().put('pid', c1.id);
        System.currentPageReference().getParameters().put('enc', '27301111');

        gctlDv ctr = new gctlDv();
        ctr.pid = c1.id;
        ctr.ckPrfl();
        ctr.Renew();

}
}