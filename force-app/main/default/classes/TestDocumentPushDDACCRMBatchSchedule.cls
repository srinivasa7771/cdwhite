@isTest
public class TestDocumentPushDDACCRMBatchSchedule {

    static testMethod void testImmApplication () {

        System.schedule('Job1234' , '0 15 * * * ?', new DocumentPushDDACCRMBatchSchedule());

    }
}