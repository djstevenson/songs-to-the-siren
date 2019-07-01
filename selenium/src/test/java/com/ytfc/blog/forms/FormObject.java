package com.ytfc.blog.forms;

import java.util.HashMap;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.testng.Assert;

public class FormObject {
    protected WebDriver driver;
    protected HashMap<String, FormField> fields;

    // TODO Support more than one button
    protected FormButton button;

    public FormObject(WebDriver driver) {
        this.driver = driver;
    }

    public void assertLegend(String expected, String message) {
        var actual = driver
            .findElement(By.cssSelector("form > legend"))
            .getText();
        Assert.assertEquals(actual, expected, message);
    }

    public FormField getField(String key) {
        return fields.get(key);
    }


    public FormButton getButton() {
        return button;
    }

    public void assertFieldTypes(String message) {
        for (var fieldName : fields.keySet()) {
            var f = fields.get(fieldName);
            f.assertType(message + " : " + fieldName);
        }

    }
}
