public class PMSLeaseValidateCtrl {
  public string rid {set;get;}
  public g_Req__c rq {set;get;}
  public List<UnitInfo> ejariLeaseLst {set;get;}
  public List<UnitInfo> tecomLeaseLst {set;get;}
  public set<String> crmLsLst {set;get;}
    public PMSLeaseValidateCtrl() {
        rid = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('rid'));
        ejariLeaseLst = new List<UnitInfo>();
        tecomLeaseLst = new List<UnitInfo>();
        crmLsLst = new Set<String>();
       List<g_Req__c> rLst = [select id, xpmsle__c, xppsfv__c, xadtx2__c, xadtx3__c, acc__r.ORACLE_PARTY_ID__c, acc__r.name, acc__r.lc__c, srvc__c from g_Req__c where id=:rid];
        if (rLst != null && !rLst.isEmpty()) {

            rq = rLst[0];

          if (String.isNotBlank(rq.acc__r.ORACLE_PARTY_ID__c)) {
            List<grqWsDccaGetService.Records> crmleaseLst = grqWsDccaGetService.loadD3Loc(rq.acc__r.ORACLE_PARTY_ID__c);
              if (crmleaseLst != null && !crmleaseLst.isEmpty()) {
                for (grqWsDccaGetService.Records rc : crmleaseLst) {
                     Decimal crmLeaseArea=0.0;
                    List<String> crmuidLst = new List<String>();
                    String status = (String.isNotblank(rc.Status) ? rc.Status : rc.ContractStatusReason);
                    boolean stsFlg = false;
                   if (status != null  && (status=='Active' || status=='Lease Signed' ||  status=='Modification Activation' || status=='Contraction Activation'  || status=='Contraction Activation' || status=='LA sent for Signoff' || status=='Expansion Activation' || status=='Original Lease Activation' || status=='Renewal Activation' || status=='Customer sign' || status=='Customer signed'
                     || status=='Tecom Sign' || status=='Tecom Signed' || status=='Ready for Activation' ||status=='Tecom Sign' || status=='Tecom Signed' || status=='Ready for Activation' || status.contains('Collected by BP') || status.contains('Signed by BP') || status=='LA is signed off' || status=='LA is ready to activated' || status=='LA activated' || status=='Signed LA received' || status.contains('Counter Signed') || status.contains('Ready for Activation') || status.contains('Modification In Progress') || status.contains('Renewal In Progress')|| status.contains('Expansion In Progress') || status.contains('Termination in progress') )) {
                      stsFlg = true;
                   }
                    if (stsFlg && rc.Products != null && !rc.Products.isEmpty()) {

                        for (grqWsDccaGetService.Products p: rc.Products) {

                          UnitInfo u = new UnitInfo();
                          u.unitNoEn =(String.isNotBlank(rc.ContractNumber) ? p.ProductName : p.unitNumber);
                          u.building = (String.isNotBlank(rc.ContractNumber) ? rc.BuildingName : rc.Building);
                          u.contractNo = (String.isNotBlank(rc.ContractNumber) ? rc.ContractNumber : rc.AgNo);
                          u.contractStartDate = (String.isNotBlank(rc.ContractStartDate)) ? grqWsDccaGetService.formatDt(rc.ContractStartDate) : rc.ContractStartDate;
                          u.ContractEndDate = (String.isNotBlank(rc.ContractEndDate)) ? grqWsDccaGetService.formatDt(rc.ContractEndDate) : rc.ContractEndDate;
                          crmLeaseArea = p.UnitArea != null ? p.UnitArea : 0;
                          u.areaSft = crmLeaseArea;
                         if (String.isNotBlank(rc.ContractNumber)) {
                           crmLsLst.add(rc.ContractNumber+''+u.unitNoEn);

                         }
                         if (!crmuidLst.contains(u.contractNo+''+u.unitNoEn)) {
                          crmuidLst.add(u.contractNo+''+u.unitNoEn);
                          tecomLeaseLst.add(u);
                         }

                        }

                    }
                }
            }

          }
          init();

        }
    }
    public void init() {
        ejariLeaseLst = new List<UnitInfo>();
        if (String.isNotBlank(rq.xadtx2__c)) {
         List<PMSDataWrapper.ContractInformation> ejariContractList = (List<PMSDataWrapper.ContractInformation>) JSON.deserialize(rq.xadtx2__c, List<PMSDataWrapper.ContractInformation>.class);

        List<grqWsDccaGetService.Units> ejariUnitList = new List<grqWsDccaGetService.Units>();
         for (PMSDataWrapper.ContractInformation c: ejariContractList) {
             if (String.isNotBlank(c.ContractNumber) && c.propertyInformationList != null && !c.propertyInformationList.isEmpty() ) {
                  for (PMSDataWrapper.PropertyInformationList p : c.propertyInformationList) {
                      UnitInfo u = new UnitInfo();
                      u.unitNoEn = p.unitNumber;
                      u.building = c.buildingName.englishName;
                      u.contractNo = c.contractNumber;
                      u.contractStartDate = (String.isNotBlank(c.startDate))? grqWsDccaGetService.formatEjariDt(c.startDate) : c.startDate;
                      u.ContractEndDate = (String.isNotBlank(c.endDate))? grqWsDccaGetService.formatEjariDt(c.endDate) : c.endDate;
                      u.areaSm =  decimal.valueOf(p.Area);
                      u.areaSft = (u.areaSm *10.7639).setScale(2, RoundingMode.HALF_UP);
                      String cuid = c.ContractNumber+''+ u.unitNoEn;
                      if (crmLsLst != null && crmLsLst.contains(cuid))
                        u.sts = '';
                      else
                        u.sts = 'New';
                      ejariLeaseLst.add(u);

                  }
               }
            }
          }

    }
    public Pagereference refreshEjariInfo() {
        Pagereference ref = null;

        List<PMSDataWrapper.ContractInformation> ejariContractList = gwsPMSIntegration.getEjariContractInfoByLicenseNo(rq.acc__r.lc__c);
        if (ejariContractList != null && !ejariContractList.isEmpty()) {
         rq.xadtx2__c = Json.serialize(ejariContractList);
         if (Schema.sObjectType.g_req__c.isUpdateable()) {
             update rq;
         }
         gwsPMSIntegration.insertPMSOffLoc(rq);

        }

        init();
        return ref;
    }

     public class UnitInfo{
        public String unitNoEn {set;get;}
        public String unitNoAr {set;get;}
        public String approvalReferenceNumber {set;get;}
        public String dewa {set;get;}
        public String propertyTypeEn {set;get;}
        public String propertyTypeAr {set;get;}
        public String propertySubTypeEn {set;get;}
        public String propertySubTypeAr {set;get;}
        public String floor {set;get;}
        public String building {set;get;}
        public String contractNo {set;get;}
        public String contractStartDate {set;get;}
        public String contractEndDate {set;get;}
        public decimal areaSm {set;get;}
        public decimal areaSft {set;get;}
        public String usage {set;get;}
        public String sts {set;get;}

    }
}