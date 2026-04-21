@isTest
public class ysiPsgD3MepaymentIntfcYardiTest {

 static testmethod void test() {
     test.startTest();
     ysiPsgD3MepaymentIntfcYardi obj = new ysiPsgD3MepaymentIntfcYardi();
     ysiPsgD3MepaymentIntfcYardi.METransaction_Response res = new ysiPsgD3MepaymentIntfcYardi.METransaction_Response();
     res.Status = 'tst';
     test.stopTest();
 }
}