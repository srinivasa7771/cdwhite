@isTest
public class rfcTest {
    public static testMethod void  testRfc() {
        Account testAccount = new Account(Name='Test Company Name123');
        testAccount.adob__c = 100;
        testAccount.adx__c = 100;
        testAccount.tadr__c = 50;
        insert testAccount;
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        rfc ctrl = new rfc(sc);
        ctrl.ReceiptNo = '32423';
        ctrl.mobileNo = '0555555555';
        ctrl.emailAdd = 'test@test.com';
        ctrl.sigName = 'test';
        ctrl.notes = 'testing notes';
         ctrl.acc=testAccount;
        System.currentPageReference().getParameters().put('pMtd', 'Customer Deposit');
        System.currentPageReference().getParameters().put('mb', '0555555555');
        System.currentPageReference().getParameters().put('amt', '100.00');
        System.currentPageReference().getParameters().put('rcNo', '32423');
        System.currentPageReference().getParameters().put('em', 'test@test.com');
        System.currentPageReference().getParameters().put('sgNm', 'test');
        System.currentPageReference().getParameters().put('nt', 'testing notes');

        test.startTest();
        ctrl.generateRefund();
        ctrl.generatePDF();
        ctrl.amt = 324;
        ctrl.generatePDF();
        ctrl.packageChoosen = 'Customer Deposit';
        ctrl.generatePDF();
        ctrl.amt = 50;
        ctrl.generatePDF();
        test.stopTest();
    }
}