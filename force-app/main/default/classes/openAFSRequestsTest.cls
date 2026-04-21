@IsTest
public class openAFSRequestsTest {
    @IsTest
    static void testOpenAFSRequests() {
        openAFSRequests afs = new openAFSRequests();
        afs.totalAmountToPay = '100';
        afs.financialYearStart = '2022-01-01';
        afs.financialYearEnd = '2022-12-31';
        afs.financialYear = 2022;
        afs.ddaId = '123';
        afs.axsRefNo = 'AXS-123';

        afs.finYearStartDt= afs.finYearStartDt;
        afs.finYearEndDt= afs.finYearEndDt;
        afs.Status= afs.Status;

        List<openAFSRequests.invoiceItems> items = new List<openAFSRequests.invoiceItems>();
        openAFSRequests.invoiceItems item = new openAFSRequests.invoiceItems();
        item.name = 'Item 1';
        item.fineOrFee = 'Fine';
        item.amount = 50;
        items.add(item);

        List<openAFSRequests.attachments> attachments = new List<openAFSRequests.attachments>();
        openAFSRequests.attachments attachment = new openAFSRequests.attachments();
        attachment.uploadedContentId = 'contentId';
        attachment.isUploaded = true;
        attachment.isMandatory = true;
        attachment.fileName = 'file.txt';
        attachment.ddaId = 'ddaId';
        attachments.add(attachment);

        afs.invoiceItems = items;
        afs.attachments = attachments;
        List<openAFSRequests.subRequests> subRequestlt = new List<openAFSRequests.subRequests>();
        openAFSRequests.subRequests subitem = new openAFSRequests.subRequests();
        subitem.type=subitem.type;
        subitem.status=subitem.status;
        subitem.requestSubmissionDate=subitem.requestSubmissionDate;
        subitem.isRejected=subitem.isRejected;
        subitem.isApproved=subitem.isApproved;
        subitem.inProgress=subitem.inProgress;

        subRequestlt.add(subitem);
        afs.subRequests = subRequestlt;

        System.assertEquals('100', afs.totalAmountToPay);
        System.assertEquals('2022-01-01', afs.financialYearStart);
        System.assertEquals('2022-12-31', afs.financialYearEnd);
        System.assertEquals(2022, afs.financialYear);
        System.assertEquals('123', afs.ddaId);
        System.assertEquals('AXS-123', afs.axsRefNo);
        System.assertEquals(1, afs.invoiceItems.size());
        System.assertEquals('Item 1', afs.invoiceItems[0].name);
        System.assertEquals('Fine', afs.invoiceItems[0].fineOrFee);
        System.assertEquals(50, afs.invoiceItems[0].amount);
        System.assertEquals(1, afs.attachments.size());
        System.assertEquals('contentId', afs.attachments[0].uploadedContentId);
        System.assertEquals(true, afs.attachments[0].isUploaded);
        System.assertEquals(true, afs.attachments[0].isMandatory);
        System.assertEquals('file.txt', afs.attachments[0].fileName);
        System.assertEquals('ddaId', afs.attachments[0].ddaId);
    }
}