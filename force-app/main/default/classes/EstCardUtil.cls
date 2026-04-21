public class EstCardUtil {

    public static PDFGeneratorWS.LIC_Parameters getLicInfo(String licNo) {
        String rqBody = '{"serviceRequestId":"", "Regenerate":"true", "Method":"GetLicenseInfo", "LicenseNumber":"'+
            licNo+'", "Data":{"resolution":null, "pdfParams":null, "documentName":"License", "docConfig":null, "body":null, "aoaParams":null}}';

        PDFGeneratorWS.LIC_Parameters data = null;
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:DCCA_Auth/apexrest/LicenseService');
        request.setMethod('POST');
        request.setBody(rqBody);
        request.setTimeout(60000);
        try {
            response = h.send(request);
            if (response.getStatusCode() == 200) {
                 String jsonResp = response.getBody();
                System.debug('###<getDocument> jsonResp: ' + jsonResp);
                 grqWsDccaGetService.Document docinfo = (grqWsDccaGetService.Document) JSON.deserialize(jsonResp, grqWsDccaGetService.Document.class);
                if (docinfo != null && docinfo.Data != null && docinfo.Data.pdfParams != null) {
                    data = docinfo.Data.pdfParams;
                }
            }
        }catch (Exception ex) {

        }
          System.debug('###<data> data: ');
        if (data != null) {  System.debug(JSON.serialize(data));}
        System.debug(data);
        return data;
    }
    public static String reqBody(g_reqitem__c reqItem, String srvType) {
        string strRqBody = '';
        Map<String, integer> segActmp = new  Map<String, integer>();
        Map<String, integer> actmp = new  Map<String, integer>();
       for (DDA_Activities__c act : [select id, DNRDActNo__c, DDADNRDSeg__c, DDADNRDAct__c from DDA_Activities__c where DNRDActNo__c != null]) {
         segActmp.put(act.DDADNRDSeg__c+'_'+act.DDADNRDAct__c, integer.valueOf(act.DNRDActNo__c));
         actmp.put(act.DDADNRDAct__c, integer.valueOf(act.DNRDActNo__c));
       }
        EstablishmentWrp est = new EstablishmentWrp();
        est.MobileNumber = '0525454568';
        if (srvType == 'Renewal') {
          est.EstCode = reqItem.RQ__r.Acc__r.ec__c.replace('/', '');
          est.MobileNumber = '0'+reqItem.RQ__r.xcmob__c;
        }
        est.ForYears = 1;
        est.OfficeNumber = '043911111';
        est.TelephoneNo = '043911111';
        est.Email = 'estcard@axs.ae';
        est.Street = 'Alsufouh';
        est.POBoxNumber = 73000;
        est.POBoxEmiratesID = '2';
        est.FaxNo = '043688994';
        est.EmiratesID = '2';
        est.CityID = 908;
        est.AreaID = 5322;
        est.EmirateDepartmentID = '201';
        est.EstbTypeID = '6';
        est.EstbExtTypeID = '2';

        PDFGeneratorWS.LIC_Parameters data = getLicInfo(reqItem.RQ__r.Acc__r.lc__c);
        if (data != null && data.Addresses != null) {
          //String cname=data.LicenseeEN;
          //String cnameAr=data.LicenseeAR;
          String cname=data.OperatingNameEN;
          String cnameAr=data.OperatingNameAR;
          cname=cname.replace('-', ' ').replace(':', ' ').replace('null, ', '');
          cnameAr=cnameAr.replace('-', ' ').replace(':', ' ').replace('null, ', '');
        est.EstablishmentNameEnglish = cname+' - DDA';
        est.EstablishmentNameArabic = cnameAr+' - '+'سلطة التطوير';
       // est.MobileNumber = '0'+reqItem.RQ__r.xcmob__c;
        est.ApprovalEmailCopyRecipient = reqItem.RQ__r.xceml__c;

        if (data.Addresses != null) {
          PDFGeneratorWS.LicenseInfoItem addrInfo = data.Addresses.LicenseInfoItem[0];
            for (PDFGeneratorWS.LicenseInfoItem addr : data.Addresses.LicenseInfoItem) {
             if (addr.isRegisterAddress != null && addr.isRegisterAddress)
              addrInfo = addr;
            }
          String onlyarbic = '[a-zA-Z:-]';
          est.AddressinEnglish = (String.isNotBlank(addrInfo.officeNO) ? (addrInfo.officeNO+', '):'')+addrInfo.floorNo+
              ', '+addrInfo.building+(String.isNotBlank(addrInfo.businessUnit) ? (', '+addrInfo.businessUnit):'');
          String arbAddr =  (String.isNotBlank(addrInfo.aOfficeNo) ? (addrInfo.aOfficeNo+', '):'')+addrInfo.afloorNo+
              ', '+addrInfo.abuilding+(String.isNotBlank(addrInfo.abusinessUnit) ? (', '+addrInfo.abusinessUnit):'');
          arbAddr = arbAddr.replace('-', ' ').replace(':', ' ').replace('null, ', '');
          arbAddr=arbAddr.replaceAll(onlyarbic, '' );
          est.AddressinArabic=arbAddr;
          est.FlatNumber = String.isNotBlank(addrInfo.officeNO) ? addrInfo.officeNO : '3';
          est.Building = addrInfo.building;
        }

        TradeLicenseWrp lc = new TradeLicenseWrp();
        lc.LicenseAuthorityID = '10';
        if (String.isNotBlank(reqItem.RQ__r.Acc__r.Legal_Framework__c) && reqItem.RQ__r.Acc__r.Legal_Framework__c == 'Freelancer')
        lc.LicenseTypeID = 3;
        else
        lc.LicenseTypeID = 2;

        lc.LicenseNumber = integer.valueOf(reqItem.RQ__r.Acc__r.lc__c);
        if (data.CurrentIssueDate != null) {
         Datetime tdDt = Datetime.now();
         if (data.CurrentIssueDate > tdDt)
           lc.IssueDate = string.valueOf(tdDt).substringBefore(' ');
         else
           lc.IssueDate = string.valueOf(data.CurrentIssueDate).substringBefore(' ');
        }
        lc.ExpiryDate = string.valueOf(data.ExpiryDate).substringBefore(' ');
        EstRequest obj = new EstRequest();
        obj.Establishment=est;
        set<integer> actNoLst = new set<integer>();
        /*Map<String, integer> actMp = dnrdActInfo(); */
        if (data.LicensedActivities != null && data.LicensedActivities.LicenseInfoItem != null && !data.LicensedActivities.LicenseInfoItem.isEmpty()) {
            List<PDFGeneratorWS.LicenseInfoItem> actInfoLst = data.LicensedActivities.LicenseInfoItem;
            if (actInfoLst != null && !actInfoLst.isEmpty()) {
            for (PDFGeneratorWS.LicenseInfoItem act : actInfoLst) {
                system.debug('seg::'+act.ParentItemNameEN+'_'+act.ItemNameEN);
                if (segActmp != null && segActmp.containsKey(act.ParentItemNameEN+'_'+act.ItemNameEN))
                         actNoLst.add(segActmp.get(act.ParentItemNameEN+'_'+act.ItemNameEN));
                else if (actmp != null && actmp.containsKey(act.ItemNameEN))
                   actNoLst.add(actmp.get(act.ItemNameEN));
            }
             lc.LicenseActivityIDs = actNoLst;
           }
        }
        obj.TradeLicense =lc;
        strRqBody = json.serialize(obj);
        }
        return strRqBody;
    }
    public static Map<String, integer> dnrdActInfo() {
        Map<String, integer> actmp = new  Map<String, integer>();
        for (DDA_Activities__c act : [select id, DNRDActNo__c, DDADNRDSeg__c, DDADNRDAct__c from DDA_Activities__c where DNRDActNo__c != null])
            actmp.put(act.DDADNRDSeg__c+'_'+act.DDADNRDAct__c, integer.valueOf(act.DNRDActNo__c));
        return actmp;
    }
    public class EstRequest {
        public EstablishmentWrp Establishment {set;get;}
        public TradeLicenseWrp TradeLicense {set;get;}
    }

    public class EstablishmentWrp {
        public string EstCode {set;get;}
        public integer ForYears {set;get;}
        public String EstablishmentNameEnglish {set;get;}
        public String EstablishmentNameArabic {set;get;}
        public String OfficeNumber {set;get;}
        public String TelephoneNo {set;get;}
        public String MobileNumber {set;get;}
        public String Email {set;get;}
        public String ApprovalEmailCopyRecipient {set;get;}
        public String AddressinEnglish {set;get;}
        public String AddressinArabic {set;get;}
        public String Street {set;get;}
        public String FlatNumber {set;get;}
        public integer POBoxNumber {set;get;}
        public String POBoxEmiratesID {set;get;}
        public String MakaniNumber {set;get;}
        public String FaxNo {set;get;}
        public String Building {set;get;}
        public String EmiratesID {set;get;}
        public integer CityID {set;get;}
        public integer AreaID {set;get;}
        public String EmirateDepartmentID {set;get;}
        public String EstbTypeID {set;get;}
        public String EstbExtTypeID {set;get;}
      }

    public class TradeLicenseWrp {
        public string LicenseAuthorityID {set;get;}
        public integer LicenseTypeID {set;get;}
        public integer LicenseNumber {set;get;}
        public string IssueDate {set;get;}
        public string ExpiryDate {set;get;}
        public set<integer> LicenseActivityIDs {set;get;}
    }

}