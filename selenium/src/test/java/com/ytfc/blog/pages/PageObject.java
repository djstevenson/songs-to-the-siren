package com.ytfc.blog.pages;

import com.ytfc.blog.utility.ConfigDataProvider;

import org.testng.Assert;


// TODO Docs

import com.ytfc.blog.SeleniumBase;

public class PageObject extends SeleniumBase {
    protected ConfigDataProvider config = new ConfigDataProvider();  // TODO Singleton?

    public String getPageTitle() {
        return driver.getTitle();
    }

    public void assertPageTitle(String expected, String msg) {
        Assert.assertEquals(getPageTitle(), expected, msg);
    }


}
