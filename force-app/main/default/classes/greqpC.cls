public class greqpC {

g_Req__c reqRec;
public List<reqItemWrapper> reqItemWrapperList {get;set;}
public reqItemWrapper reqItmwrap {get;set;}
public reqItemWrapper reqItmwrap2 {get;set;}
public List<g_reqitem__c> reqItem {get;set;}
public List<g_reqitem__c> reqItem2 {get;set;}
public boolean epCorrFlag {get;set;}
public decimal totalSalary{get;set;}

    public greqpC(ApexPages.StandardController controller) {
        reqRec =(g_Req__c)controller.getRecord();
        getReqItem();

    }

     public void getReqItem() {
     epCorrFlag = false;
     reqItem = [select Id, xcslt__c, xcfn__c, xcmn__c, xcln__c, xcbd__c, xcbp__c, xcnc__c,
         xcp__c, xcjb__r.Name, xcf__c, xcid__c, xced__c  from g_reqitem__c where RQ__c =: reqRec.id AND (itmCd__c ='eca' OR itmCd__c ='eci' ) limit 1];
     reqItem2 = [select Id, xrp__c, xrpid__c, xrped__c from g_reqitem__c where RQ__c =: reqRec.id AND (itmCd__c ='id') ];
    system.debug('JJ'+reqRec);
    system.debug('JJ'+reqItem);
     if (!reqItem.isEmpty()) {
     epCorrFlag= true;
   // for (g_reqitem__c rqItm :reqItem ) {
    reqItmwrap = new reqItemWrapper();
    reqItmwrap.sal = reqItem[0].xcslt__c;
    reqItmwrap.fstName = reqItem[0].xcfn__c;
    reqItmwrap.mdlName = reqItem[0].xcmn__c;
    reqItmwrap.lstName = reqItem[0].xcln__c;
    reqItmwrap.bdy = reqItem[0].xcbd__c;
    reqItmwrap.plcB = reqItem[0].xcbp__c;
    reqItmwrap.nat = reqItem[0].xcnc__c;
    reqItmwrap.pass = reqItem[0].xcp__c;
    reqItmwrap.jbtl = reqItem[0].xcjb__r.Name;
    reqItmwrap.cnclref = reqItem[0].xcf__c;
    reqItmwrap.cnclIss = reqItem[0].xcid__c;
    reqItmwrap.cnclExp = reqItem[0].xced__c;
    //reqItemWrapperList.add(reqItmwrap);
   // }
    }

    if (!reqItem2.isEmpty()) {
    reqItmwrap2 = new reqItemWrapper();
    reqItmwrap2.rpNo = reqItem2[0].xrp__c;
    reqItmwrap2.rpIss = reqItem2[0].xrpid__c;
    reqItmwrap2.rpExp = reqItem2[0].xrped__c;
    }

     }

   public class reqItemWrapper {
   //public boolean isSelected {get;set;}
   public string sal {get;set;}
   public string fstName {get;set;}
   public string mdlName {get;set;}
   public string lstName {get;set;}
   public date bdy{get;set;}
   public string plcB {get;set;}
   public string nat {get;set;}
   public string pass {get;set;}
   public string jbtl {get;set;}
   public string cnclref {get;set;}
   public date cnclIss{get;set;}
   public date cnclExp{get;set;}
   public string rpNo {get;set;}
   public date rpIss{get;set;}
   public date rpExp{get;set;}

  }

}