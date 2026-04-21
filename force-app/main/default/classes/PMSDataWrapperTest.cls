@isTest
public class PMSDataWrapperTest {
    public static testmethod void meth1() {
      Test.startTest();
       PMSDataWrapper pms = new PMSDataWrapper();

       PMSDataWrapper.PropertyInformationList pi = new PMSDataWrapper.PropertyInformationList();
       pi.ejariBusPropertyTypeId = '';pi.approvalRefNumber='';pi.unitNumber='';pi.unitNumberArb='';
       pi.floorEN = '';pi.floorAR='';pi.area='';pi.dewa='';pi.propertyTypeId='';pi.propertyType='';pi.propertySubTypeId='';
       pi.propertySubType='';pi.propertyUsageId='';pi.propertyUsage='';pi.isMainAddr=false;
       PMSDataWrapper.Name nm = new PMSDataWrapper.Name();
       nm.englishName = '';nm.arabicName='';
       PMSDataWrapper.CommunityInformation ci = new PMSDataWrapper.CommunityInformation();
       ci.code = 123; ci.name='';
       PMSDataWrapper.LandLordInformation li = new PMSDataWrapper.LandLordInformation();
       li.name = nm;
       PMSDataWrapper.AreaZone az = new PMSDataWrapper.AreaZone();
       az.code = 123;az.name=nm;
       PMSDataWrapper.LicenseAuthorityInformation lai = new PMSDataWrapper.LicenseAuthorityInformation();
       lai.code=123;lai.name=nm;lai.id='';
       PMSDataWrapper.LicenseInformation lci = new PMSDataWrapper.LicenseInformation();
       lci.initialApprovalNumber = '123'; lci.licenseNumber = '';lci.licenseAuthorityInformation=lai;
       PMSDataWrapper.GeoLocation gl = new PMSDataWrapper.GeoLocation();
       gl.latitude = '';gl.longitude = '';
       PMSDataWrapper.AuthorityInformation ai = new PMSDataWrapper.AuthorityInformation();
       ai.code = '';ai.id = ''; ai.name = '';
       PMSDataWrapper.LookupItems lkp = new PMSDataWrapper.LookupItems();
       lkp.identity = null;lkp.value = '';lkp.englishName='';lkp.arabicName='';lkp.otherValue='';lkp.parentId='';
       PMSDataWrapper.LeaseItems litms = new PMSDataWrapper.LeaseItems();
       litms.parentPmsContractNumber = ''; litms.propertyName='';litms.propertyNameArabic='';litms.approvalReferenceNumber='';
       litms.propertyType = ''; litms.propertyTypeArabic='';litms.ejariPropertyType='';litms.ejariPropertyTypeArabic='';
       litms.ejariPropertySubtype='';litms.ejariPropertySubtypeArabic='';litms.psf=23; litms.size=23.0;
       litms.isMainAddress = false; litms.location='';litms.usage='';litms.floorEN='';litms.floorAR='';litms.floorNumber=23.0;
       PMSDataWrapper.Data dt = new PMSDataWrapper.Data();
       dt.oraclePartyId = ''; dt.contractNumber = '';dt.landNumber = '';dt.contractStartDate = '';dt.contractEndDate = '';
       dt.contractStatus = ''; dt.buildingName = ''; dt.buildingNameArabic = '';  dt.dmNumber = ''; dt.dewaAccountNumber = '';
       dt.licenseIssuer = ''; dt.makaniNumber = ''; dt.pushToDDA = false;  dt.type = ''; dt.businessPark = '';
       List<PMSDataWrapper.LeaseItems> litmList = new List<PMSDataWrapper.LeaseItems>();
       litmList.add(litms);
        dt.leaseItems =litmList;
       PMSDataWrapper.ValidationErrorsList vel = new PMSDataWrapper.ValidationErrorsList();
        vel.errorMessage = '';vel.errorNumber=null;vel.validationType='';
       PMSDataWrapper.PMSLeaseResponse pmsRes = new PMSDataWrapper.PMSLeaseResponse();
       pmsRes.errorMessage = ''; pmsRes.isSuccess = false; pmsRes.type = ''; pmsRes.Id = '';
        PMSDataWrapper.TenantInformation ti = new PMSDataWrapper.TenantInformation();
        ti.tenantType = '';ti.emiratesID = '';ti.passportNo = '';ti.visaNo = '';ti.visaStartDt = '';
        ti.visaEndDt = '';ti.mobileNo = '';ti.email = '';ti.poBox = '';ti.licenseInformation = lci;ti.name = nm;
        PMSDataWrapper.ContractInformation cinfo = new PMSDataWrapper.ContractInformation();
       cinfo.makaniNumber = '';cinfo.uaeNGNumber = '';cinfo.contractNumber = ''; cinfo.startDate = '';cinfo.endDate = '';
       cinfo.contractAnnualAmount = null;cinfo.contractAmount = null;cinfo.areaZone = az; cinfo.location =az;cinfo.authorityInformation = ai;
       cinfo.licenseInformation = lci;cinfo.geoLocation = gl;cinfo.communityInformation = ci; cinfo.landLordInformation = li;cinfo.tenantInformation = ti;
       cinfo.versionNumber = null;cinfo.parcelID = null;cinfo.landNumber = null;cinfo.buildingName = null;
       List<PMSDataWrapper.PropertyInformationList> pinfoLst = new List<PMSDataWrapper.PropertyInformationList>();
        pinfoLst.add(pi);
        cinfo.propertyInformationList = pinfoLst;
        PMSDataWrapper.Response res = new PMSDataWrapper.Response();
       res.additionalData = '';
       List<PMSDataWrapper.ContractInformation> ciLst = new List<PMSDataWrapper.ContractInformation>();
       ciLst.add(cinfo);
       res.contractInformation = ciLst;
       List<PMSDataWrapper.LookupItems> lkList = new List<PMSDataWrapper.LookupItems>();
       lkList.add(lkp);
       res.lookupItems = lkList;
       pms.dedLicenseNumber = '';pms.contractNumber = ''; pms.timeStamp = ''; pms.responseCode = '';
       pms.response = res;pms.methodName = '';
       List<PMSDataWrapper.Data> dLst = new List<PMSDataWrapper.Data>();
       dLst.add(dt);
       List<PMSDataWrapper.ValidationErrorsList> validationErrorsList = new List<PMSDataWrapper.ValidationErrorsList>();
       validationErrorsList.add(vel);
       pms.ValidationErrorsList =validationErrorsList;
       pms.data = dLst;
      Test.stopTest();
  }

    public static testmethod void meth2() {
      Test.startTest();
       PMSContractDataWrapper pms = new PMSContractDataWrapper();

       PMSContractDataWrapper.PropertyInformationList pi = new PMSContractDataWrapper.PropertyInformationList();
       pi.ejariBusPropertyTypeId = '';pi.approvalRefNumber='';pi.unitNumber='';
       pi.area='';pi.dewa='';pi.propertyTypeId='';pi.propertyType='';pi.propertySubTypeId='';
       pi.propertySubType='';pi.propertyUsageId='';pi.propertyUsage='';
       PMSContractDataWrapper.Name nm = new PMSContractDataWrapper.Name();
       nm.englishName = '';nm.arabicName='';
       PMSContractDataWrapper.CommunityInformation ci = new PMSContractDataWrapper.CommunityInformation();
       ci.code = 123; ci.name='';
       PMSContractDataWrapper.LandLordInformation li = new PMSContractDataWrapper.LandLordInformation();
       li.name = nm;
       PMSContractDataWrapper.AreaZone az = new PMSContractDataWrapper.AreaZone();
       az.code = 123;az.name=nm;
       PMSContractDataWrapper.LicenseAuthorityInformation lai = new PMSContractDataWrapper.LicenseAuthorityInformation();
       lai.code=123;lai.name=nm;lai.id='';
       PMSContractDataWrapper.LicenseInformation lci = new PMSContractDataWrapper.LicenseInformation();
       lci.initialApprovalNumber = '123'; lci.licenseNumber = '';lci.licenseAuthorityInformation=lai;
       PMSContractDataWrapper.GeoLocation gl = new PMSContractDataWrapper.GeoLocation();
       gl.latitude = '';gl.longitude = '';
       PMSContractDataWrapper.AuthorityInformation ai = new PMSContractDataWrapper.AuthorityInformation();
       ai.code = '';ai.id = ''; ai.name = '';

       PMSContractDataWrapper.ValidationErrorsList vel = new PMSContractDataWrapper.ValidationErrorsList();
        vel.errorMessage = '';vel.errorNumber=null;vel.validationType='';

        PMSContractDataWrapper.TenantInformation ti = new PMSContractDataWrapper.TenantInformation();
        ti.tenantType = '';ti.emiratesID = '';ti.passportNo = '';ti.visaNo = '';ti.visaStartDt = '';
        ti.visaEndDt = '';ti.mobileNo = '';ti.email = '';ti.poBox = '';ti.licenseInformation = lci;ti.name = nm;
        PMSContractDataWrapper.ContractInformation cinfo = new PMSContractDataWrapper.ContractInformation();
       cinfo.makaniNumber = '';cinfo.uaeNGNumber = '';cinfo.contractNumber = ''; cinfo.startDate = '';cinfo.endDate = '';
       cinfo.contractAnnualAmount = null;cinfo.contractAmount = null;cinfo.areaZone = az; cinfo.location =az;cinfo.authorityInformation = ai;
       cinfo.licenseInformation = lci;cinfo.geoLocation = gl;cinfo.communityInformation = ci; cinfo.landLordInformation = li;cinfo.tenantInformation = ti;
       cinfo.versionNumber = null;cinfo.parcelID = null;cinfo.landNumber = null;cinfo.buildingName = null;
       List<PMSContractDataWrapper.PropertyInformationList> pinfoLst = new List<PMSContractDataWrapper.PropertyInformationList>();
        pinfoLst.add(pi);
        cinfo.propertyInformationList = pinfoLst;
        PMSContractDataWrapper.Response res = new PMSContractDataWrapper.Response();
       res.additionalData = '';
       List<PMSContractDataWrapper.ContractInformation> ciLst = new List<PMSContractDataWrapper.ContractInformation>();
       ciLst.add(cinfo);

       pms.dedLicenseNumber = '';pms.contractNumber = ''; pms.timeStamp = ''; pms.responseCode = '';
       pms.response = res;
       res.contractInformation = cinfo;

       List<PMSContractDataWrapper.ValidationErrorsList> validationErrorsList = new List<PMSContractDataWrapper.ValidationErrorsList>();
       validationErrorsList.add(vel);
       pms.ValidationErrorsList =validationErrorsList;
       PMSLeaseAmdInfo pmi = new PMSLeaseAmdInfo();
        pmi.invMsg = ''; pmi.leaseAreaCRM = null; pmi.leaseAreaEjari = null; pmi.leaseAreaDiff = null;pmi.visaQuota=null;
      Test.stopTest();
  }
}