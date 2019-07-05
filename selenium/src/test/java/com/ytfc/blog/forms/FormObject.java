package com.ytfc.blog.forms;

import java.util.HashMap;

import org.openqa.selenium.WebDriver;

public class FormObject {
    protected WebDriver driver;
    protected HashMap<String, FormField> fields;

    // TODO Support more than one button
    protected FormButton button;

    public FormObject(WebDriver driver) {
        this.driver = driver;
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
