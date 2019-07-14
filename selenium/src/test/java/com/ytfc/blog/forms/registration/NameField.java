package com.ytfc.blog.forms.registration;

import com.ytfc.blog.forms.FormField;

import org.openqa.selenium.WebDriver;

public class NameField extends FormField {

    public NameField(WebDriver driver) {
        super(driver, "text", "user-register-name");
    }

    
}
