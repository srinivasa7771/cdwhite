@isTest
public class PMSAmdDataWrapperTest {

    // Helper method to create a UnitInfo object
    public static PMSAmdDataWrapper.UnitInfo createUnitInfo(String unitNoEn, String status) {
        PMSAmdDataWrapper.UnitInfo unit = new PMSAmdDataWrapper.UnitInfo();
        unit.unitNoEn = unitNoEn;
        unit.unitNoAr = 'وحدة ' + unitNoEn;
        unit.approvalReferenceNumber = 'AR-' + unitNoEn;
        unit.dewa = '123456';
        unit.propertyTypeEn = 'Residential';
        unit.propertyTypeAr = 'سكني';
        unit.propertySubTypeEn = 'Apartment';
        unit.propertySubTypeAr = 'شقة';
        unit.floor = '5';
        unit.building = 'Building ' + unitNoEn;
        unit.buildingAr = 'مبنى ' + unitNoEn;
        unit.contractNo = 'C-' + unitNoEn;
        unit.contractStartDate = '2024-01-01';
        unit.contractEndDate = '2024-12-31';
        unit.areaSm = 100.0;
        unit.areaSft = 1076.39;
        unit.usage = 'Residential';
        unit.sts = status;
        return unit;
    }

    @isTest
    static void testUnitInfoCompareTo() {
        // Create two UnitInfo objects with different status
        PMSAmdDataWrapper.UnitInfo unit1 = createUnitInfo('101', 'Active');
        PMSAmdDataWrapper.UnitInfo unit2 = createUnitInfo('102', 'Inactive');

    }

}