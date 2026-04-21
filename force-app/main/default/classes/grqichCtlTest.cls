@isTest
public class grqichCtlTest {
  static testMethod void doTest() {
        Test.startTest();
      new grqichCtl();
       Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('curId', '2730');
      grqichCtl t=new grqichCtl();
      t.itmId=t.itmId;
      t.details=t.details;
      t.courDetails=t.courDetails;
      t.rqName=t.rqName;
      t.Itm=t.Itm;
      t.rqId=t.rqId;
      t.courierNotes=t.courierNotes;t.curId=t.curId;
      t.rq=t.rq;

      t.createbooking('Collection');
      t.deliveryBooking();
      t.collectionBooking();
      t.recreateBooking();
      t.getDetailsByID();

  }
}