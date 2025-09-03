/**
 * @author Wasim Khadaroo
 * @date 2025-09-03
 * @group Tests
 * @description Test class for WS001_CalendarificService
 */
@IsTest
private class WS001_CalendarificService_TEST {
    private class MockHttp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            System.assert(req.getEndpoint().contains('country=ZA'));
            HttpResponse r = new HttpResponse();
            r.setStatusCode(200);
            r.setBody('{"response":{"holidays":[{"name":"New Year\'s Day","description":"New Year","date":{"iso":"1980-01-01"},"type":["National holiday"]}]}}');
            return r;
        }
    }

    @IsTest static void testGetZAHolidays() {
        Test.setMock(HttpCalloutMock.class, new MockHttp());
        Test.startTest();
        List<WRP_Types.Holiday> hs = WS001_CalendarificService.getZAHolidays(1980);
        Test.stopTest();
        System.assertEquals(1, hs.size());
        System.assertEquals('New Year\'s Day', hs[0].name);
        System.assertEquals('1980-01-01', hs[0].dateIso);
    }
}