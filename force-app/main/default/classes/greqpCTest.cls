@isTest(SeeAllData=True)
public class greqpCTest {
    static testMethod void greqpCdoTest() {

     Test.startTest();

   g_reqitem__c reqItem = [select Id, xcslt__c, xcfn__c, xcmn__c, xcln__c, xcbd__c, xcbp__c,
       xcnc__c, xcp__c, xcjb__r.Name, xcf__c, xcid__c, xced__c, RQ__c   from g_reqitem__c where (itmCd__c ='eca' OR itmCd__c ='eci' ) limit 1];

    g_Req__c req = [select Name , strsrvc__c, Acc__c, xcstg__c, xdedc__c, Con__r.dedc__c,
        xdedln__c, Con__r.dedln__c, e__c, Con__r.e__c, xcfn__c, Con__r.FirstName, xcmn__c,
        Con__r.mn__c, xcln__c, Con__r.LastName, xcfnar__c, Con__r.fnar__c, xcmnar__c, Con__r.mnar__c,
        xclnar__c, Con__r.lnar__c, xeidav__c, xcfan__c, Con__r.fan__c, xcmon__c, Con__r.mon__c,
        xcnc__c, Con__r.nc__c, xcbd__c, Con__r.Birthdate, xcbp__c, Con__r.bp__c, xcbc__c,
        Con__r.bc__c, xcjb__c, xcms__c, Con__r.ms__c, xcrlg__c, Con__r.rlg__c, xcnp__c, Con__r.np__c,
        xclng__c, Con__r.lng__c from g_Req__c where id=:reqItem.RQ__c];

     Test.setCurrentPageReference(new PageReference('Page.greqp'));
     System.currentPageReference().getParameters().put('id', reqItem.RQ__c   );

   /** g_reqitem__c reqItem = new g_reqitem__c ();
    reqItem.xcslt__c ='';
    reqItem.xcfn__c ='Rahul';
    reqItem.xcmn__c='Reon';
    reqItem.xcln__c='wolf';
    reqItem.xcbd__c=System.today()-2000;
    reqItem.xcbp__c= 'Dubai';
    reqItem.xcnc__c= 'Zimbabwe';
    reqItem.xcp__c= 'BV9821052MAx123';
    reqItem.xcjb__c= jb.Id;
    reqItem.xcf__c= '11111';
    reqItem.xcid__c= System.today();
    reqItem.xced__c = System.today()+300;
    reqItem.RQ__c =req.Id;
    Insert reqItem;**/
  //  reqItem.itmCd__c= srvItm.Id;

    ApexPages.StandardController rqItemC = new ApexPages.StandardController(req );
    greqpC gr = new greqpC(rqItemC );
       // newAccountPlan testAccPlan = new newAccountPlan(sc);

         Test.stopTest();

    }
    }