@isTest
private class ParkingDetailsTest {
    static testmethod void test1() {
        ParkingDetails pd1 = new ParkingDetails('test123', 'test123', true, 'test123', 'test123',
            'test123', 'test123', 'test123', 'test123', 'test123', 'test123', 'test123', 'test123',
            'test123', 'test123',
                                                'test123', 'test123', 'test123');
        ParkingDetails pd2 = new ParkingDetails('test12345', 'test12345', true, 'test12345',
            'test12345', 'test12345', 'test12345', 'test12345', 'test12345', 'test12345', 'test12345',
            'test12345', 'test12345',
                                                'test12345', 'test12345', 'test12345', 'test12345', 'test12345');
        pd2.compareTo(pd1);

    }
}