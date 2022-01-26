@IsTest
private class MathUtilsTest {

    //Positive Test
    @IsTest
    static void calculateAverageTest() {
        List<Decimal> testList = new List <Decimal>{2.4, 4.6, 6.8};
        test.startTest();
        Decimal actualResult = MathUtils.calculateAverage(testList);
        test.stopTest();

        System.assertEquals(
                4.6,
                actualResult,
                'Wrong value returned'
        );
    }

    //Positive Test
    @IsTest
    static void calculateAverageWrongInputTest() {
        List<Decimal> testList = new List <Decimal>{};
        test.startTest();
        Decimal actualResult = MathUtils.calculateAverage(testList);
        test.stopTest();

        System.assertEquals(
                0.0,
                actualResult,
                'Should return 0.0'
        );
    }
}