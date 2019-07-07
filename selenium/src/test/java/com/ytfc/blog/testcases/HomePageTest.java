package com.ytfc.blog.testcases;

import org.testng.annotations.Test;

public class HomePageTest extends TestObject {

    @Test
    public void homePageSongCount() {
        var homePage = homePage();
        homePage.get();

        // No songs added, so must be empty
        homePage.assertSongCount(0, "No songs on empty home page");

        // Add a single unpublished song, shoud still be empty.


        // Add a second unpublished song, shoud still be empty.

        // Publish first, count should be 1.
        // Publish second, count should be 2.
        // Unublish first, count should be 1.

        // Delete all songs
    }
}
