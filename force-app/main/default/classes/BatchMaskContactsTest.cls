@isTest
public class BatchMaskContactsTest {
    static testmethod void test1() {
        Account a = new account(name='test account', Phone='+958179', Email__c='mornaacc@gmail.com');
        insert a;
        contact c = new contact(Accountid=a.id, Lastname='test contact', Email='mornacontact@tecom.com', HomePhone='+919154767767', MobilePhone='+971581171179');
        insert c;
        Test.startTest();
        BatchMaskContacts bt = new BatchMaskContacts();
        database.executeBatch(bt, 2);
        Test.stopTest();
    }

}