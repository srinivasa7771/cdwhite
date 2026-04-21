@isTest
public class FrViewCntrlTest {
  static testmethod void test1() {
      Test.startTest();
       FrViewCntrl ctl = new FrViewCntrl();
       ctl.queryReq();
       ctl.selStat = 'l90';
       ctl.queryReq();
       ctl.selStat = 'g90';
       ctl.queryReq();
       ctl.selStat = 'rCall';
       ctl.queryReq();
       ctl.selStat = 'prmCall';
       ctl.queryReq();
      Test.stopTest();
  }
}