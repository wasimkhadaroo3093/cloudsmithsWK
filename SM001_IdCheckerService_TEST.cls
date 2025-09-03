/**
 * @author Wasim Khadaroo
 * @date 2025-09-03
 * @group Tests
 * @description Test class for SM001_IdCheckerService
 */
@IsTest
private class SM001_IdCheckerService_TEST {

    private class MockHttp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse r = new HttpResponse();
            r.setStatusCode(200);
            r.setBody('{"response":{"holidays":[{"name":"Demo Day","description":"Test","date":{"iso":"1980-01-01"},"type":["National holiday"]}]}}');
            return r;
        }
    }

    @IsTest
    static void testDecodeAndSave() {
        Test.startTest();
        WRP_Types.IdResult r1 = SM001_IdCheckerService.decodeAndSave('8001015009087');
        Test.stopTest();

        System.assertEquals(true, r1.valid);
        SAIdRecord__c rec = [SELECT SearchCount__c, Gender__c, IsCitizen__c, DateOfBirth__c
                             FROM SAIdRecord__c WHERE IdNumber__c = '8001015009087' LIMIT 1];
        System.assertEquals(1, rec.SearchCount__c);
        System.assertEquals('Male', rec.Gender__c);
        System.assertEquals(true, rec.IsCitizen__c);
        System.assertEquals(Date.newInstance(1980,1,1), rec.DateOfBirth__c);
    }

    @IsTest
    static void testFetchHolidays() {
        Test.setMock(HttpCalloutMock.class, new MockHttp());

        Test.startTest();
        List<WRP_Types.Holiday> hols = SM001_IdCheckerService.fetchZAHolidaysByYear(1980);
        Test.stopTest();

        System.assertEquals(1, hols.size());
        System.assertEquals('Demo Day', hols[0].name);
        System.assertEquals('1980-01-01', hols[0].dateIso);
    }
}