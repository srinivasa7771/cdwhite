@isTest
private class grqWsDccaGetServiceBatchTest {
    static testmethod void test1() {
        Map<String, String> actMap = grqWsDccaGetServiceBatch.actMap;
            Map<String, String> priceMap = grqWsDccaGetServiceBatch.priceMap;
        grqWsDccaGetServiceBatch.argLocation grd = new grqWsDccaGetServiceBatch.argLocation();
        String agreeNo = grd.agreeNo;
          boolean isRegoff = grd.isRegoff;
        string floor =grd.floor;
 string arbfloor =grd.arbfloor;
 string OffNo =grd.OffNo;
 string buildN =grd.buildN;
 string arbBuildN =grd.arbBuildN;
 string bus =grd.bus;
 string arbBus =grd.arbBus;
 string status =grd.status;
 string reason=grd.reason;
 string edDt=grd.edDt;
 string fullLoc=grd.fullLoc;
  string stDt=grd.stDt;
  grqWsDccaGetServiceBatch.Units grd1 = new grqWsDccaGetServiceBatch.Units();
          string UnitNameArabic = grd1.UnitNameArabic;
          string UnitNoArabic = grd1.UnitNoArabic;
          string UnitNoEnglish = grd1.UnitNoEnglish;
          string FloorArabic = grd1.FloorArabic;
         string FloorEnglish = grd1.FloorEnglish;
         string BuildingNameArabic= grd1.BuildingNameArabic;
          string Category = grd1.Category;
         string SubCategory = grd1.SubCategory;
          string SendToDCCA = grd1.SendToDCCA;
         string UnitName = grd1.UnitName;
         string UnitNumber = grd1.UnitNumber;
        string FloorName = grd1.FloorName;
         string BuildingName= grd1.BuildingName;
         string CommercialName = grd1.CommercialName;
         string BusinessPark = grd1.BusinessPark;
         string UniqueKey = grd1.UniqueKey;
          string AgNo = grd1.AgNo;
         string ContractStartDate = grd1.ContractStartDate;
       string ContractEnddate = grd1.ContractEnddate;
            }
      static testmethod void test2() {
         grqWsDccaGetServiceBatch.Records grd2 = new grqWsDccaGetServiceBatch.Records();
          String StageName = grd2.StageName;
         String AgNo= grd2.AgNo;
         String LeaseType= grd2.LeaseType;
          String Type= grd2.Type;
         Boolean regOff= grd2.regOff;
         String BusinessPark= grd2.BusinessPark;
         String ContractStartDate= grd2.ContractStartDate;
         String ContractEndDate= grd2.ContractEndDate;
         String Category= grd2.Category;
         String SubCategory= grd2.SubCategory;
         String ContractStatus= grd2.ContractStatus;
         String ContractStatusReason= grd2.ContractStatusReason;
         String fullUnitAdd= grd2.fullUnitAdd;
          String IsDownsize = grd2.IsDownsize;
         String RenewalOpp = grd2.RenewalOpp;   }
      static testmethod void test3() {
       grqWsDccaGetServiceBatch.Locations grd3 = new grqWsDccaGetServiceBatch.Locations();
          Boolean isRegoff =grd3.isRegoff;
         string AgreementNo =grd3.AgreementNo;
         string ArabicBuildingName=grd3.ArabicBuildingName;
         string ArabicBusinessUnit =grd3.ArabicBusinessUnit;
         string ArabicFloor =grd3.ArabicFloor;
         string ArabicOfficeNo =grd3.ArabicOfficeNo;
         string totalArea =grd3.totalArea;
         string Category =grd3.Category;
         string SubCategory =grd3.SubCategory;
         boolean regOff=grd3.regOff;
         string OfficeNo=grd3.OfficeNo;
         string LicenseNo =grd3.LicenseNo;
         string LocationId =grd3.LocationId;
         string BusinessPark =grd3.BusinessPark;
         string BuildingName =grd3.BuildingName;
         string Floor =grd3.Floor;
         String Status =grd3.Status;
         String ContractStatusReason =grd3.ContractStatusReason;
         date ContractStartDate =grd3.ContractStartDate;
         date ContractEnddate =grd3.ContractEnddate;
         boolean IsMainAdd =grd3.IsMainAdd;
         String subleaseCompany =grd3.subleaseCompany;
         boolean showOnLicen=grd3.showOnLicen;
         string licenseType=grd3.licenseType;
         string IsSubLease=grd3.IsSubLease;
         string error=grd3.error;
         String IsDownsize =grd3.IsDownsize;
         String RenewalOpp =grd3.RenewalOpp;
         string Recordtype=grd3.Recordtype;
         string masterLocationLicense=grd3.masterLocationLicense;
      }
             static testmethod void test4() {
               grqWsDccaGetServiceBatch.Data grd4 = new grqWsDccaGetServiceBatch.Data();
         Integer amount = grd4.amount;
         string idRec = grd4.idRec;
         string licNo= grd4.licNo;
         string expDate = grd4.expDate;
         string name = grd4.name;
         string mangerName= grd4.mangerName;
         string mangerNameA = grd4.mangerNameA;
         string leaseType = grd4.leaseType;
         string managerNation = grd4.managerNation;
         string managerNationA = grd4.managerNationA;
         string errorCode= grd4.errorCode;
         string errorMessage= grd4.errorMessage;
         string licType= grd4.licType;
         string sme= grd4.sme;
         boolean buRecomendation= grd4.buRecomendation;
         string shareHldType= grd4.shareHldType;
         string actspeNotes= grd4.actspeNotes;
        boolean isRenewalAllowed= grd4.isRenewalAllowed;
         string status= grd4.status;
         string legaleng= grd4.legaleng;
         string legalarabic= grd4.legalarabic;
         string lincenseeeng= grd4.lincenseeeng;
         string lincenseearabic= grd4.lincenseearabic;
         string frameworkeng= grd4.frameworkeng;
         string frameworkarabic= grd4.frameworkarabic;
         string businessPArk= grd4.businessPArk;
                   }
             static testmethod void test5() {
         grqWsDccaGetServiceBatch.Activities grd5 = new grqWsDccaGetServiceBatch.Activities();
                    string LicenseNo=grd5.LicenseNo;
         string ActivityId =grd5.ActivityId;
         string Name =grd5.Name;
         string type =grd5.type;
         string segName =grd5.segName;
         string accName =grd5.accName;
         date StartDate=grd5.StartDate;
         string error=grd5.error;
                   }
             static testmethod void test6() {
          grqWsDccaGetServiceBatch.ActivityLocations grd6 = new grqWsDccaGetServiceBatch.ActivityLocations();
         string LicnseNo=grd6.LicnseNo;
         string MethodName=grd6.MethodName;
         string error=grd6.error;
         string errorCode =grd6.errorCode;
                   }
             static testmethod void test7() {
          grqWsDccaGetServiceBatch.DocumentD grd7 = new grqWsDccaGetServiceBatch.DocumentD();
          String name=grd7.name;
         String shareHolderName =grd7.shareHolderName;
         boolean isRequired =grd7.isRequired;
                   }
             static testmethod void test8() {
        grqWsDccaGetServiceBatch.LineItems grd8 = new grqWsDccaGetServiceBatch.LineItems();
          string segment=grd8.segment;
         string activity =grd8.activity;
         string isActive=grd8.isActive;
         string lineName =grd8.lineName;
         Integer amount =grd8.amount;
    }
       static testmethod void test9() {
        grqWsDccaGetServiceBatch.Titles grd9 = new grqWsDccaGetServiceBatch.Titles();
          string name=grd9.name;
         string lang =grd9.lang;
         string genere=grd9.genere;
         string freq =grd9.freq;
    }
       static testmethod void test10() {
        grqWsDccaGetServiceBatch.Channels grd10 = new grqWsDccaGetServiceBatch.Channels();
          string name=grd10.name;
         string lang =grd10.lang;
         string genere=grd10.genere;
         string freq =grd10.freq;
    }
      static testmethod void test11() {
        grqWsDccaGetServiceBatch.sanctions grd11 = new grqWsDccaGetServiceBatch.sanctions();
          string sanctionDept=grd11.sanctionDept;
         string sancdescriprtion =grd11.sancdescriprtion;
    }
      static testmethod void test12() {
        grqWsDccaGetServiceBatch.ResponseData grd12 = new grqWsDccaGetServiceBatch.ResponseData();
          string PartyId=grd12.PartyId;
         boolean Success =grd12.Success;
         string Source=grd12.Source;
         string Error =grd12.Error;
           string ResponseCode =grd12.ResponseCode;
    }

}