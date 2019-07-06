package com.ytfc.blog.forms;

import java.util.HashMap;

import com.ytfc.blog.forms.registration.NameField;
import com.ytfc.blog.forms.registration.EmailField;
import com.ytfc.blog.forms.registration.PasswordField;

import org.openqa.selenium.WebDriver;

public class RegisterForm extends FormObject {

    public RegisterForm(WebDriver driver) {
        super(driver);

        fields = new HashMap<String, FormField>();

        fields.put("name", new NameField(driver));
        fields.put("email", new EmailField(driver));
        fields.put("password", new PasswordField(driver));
    }


}
