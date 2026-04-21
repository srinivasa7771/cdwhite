@isTest
private class JsonUtilitiesTest {
    static testmethod void getValuesFromJsonTest1() {
        try{
            JsonUtilities.getValuesFromJson('');
        }catch (Exception e) {
            system.assertEquals(true, e.getMessage().contains('Json String'));
        }

    }
    static testmethod void getValuesFromJsonTest2() {
        Map<String, Object> mp = new map<String, Object>();
        String str = Json.serialize(mp);
        try{
            JsonUtilities.getValuesFromJson(str);
        }catch (Exception e) {
            system.assertEquals(true, e.getMessage().contains('Json String'));
        }

    }

}