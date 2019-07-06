package com.ytfc.blog.testcases;

import org.testng.annotations.Test;

public class HomePageTest extends TestObject {

    @Test
    public void emptyHomePage() {
        var homePage = homePage();
        homePage.get();

        // No songs added, so must be empty
        homePage.assertSongCount(0, "No songs on empty home page");
    }
    
}
