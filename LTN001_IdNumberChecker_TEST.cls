/**
 * @author Wasim Khadaroo
 * @date 2025-09-03
 * @group Tests
 * @description Test class for LTN001_IdNumberChecker
 */
@IsTest
private class LTN001_IdNumberChecker_TEST {

    private class MockHttp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse r = new HttpResponse();
            r.setStatusCode(200);
            r.setBody('{"response":{"holidays":[{"name":"Another Day","description":"Demo","date":{"iso":"1980-02-01"},"type":["Public holiday"]}]}}');
            return r;
        }
    }

    @IsTest
    static void testDecodeAndSave() {
        Test.startTest();
        WRP_Types.IdResult result = LTN001_IdNumberChecker.decodeAndSave('8001015009087');
        Test.stopTest();

        System.assert(result.valid);
        System.assertEquals('Male', result.gender);
    }

    @IsTest
    static void testFetchHolidays() {
        Test.setMock(HttpCalloutMock.class, new MockHttp());

        Test.startTest();
        List<WRP_Types.Holiday> hols = LTN001_IdNumberChecker.fetchHolidays(1980);
        Test.stopTest();

        System.assertEquals(1, hols.size());
        System.assertEquals('Another Day', hols[0].name);
        System.assertEquals('1980-02-01', hols[0].dateIso);
    }
}