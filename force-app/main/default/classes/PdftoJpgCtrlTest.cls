@isTest
public class PdftoJpgCtrlTest {
    static testmethod void  testPdf() {
        Account acc = new Account();
        acc.name='test acc';
        insert acc;
        Attachment att = new Attachment();
        att.Body = Blob.valueOf('');
        att.Name = 'tst.pdf';
        att.ParentId = acc.id;
        insert att;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', att.id);
        PdftoJpgCtrl ctrl = new PdftoJpgCtrl();
        Test.stopTest();

    }
}