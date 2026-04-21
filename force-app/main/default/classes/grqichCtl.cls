public class grqichCtl {
    public Id itmId {get; set;}
    public list<g_reqitem__c> details  {get; set;}
    public list<g_cmb__c> courDetails  {get; set;}
    public String rqName  {get; set;}
    public String Itm  {get; set;}
    public String rqId  {get; set;}
    public String courierNotes  {get; set;}
    public String curId {get;set;}
    public g_Req__c rq{get;set;}
    public g_cmb__c cb{get;set;}
   public String awb{get;set;}
       public String id{get;set;}
    public grqichCtl() {
        itmId=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        curId=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('curId'));
        getCourierDetails();
    }
    public grqichCtl(ApexPages.StandardController c) {itmId=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));}
    public List<g_reqitem__c> getCourierDetails() {
        try{
            details=[SELECT id, Rq__r.Name, Name, (SELECT Id, csta__c, xawb__c, xnts__c, xcb__c,
                sta__c, xupr__c, itm__r.Name, itm__r.Rq__c, createddate, tmpstamp__c, itmsta__c,
                itmsta__r.Courier_Stage__c, CreatedBy.Name, adh__c  from cmb__r order by xawb__c,
                createdDate desc) from g_reqitem__c where id=:itmId];
            courDetails=details[0].cmb__r;
            rqName=details[0].Rq__r.Name;
            rqId=details[0].Rq__c;
            Itm=details[0].Name;
        }
        catch (Exception e) {
        }
        return details;
    }

  public PageReference  deliveryBooking() {
      if (courierNotes != null && courierNotes.trim().length()>0) {
          if (!createbooking('Delivery')) {
              gu.AddErrorMsg('Courier delivery booking already in process.');
              return null;
          }
      }
      else{
          gu.AddErrorMsg('Courier Notes is missing');
          return null;
      }
      PageReference p=new PageReference('/apex/griCurSta?id='+itmId);
      p.setRedirect(true);
      return p;
  }
  public  PageReference  collectionBooking() {
      if (courierNotes != null && courierNotes.trim().length()>0) {
          if (!createbooking('Collection')) {
              gu.AddErrorMsg('Courier collection booking already in process.');
              return null;
          }
      }
      else{
          gu.AddErrorMsg('Courier Notes is missing');
          return null;
      }
      PageReference p=new PageReference('/apex/griCurSta?id='+itmId);
      p.setRedirect(true);
      return p;
  }
public Boolean createbooking(String stage) {
    list<g_reqitem__c> courBk;
    list<g_cmb__c> cmbList=new list<g_cmb__c>();
    try{
        courBk=[SELECT Id, RQ__c, xcub__c, sta__c, nt__c, xcasc__c, exp__c, sta__r.Courier_Stage__c,
            sta__r.cd__c, sta__r.Courier_Notes__c, Name, RQ__r.Name, RQ__r.xbrnd__c, RQ__r.xbn__c,
            RQ__r.Zone__c, RQ__r.Acc__r.Name, RQ__r.Full_Name__c, RQ__r.xaloc__c, RQ__r.CreatedBy.Name,
            RQ__r.rmob__c from g_reqitem__c where Id=:itmId and AD__c=0.0 limit 1];
        g_reqitem__c ri=courBk[0];
        String returnVal;
        list<g_cmb__c>  existingBooking=[SELECT Id,
            Name from g_cmb__c where xcb__c=:stage and sta__c!='Delivered' and sta__c!='Cancelled' and adh__c=true and itm__c=:itmId and itmsta__c=:ri.sta__c limit 1];
        if (existingBooking.isEmpty() ) {
            rq=ri.Rq__r;
            ri.xcub__c=stage;
            XMLParserforEmpostWebservice cls = new XMLParserforEmpostWebservice();
            cls.ctype=stage;
            cls.courierBooking(ri, rq, true, '');
            /*        if (ri.exp__c) {
                cls.assginedTo='X'+ri.xcasc__c;
            }
            else{
                cls.assginedTo=ri.xcasc__c;
            }
            String CB =cls.CreateBooking(rq, stage.toUpperCase());
            if (CB != null) {
                list<XMLParserforEmpostWebservice.XMLtoApex> lstxml =cls.XMLParser(CB);
                System.debug('--CreateBooking lstxml-- : ' +lstXML );
                if (lstxml != null) {
                    if (ri != null) {
                        g_cmb__c cmb=new g_cmb__c();
                        cmb.xawb__c=Long.valueOf(lstxml[0].AIRWAYBILL);
                        cmb.sta__c='At Dispatcher';
                        cmb.tmpstamp__c=Datetime.now();
                        cmb.itm__c=ri.id;
                        cmb.xcb__c=stage;
                        cmb.itmsta__c=ri.sta__c;
                        cmb.xccpd__c=lstxml[0].CourierName;
                        cmb.adh__c=true;
                        if (ri.sta__r.Courier_Notes__c != null && ri.sta__r.Courier_Notes__c!='null') {
                            cmb.xnts__c=ri.sta__r.Courier_Notes__c+', '+courierNotes;
                        }
                        else{
                            cmb.xnts__c=courierNotes;
                        }
                        cmbList.add(cmb);
                        if (!string.isBlank(ri.nt__c)) {
                            ri.nt__c=ri.nt__c+', '+courierNotes;
                        }
                        else{
                            ri.nt__c=courierNotes;
                        }
                        update ri;
                    }
                }
            }
        */  }
        else{
            return false;
        }
        if (!cmbList.isEmpty()) {
            if (Schema.sObjectType.g_cmb__c.isCreateable()) {
                insert cmbList;
            }
        }
    }
    catch (Exception e) {
    }
    return true;
}
     public PageReference  recreateBooking() {
         curId=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('curId'));
         list<g_cmb__c>  existingBooking=[SELECT Id, Name, xawb__c, itm__c, xcb__c, sta__c, adh__c, coubdt__c, uid__c from g_cmb__c where  id=:curId  limit 1];
         if (!existingBooking.isEmpty() ) {
             XMLParserforEmpostWebservice cls = new XMLParserforEmpostWebservice();
             g_cmb__c cb=existingBooking.get(0);
             if (cb.xawb__c != 0) {
                 gu.AddErrorMsg('You cannot recreate booking, AWB# number already exists, AWB#'+cb.xawb__c);
                 return null;
             }
             else{
                 itmId=cb.itm__c;
                 list<g_reqitem__c> courBk;
                 list<g_cmb__c> cmbList=new list<g_cmb__c>();
                 courBk=[SELECT Id, RQ__c, sta__c, nt__c, xcasc__c, exp__c, sta__r.Courier_Stage__c,
                     sta__r.cd__c, sta__r.Courier_Notes__c, Name, RQ__r.Name, RQ__r.xbrnd__c, RQ__r.xbn__c,
                     RQ__r.Zone__c, RQ__r.Acc__r.Name, RQ__r.Full_Name__c, RQ__r.xaloc__c, RQ__r.CreatedBy.Name,
                     RQ__r.rmob__c from g_reqitem__c where Id=:itmId and AD__c=0.0 limit 1];
                 g_reqitem__c ri=courBk[0];
                 String returnVal;
                 String stage=cb.xcb__c;
                 rq=ri.Rq__r;
                 if (ri.exp__c) {
                     cls.assginedTo='X'+ri.xcasc__c;
                 }
                 else{
                     cls.assginedTo=ri.xcasc__c;
                 }
                 cls.createdon=cb.coubdt__c;
                 cls.uid=cb.uid__c;
                 system.debug('*************************');
                 system.debug(cls.uid);
                 system.debug('*************************');
                 String awbXML =cls.CreateBooking(rq, stage.toUpperCase());
                 if (awbXML != null) {
                     list<XMLParserforEmpostWebservice.XMLtoApex> lstxml =cls.XMLParser(awbXML);
                     if (lstxml != null) {
                         if (ri != null) {
                             cb.xawb__c=Long.valueOf(lstxml[0].AIRWAYBILL);
                             cb.sta__c='At Dispatcher';
                             cb.tmpstamp__c=Datetime.now();
                             update cb;
                         }
                     }
                 }
             }
         }
         PageReference p=new PageReference('/apex/griCurSta?id='+itmId);
         p.setRedirect(true);
         return p;
     }

    /*public PageReference genBarcode() {
      List<g_cmb__c> courRecList=[select id, Name, xawb__c, xccpd__c, itm__r.RQ__r.Full_Name__c,
          itm__r.RQ__r.Name, itm__r.RQ__r.srvc__r.lbl__c, itm__r.RQ__r.rmob__c, itm__r.RQ__r.prio__c,
          itm__r.RQ__r.Acc__r.Name, itm__r.RQ__r.Zone__c, itm__r.RQ__r.xaloc__c  from g_cmb__c  where id=:curId and IsDeleted=false limit 1];
             cb=courRecList[0];
            rq=cb.itm__r.RQ__r;
            PageReference p=new PageReference('/apex/grbrcd?id='+curId);p.setRedirect(true);return p;
              }*/

    public pagereference getDetailsByID() {
        pagereference pg;
        id=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('curId'));
        system.debug('*************************');
        system.debug(id);
        system.debug('*************************');
        try{
            List<g_cmb__c> courRecList=[select Id, Name, xccpd__c, xawb__c, itm__r.RQ__r.id, itm__r.RQ__r.Acc__r.Name,
                itm__r.RQ__r.srvc__r.lbl__c, itm__r.RQ__r.prio__c, itm__r.RQ__r.rmob__c, itm__r.RQ__r.Full_Name__c,
                itm__r.RQ__r.Zone__c, itm__r.RQ__r.xaloc__c, itm__r.RQ__r.Name from g_cmb__c  where  Id =:id and IsDeleted=false];
            if (!courRecList.isEmpty()) {
                cb=courRecList[0];
                cb.itm__r.RQ__r.xaloc__c.replace('\n', ', ');
                rq=cb.itm__r.RQ__r;
            }
        }
        catch (Exception e) {
        }
        return  new pagereference('/apex/grbrpcd?id='+id);
    }
}