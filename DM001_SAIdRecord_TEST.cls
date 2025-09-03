/**
 * @author Wasim Khadaroo
 * @date 2025-09-03
 * @group Tests
 * @description Test class for DM001_SAIdRecord
 */
@IsTest
private class DM001_SAIdRecord_TEST {
    @IsTest static void testUpsertAndQuery() {
        SAIdRecord__c rec = new SAIdRecord__c(
            IdNumber__c = '8001015009087',
            DateOfBirth__c = Date.newInstance(1980,1,1),
            Gender__c = 'Male',
            IsCitizen__c = true,
            SearchCount__c = 1
        );

        Test.startTest();
        DM001_SAIdRecord.upsertRecords(new List<SAIdRecord__c>{ rec });
        Test.stopTest();

        List<SAIdRecord__c> fetched = DM001_SAIdRecord.byIdNumbers(new Set<String>{ '8001015009087' });
        System.assertEquals(1, fetched.size());
        System.assertEquals('Male', fetched[0].Gender__c);
    }
}