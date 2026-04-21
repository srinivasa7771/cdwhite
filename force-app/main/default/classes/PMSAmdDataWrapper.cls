public class PMSAmdDataWrapper {

    public class UnitInfo implements Comparable{
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
        public String buildingAr {set;get;}
        public String contractNo {set;get;}
        public String contractStartDate {set;get;}
        public String contractEndDate {set;get;}
        public decimal areaSm {set;get;}
        public decimal areaSft {set;get;}
        public String usage {set;get;}
        public String sts {set;get;}
        public integer compareTo(Object recordTocompare) {
            return sts.compareTo(((UnitInfo)recordTocompare).sts);
        }

    }

}