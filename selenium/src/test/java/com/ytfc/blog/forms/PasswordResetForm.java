package com.ytfc.blog.forms;

import java.util.HashMap;

import com.ytfc.blog.forms.reset.PasswordField;

import org.openqa.selenium.WebDriver;

public class PasswordResetForm extends FormObject {

    public PasswordResetForm(WebDriver driver) {
        super(driver);

        fields = new HashMap<String, FormField>();

        fields.put("password", new PasswordField(driver));
    }


}
